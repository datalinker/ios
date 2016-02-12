//
//  DataLinkerIntegrationController.m
//  DataLinkerExample
//
//  Created by Julius Petraška on 2/12/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import "DataLinkerIntegrationController.h"
#import "ViewController.h"

#define DataLinkerExampleCustomURLScheme @"DataLinkerExample"
@implementation DataLinkerIntegrationController
+ (DataLinkerIntegrationController *)sharedController {
    static dispatch_once_t once;
    static DataLinkerIntegrationController *instance;
    dispatch_once(&once, ^{
        instance = [[DataLinkerIntegrationController alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        dataLinkerManager = [[DataLinkerAPI alloc] initWithCallbackURLScheme:DataLinkerExampleCustomURLScheme];
    }
    return self;
}
#pragma mark -
#pragma mark DataLinker Integration
/* --
 We call this method when we want to connect to DataLinker.
 -- */
- (void)connectToDataLinkerWithPeripheralId:(NSString*)peripheralId
                                   baudRate:(NSString*)bRate
                                warnVoltage:(NSString*)wVoltage
                                    tcpPort:(NSString*)port {
    
    /* --
     This method of DataLinkerAPI will generate you an URL with
     given DataLinker UUID and settings.
     -- */
    NSURL *url = [dataLinkerManager urlForConnectingToDataLinkerWithUUID:peripheralId
                                                         baudRate:bRate.intValue
                                                      warnVoltage:wVoltage.intValue
                                                          tcpPort:port.intValue];
    
    /* -- All you have to do is to pass the generated URL to your application. -- */
    [[UIApplication sharedApplication] openURL:url];
}

/* --
 We call this method when we want to disconnect from DataLinker.
 -- */
- (void)disconnectFromDataLinkerWithPeripheralId:(NSString*)peripheralId  {
    /* --
     This method of DataLinkerAPI will generate you an URL with
     given UUID of DataLinker you want to disconnect from
     -- */
    NSURL *url = [dataLinkerManager urlForDisconnectingFromDataLinkerWithUUID:peripheralId];
    
    /* -- All you have to do is to pass the generated URL to your application. -- */
    [[UIApplication sharedApplication] openURL:url];
}

/* --
 This method will get called from AppDelegate application:openURL:options:
 when response from DataLinkerServer comes in.
 
 Here we will handle DataLinker Server response.
 In your application you should handle it differently according to your needs.
 -- */
- (void)handleDataLinkerResponseURL:(NSURL*)url {
    /* -- Pass URL to DataLinkerAPI and it will return you dictionary with
     all the information that was sent to you within URL -- */
    
    NSDictionary *responseDictionary = [dataLinkerManager dataLinkerResponseWithURL:url];
    /*"DataLinkerExample://datalinker_connected?pid=781DEBC4-0B6B-2502-4E19-23EA028E7B14&brate=19200&wvoltage=8&port=2000"*/
    /* --
     There will always by an object (NSString*) for key "type".
     This object indicates what kind of response you got.
     -- */
    
    NSString *responseType = [responseDictionary objectForKey:@"type"];
    
    if ([responseType isEqualToString:@"connected"]) {
        /* --
         As described in DataLinkerAPI.h in response of successful connection dictionary there is:
         - key "peripheral_uuid" which keeps value of connected DataLinker uuid string
         - key "baud_rate" which keeps value of baud rate for connected DataLinker
         - key "warn_voltage" which keeps value of warn. voltage for connected DataLinker
         - key "tcp_port" which keeps value of TCP port number on whick DataLinker server is streaming NMEA sentences
         -- */
        
        NSString *peripheralUUID = [responseDictionary objectForKey:@"peripheral_uuid"];
        NSString *baudRate = [responseDictionary objectForKey:@"baud_rate"];
        NSString *warnVoltage = [responseDictionary objectForKey:@"warn_voltage"];
        NSString *tcpPort = [responseDictionary objectForKey:@"tcp_port"];
        
        [(ViewController*)[[UIApplication sharedApplication] delegate].window.rootViewController updateInterfaceAfterSuccessfulConnectionWithPeripheralId:peripheralUUID
                                                                                                                                                 baudRate:baudRate
                                                                                                                                              warnVoltage:warnVoltage
                                                                                                                                                  tcpPort:tcpPort];
    } else if ([responseType isEqualToString:@"disconnected"]) {
        /* --
         As described in DataLinkerAPI.h in response of successful disconnection dictionary there is:
         - key "peripheral_uuid" which keeps value of connected DataLinker uuid string
         -- */
        NSString *peripheralUUID = [responseDictionary objectForKey:@"peripheral_uuid"];
        
        [(ViewController*)[[UIApplication sharedApplication] delegate].window.rootViewController updateInterfaceAfterSuccessfulDisonnectionFromPeripheralWithId:peripheralUUID];
    }
}
@end
