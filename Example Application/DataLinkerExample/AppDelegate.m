//
//  AppDelegate.m
//  testApplication
//
//  Created by Julius Petraška on 2/9/16.
//  Copyright © 2016 Sail Racer. All rights reserved.
//

#import "AppDelegate.h"
#import "DataLinkerIntegrationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    NSURL *url = [NSURL URLWithString:@"datalinker://hello world&return=testapp"];
//    UIApplication *ourApplication = [UIApplication sharedApplication];
//    NSString *URLEncodedText = [@"connectTo:781DEBC4-0B6B-2502-4E19-23EA028E7B14//testApp:success=" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSString *ourPath = [@"datalinker://" stringByAppendingString:URLEncodedText];
//    NSURL *ourURL = [NSURL URLWithString:ourPath];
//    if ([ourApplication canOpenURL:ourURL]) {
//        [ourApplication openURL:ourURL];
//    }
//    else {
//        NSLog(@"Receiver Not Found");
//        NSLog(@"The Receiver App is not installed. It must be installed to send text.");
//    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[DataLinkerIntegrationController sharedController] handleDataLinkerResponseURL:url];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end