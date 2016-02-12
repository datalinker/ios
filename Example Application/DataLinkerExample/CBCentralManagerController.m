//
//  CBCentralManagerController.m
//  testApplication
//
//  Created by Julius Petraška on 2/9/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import "CBCentralManagerController.h"

@implementation CBCentralManagerController
+ (instancetype)sharedInstance {
    static CBCentralManagerController *_sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedController = [[CBCentralManagerController alloc] init];
    });
    return _sharedController;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.centralManager = [[CBCentralManager alloc] init];
        self.centralManager.delegate = self;
        discoveredPeripherals = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)scanForPeripherals {
    
    while (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        
    }
    
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(finishScanningForPeripherals) userInfo:nil repeats:NO];
}
- (void)finishScanningForPeripherals {
    [self.centralManager stopScan];
    
    if ([self.delegate respondsToSelector:@selector(centralManagerController:didFinishWithPeripherals:)])
        [self.delegate centralManagerController:self didFinishWithPeripherals:[NSArray arrayWithArray:discoveredPeripherals]];
    
    [discoveredPeripherals removeAllObjects];
}

#pragma mark -
#pragma mark CBCentralManagerDelegate Protocol
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // Handle central manager state updates
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    [discoveredPeripherals addObject:peripheral];
}
@end
