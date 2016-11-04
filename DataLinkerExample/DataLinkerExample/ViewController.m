//
//  ViewController.m
//  DataLinkerExample
//
//  Created by Julius Petraška on 11/4/16.
//  Copyright © 2016 SailRacer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* --
     Because DataLinkerAPI uses inter-app communication, responses are received 
     in AppDelegate and we need to communicate those responses to our class.
     In this example application we will use NSNotificationCenter to communicate 
     messages from AppDelegate. You might chose different way of handling that.
     -- */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataLinkerServerAppDidRespond:)
                                                 name:@"DataLinkerServerAppDidRespond"
                                               object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataLinker handling
- (void)connect {
    /* --
     To connect to DataLinker using DataLinkerAPI all you have to do is call 
     -(void)connect method of DataLinkerAPI class. It will switch to 
     DataLinkerServer app, wait till user connects to DataLinker and then 
     return to your app. If user doesn't have DataLinkerServer app installed, 
     it wil redirect user straight to AppStore.
     -- */
    [DataLinkerAPI connect];
}

- (void)disconnect {
    /* --
     Disconnecting from DataLinker is just as easy as connecting to it. All you 
     have to do is call -(void)disconnect method of DataLinkerAPI class. Again 
     there will be some automatic switching between apps, and it will return to 
     your app automatically.
     -- */
    [DataLinkerAPI disconnect];
}

- (void)dataLinkerServerAppDidRespond:(NSNotification*)notification {
    /* --
     In AppDelegate when building this notification, we set response URL object 
     in notification's userInfo dictionary for key @"url". Now we retrieve it.
     -- */
    NSURL *responseURL = [[notification userInfo] objectForKey:@"url"];
    
    /* --
     And when we have DataLinkerServer app's response URL, we can let 
     DataLinkerAPI handle it for us. It will either return DataLinker object if 
     connection was made, or nil if it wasn't.
     -- */
    dataLinker = [DataLinkerAPI handleResponseURL:responseURL];
    
    if (dataLinker) {
        /* --
         If dataLinker object is not nil it means we have a successful 
         connection here. We have to set dataLinker's delegate to a class which 
         implements DataLinkerDelegate protocol and will respond to incomming 
         data and errors.
         -- */
        dataLinker.delegate = self;
        /* --
         After the delegate was set dataLinker will start streaming data to its 
         delegate, as soon as it receives some, through it's delegate methods.
         -- */
        
        [receivedDataView setText:@""];
    }
}

#pragma mark - DataLinkerDelegate
/* --
 DataLinker object will call this method of its delegate if it receives some
 error. Usually, after receiving error it should stop and delete itself, so you 
 will have to reconnect. It's a good place to notify user that something went wrong.
 -- */
- (void)dataLinker:(DataLinker *)dataLinker
  didStopWithError:(NSError *)error {
    if (error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ooops!"
                                                                                 message:[NSString stringWithFormat:@"Ooops. Something went wrong:\n%@", error.localizedDescription]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController
                           animated:true
                         completion:nil];
    }
}

/* --
 DataLinker object will call this method of its delegate everytime it receives 
 new data. It will contain DataLinker object, which received the data, the date 
 itself and the format of which the data is. It might be NMEA0183 or SignalK.
 -- */
- (void)dataLinker:(DataLinker *)dataLinker
    didReceiveData:(NSString *)data
        withFormat:(DataLinkerDataFormat)format {
    /* --
     It is not important, but just to show how you can act differently according 
     to format of received data, if we receive NMEA0183 data we will add this 
     data on top of the data received earlier. Otherwise if its SignalK data, 
     we replace all previously received data with the new one.
     -- */
    if (format == NMEA0183) {
        [receivedDataView setText:[data stringByAppendingString:receivedDataView.text]];
    } else if (format == SignalK) {
        [receivedDataView setText:data];
    }
}
#pragma mark - User interaction
- (IBAction)connectionButtonTapped:(UIButton*)sender {
    if ([sender.titleLabel.text isEqualToString:@"Connect"]) {
        [sender setTitle:@"Disconnect"
                forState:UIControlStateNormal];
        [self connect];
    } else if ([sender.titleLabel.text isEqualToString:@"Disconnect"]) {
        [sender setTitle:@"Connect"
                forState:UIControlStateNormal];
        [self disconnect];
    }
}

- (IBAction)clearButtonTapped:(UIButton*)sender {
    [receivedDataView setText:@""];
}


@end
