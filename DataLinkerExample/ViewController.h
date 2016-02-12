//
//  ViewController.h
//  testApplication
//
//  Created by Julius Petraška on 2/9/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBCentralManagerController.h"
#import "TCPServerController.h"
#import "DataLinkerAPI.h"

@interface ViewController : UIViewController    <CBCentralManagerControllerDelegate,
                                                 UIPickerViewDelegate,
                                                 UIPickerViewDataSource,
                                                 UITextFieldDelegate,
                                                 TCPServerControllerDelegate> {
                                                     
                                                     
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    IBOutlet UIView *containerViewForPeripheralPicker;
    IBOutlet UILabel *selectedPeripheralTitle;
    IBOutlet UILabel *receivedSentences;
    
    IBOutlet UIView *containerViewForReceivedSentences;
    IBOutlet UIPickerView *peripheralPicker;
    IBOutlet UIButton *selectPeripheralButton;
    
    IBOutlet UIView *containerForSettings;
    IBOutlet UITextField *baudRateField;
    IBOutlet UITextField *warnVoltageField;
    IBOutlet UITextField *portField;
    
    IBOutlet UILabel *instructionsLabel;
    
    IBOutlet UIButton *button;
    
    NSArray *availablePeripherals;
    CBPeripheral *selectedPeripheral;
    
    NSInteger selectedPeripheralId;
    
    NSString *peripheralUUID;
    NSString *baudRate;
    NSString *warnVoltage;
    NSString *tcpPort;
                                                     
   DataLinkerAPI *dataLinker;
}
- (void)updateInterfaceAfterSuccessfulConnectionWithPeripheralId:(NSString*)peripheral baudRate:(NSString*)brate warnVoltage:(NSString*)wvoltage tcpPort:(NSString*)port;
- (void)updateInterfaceAfterSuccessfulDisonnectionFromPeripheralWithId:(NSString*)peripheral;
@end

