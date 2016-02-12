//
//  TCPServerController.m
//  DataLinkerExample
//
//  Created by Julius Petraška on 2/11/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import "TCPServerController.h"

@implementation TCPServerController
+ (TCPServerController *)sharedController {
    static dispatch_once_t once;
    static TCPServerController *instance;
    dispatch_once(&once, ^{
        instance = [[TCPServerController alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        receivedSentences = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)startListeningForTCPServer:(NSString*)serverIp onPort:(NSString*)portAddress {
    tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    hostname = serverIp;
    NSError *error = nil;
    uint16_t port = (uint16_t)portAddress.intValue;
    if (![tcpSocket connectToHost:serverIp onPort:port error:&error]) {
        NSLog(@"Error occured while starting TCP Listener.");
        NSLog(@"Error: %@|%@", error, error.localizedDescription);
        return;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    if ([host isEqualToString:hostname]) {
        [sock readDataWithTimeout:10 tag:-1];
    }
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [self processReceivedData:data];
    [sock readDataWithTimeout:10 tag:-1];
}
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
    return 0;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
}

#pragma mark -
#pragma mark Received data processing
- (void)processReceivedData:(NSData*)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *nmeaArray = [string componentsSeparatedByString:@"\r\n"];
    for (NSString *nmeaString in nmeaArray) {
        if ([nmeaString rangeOfString:@"\r"].location == NSNotFound) {
            [self handleNMEAString:nmeaString];
        } else {
            [self handleNMEAString:[nmeaString stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }
    }
}

- (void)handleNMEAString:(NSString*)nmeaString {
    if (receivedSentences.count > 5) {
        [receivedSentences removeObjectAtIndex:0];
    }
    
    [receivedSentences addObject:nmeaString];
    
    if ([self.delegate respondsToSelector:@selector(tcpServerController:didReadData:)]) {
        [self.delegate tcpServerController:self didReadData:[NSArray arrayWithArray:receivedSentences]];
    }
}

@end
