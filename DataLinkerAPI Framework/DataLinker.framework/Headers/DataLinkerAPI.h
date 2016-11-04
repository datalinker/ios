//
//  DataLinkerAPI.h
//  DataLinkerAPI
//
//  Created by Julius Petraška on 2/11/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataLinker.h"

@interface DataLinkerAPI : NSObject {
    NSString *callbackURLScheme;
    DataLinker *dataLinker;
}
/* --
 This method initializes DataLinkerAPI with your selected callback URL scheme.
 The scheme should be the one which your application have registered and handles.
 -- */
+ (void)setCallBackScheme:(NSString*)callBackScheme;
/* --
 This method opens DataLinker Server app and lets user to connect to DataLinker device.
 After the connection is estabilished, it returns back to your app.
 -- */
+ (void)connect;

/* This method opens DataLinker Server app, disconnects from currently connected
 peripheral and instantly returns back to your app.
 -- */
+ (void)disconnect;

/* --
 This method handles DataLinker Server app response.
    If connection was estabilished to DataLinker it DataLinker object,
        which will provide you with data stream.
    Otherwise it will return nil.
 -- */
+ (DataLinker*)handleResponseURL:(NSURL *)url;

@end
