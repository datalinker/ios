//
//  ViewController.m
//  testApplication
//
//  Created by Julius Petraška on 2/9/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import "ViewController.h"
#import "DataLinkerIntegrationController.h"

#define DataLinkerExampleCustomURLScheme @"DataLinkerExample"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [CBCentralManagerController sharedInstance].delegate = self;
    peripheralPicker.delegate = self;
    peripheralPicker.dataSource = self;
    [activityIndicator stopAnimating];
    
    dataLinker = [[DataLinkerAPI alloc] initWithCallbackURLScheme:DataLinkerExampleCustomURLScheme];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark User Interaction Handling
- (IBAction)buttonTapped:(id)sender {
    if (!selectedPeripheral) {
        containerViewForPeripheralPicker.hidden = YES;
        
        availablePeripherals = [NSArray array];
        [peripheralPicker reloadAllComponents];
        [[CBCentralManagerController sharedInstance] scanForPeripherals];
        
        containerForSettings.hidden = YES;
        [activityIndicator startAnimating];
        button.enabled = NO;
        [button setTitle:@"Scanning..." forState:UIControlStateNormal];
        instructionsLabel.text = @"Scanning...";
    } else if ([button.titleLabel.text isEqualToString:@"Connect"]) {
        [[DataLinkerIntegrationController sharedController] connectToDataLinkerWithPeripheralId:selectedPeripheral.identifier.UUIDString
                                         baudRate:baudRateField.text
                                      warnVoltage:warnVoltageField.text
                                          tcpPort:portField.text];
        
        instructionsLabel.text = @"Connecting to DataLinker...";
    } else if ([button.titleLabel.text isEqualToString:@"Disconnect"]) {
        [[DataLinkerIntegrationController sharedController] disconnectFromDataLinkerWithPeripheralId:selectedPeripheral.identifier.UUIDString];
        instructionsLabel.text = @"Disconnecting from DataLinker...";
    }
}

- (IBAction)selectPeripheral:(id)sender {
    selectedPeripheral = [availablePeripherals objectAtIndex:selectedPeripheralId];
    containerViewForPeripheralPicker.hidden = YES;
    containerViewForReceivedSentences.hidden = NO;
    
    button.alpha = 1.0;
    button.enabled = YES;
    
    selectedPeripheralTitle.text = [NSString stringWithFormat:@"Selected device: %@", selectedPeripheral.name];
    instructionsLabel.text = @"Press 'Connect' button.";
}

- (void)startTCPListenerOnPort:(NSString*)port {
    [[TCPServerController sharedController] setDelegate:self];
    [[TCPServerController sharedController] startListeningForTCPServer:@"127.0.0.1" onPort:port];
}
#pragma mark -
#pragma mark CBCentralManagerControllerDelegate Protocol
- (void)centralManagerController:(CBCentralManagerController *)controller didFinishWithPeripherals:(NSArray *)peripherals {
    if (peripherals.count < 1) {
        [activityIndicator stopAnimating];
        [button setTitle:@"Scan" forState:UIControlStateNormal];
        button.enabled = YES;
        instructionsLabel.text = @"No DataLinker device was found. If you're shure it is on and discoverable, try scanning again.";
        return;
    }
    availablePeripherals = peripherals;
    selectedPeripheral = [availablePeripherals firstObject];
    
    [peripheralPicker reloadAllComponents];
    
    [activityIndicator stopAnimating];
    containerViewForPeripheralPicker.hidden = NO;


    [button setTitle:@"Connect" forState:UIControlStateNormal];
    button.alpha = 0.5;
    instructionsLabel.text = @"Select your DataLinker.";
}

#pragma mark -
#pragma mark TCPServerControllerDelegate Protocol
- (void)tcpServerController:(TCPServerController *)controller didReadData:(NSArray *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *receivedStrings = [[NSMutableString alloc] init];
        for (NSString *nmeaString in data) {
            [receivedStrings appendString:[NSString stringWithFormat:@"%@", nmeaString]];
        }
        
        receivedSentences.text = receivedStrings;
    });
}
#pragma mark -
#pragma mark UIPickerViewDataSource Protocol
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return availablePeripherals.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark -
#pragma mark UIPickerViewDelegate Protocol
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedPeripheralId = row;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [(CBPeripheral*)[availablePeripherals objectAtIndex:row] name];
}

#pragma mark -
#pragma mark TextViewDelegate Protocol
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark UI handling
- (void)updateInterfaceAfterSuccessfulConnectionWithPeripheralId:(NSString*)peripheral baudRate:(NSString*)brate warnVoltage:(NSString*)wvoltage tcpPort:(NSString*)port {
    peripheralUUID = peripheral;
    baudRate = brate;
    warnVoltage = wvoltage;
    tcpPort = port;
    
    selectedPeripheralTitle.text = [NSString stringWithFormat:@"Connected to: %@; Baud rate: %@; Warn. Voltage = %@; Port: %@;",
                                    selectedPeripheral.name,
                                    baudRate, warnVoltage,
                                    tcpPort];
    
    containerViewForReceivedSentences.hidden = NO;
    
    [self startTCPListenerOnPort:tcpPort];
    
    [button setTitle:@"Disconnect" forState:UIControlStateNormal];
    instructionsLabel.text = @"Thats it. You are now listening for NMEA stream from DataLinker through TCP.";
}
- (void)updateInterfaceAfterSuccessfulDisonnectionFromPeripheralWithId:(NSString*)peripheral {
    peripheralUUID = peripheral;
    
    selectedPeripheral = nil;
    [button setTitle:@"Scan" forState:UIControlStateNormal];
    containerViewForReceivedSentences.hidden = YES;
    receivedSentences.text = @"";
    containerForSettings.hidden = NO;
    instructionsLabel.text = [NSString stringWithFormat:@"Disconnected from DataLinker with uuid: \n%@", peripheralUUID];
}
@end
