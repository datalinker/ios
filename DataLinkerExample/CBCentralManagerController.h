//
//  CBCentralManagerController.h
//  testApplication
//
//  Created by Julius Petraška on 2/9/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class CBCentralManagerController;
@protocol CBCentralManagerControllerDelegate <NSObject>
- (void)centralManagerController:(CBCentralManagerController*)controller didFinishWithPeripherals:(NSArray*)peripherals;
@end

@interface CBCentralManagerController : NSObject <CBCentralManagerDelegate> {
    NSMutableArray *discoveredPeripherals;
}

@property (nonatomic, weak) id<CBCentralManagerControllerDelegate> delegate;
@property CBCentralManager *centralManager;

+ (instancetype)sharedInstance;
- (void)scanForPeripherals;
@end
