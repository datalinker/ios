//
//  DataLinkerAPI.h
//  DataLinkerAPI
//
//  Created by Julius Petraška on 2/11/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataLinkerAPI : NSObject {
    NSString *callbackURLScheme;
}
/* --
 This method creates instance of DataLinkerAPI with your selected callback URL scheme. 
 The scheme should be the one which your application have registered and handles.
 -- */
- (instancetype)initWithCallbackURLScheme:(NSString*)callbackScheme;

/* -- 
 This method generates URL to connect to DataLinker with your given settings like:
    - DataLinker UUID
    - Baud Rate
    - Warn. Voltage
    - TCP Port
 -- */
- (NSURL*)urlForConnectingToDataLinkerWithUUID:(NSString*)pid
                                      baudRate:(int)brate
                                   warnVoltage:(int)wvoltage
                                       tcpPort:(int)port;

/* --
 This method generates URL to disconnect from DataLinker with your given UUID.
 -- */

- (NSURL*)urlForDisconnectingFromDataLinkerWithUUID:(NSString*)pid;

/* --
 This method returns you a dictionary with the response of DataLinker Server. 
 To determine what kind of response you got use string in dictionary for key 
    - "type"
 which value could be one of the fallowing:
 
    - "connected"       (Indicates successful connection to DataLinker)
    - "disconnected"    (Indicates successful disconnection from DataLinker)
 
 Response with type "connected" will contain the fallowing information (specified as "key" : "meaning"):
 
    - "pid"             : "UUID of connected DataLinker"
    - "baud_rate"       : "Baud rate of connected DataLinker"
    - "warn_voltage"    : "Warn. Voltage of connected DataLinker"
    - "tcp_port"        : "TCP Port to which DataLinker server streams NMEA sentences"
 
 Response with type "disconnected" will contain the fallowing information (specified as "key" : "meaning"):
 
 - "pid"             : "UUID of disconnected DataLinker"
 -- */
- (NSDictionary*)dataLinkerResponseWithURL:(NSURL*)url;

@end
