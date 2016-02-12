//
//  TCPServerController.h
//  DataLinkerExample
//
//  Created by Julius Petraška on 2/11/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket.h>

@class TCPServerController;
@protocol TCPServerControllerDelegate <NSObject>
- (void)tcpServerController:(TCPServerController*)controller didReadData:(NSArray*)data;
@end

@interface TCPServerController : NSObject <GCDAsyncSocketDelegate> {
    GCDAsyncSocket *tcpSocket;
    NSString *hostname;
    NSMutableArray *receivedSentences;
}

@property (weak) id<TCPServerControllerDelegate> delegate;

+ (TCPServerController*)sharedController;
- (void)startListeningForTCPServer:(NSString*)serverIp onPort:(NSString*)portAddress;
@end
