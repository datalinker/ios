//
//  DataLinkerIntegrationController.h
//  DataLinkerExample
//
//  Created by Julius Petraška on 2/12/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DataLinkerAPI.h"

@interface DataLinkerIntegrationController : NSObject {
    DataLinkerAPI *dataLinkerManager;
}
+ (DataLinkerIntegrationController*)sharedController;
- (void)handleDataLinkerResponseURL:(NSURL*)url;
- (void)connectToDataLinkerWithPeripheralId:(NSString*)peripheralId
                                   baudRate:(NSString*)bRate
                                warnVoltage:(NSString*)wVoltage
                                    tcpPort:(NSString*)port;
- (void)disconnectFromDataLinkerWithPeripheralId:(NSString*)peripheralId;
@end
