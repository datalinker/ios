//
//  AppDelegate.m
//  DataLinkerExample
//
//  Created by Julius Petraška on 11/4/16.
//  Copyright © 2016 SailRacer. All rights reserved.
//

#import "AppDelegate.h"
#import <DataLinker/DataLinker.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /* --
     You must set the callback URL scheme before using DataLinkerAPI. In this 
     example we do it as soon as application starts, but you might consider doing 
     just before using DataLinkerAPI.
     -- */
    [DataLinkerAPI setCallBackScheme:@"DataLinkerExampleDL"];
    
    return YES;
}

/* --
 Inter-app communication in iOS is based on URL's. To make your app openable 
 through specific URL scheme(s) you must implement this method.
 -- */
- (BOOL)application:(UIApplication*)application
            openURL:(nonnull NSURL *)url
            options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    /* --
     We choose to use "DataLinkerExampleDL" URL scheme to handle incoming 
     responses from DataLinkerServer app. So first of all we check if the url 
     has our prefix (because there might be more than one URL scheme your app 
     can handle) and if it does, we handle it appropriately. In all other cases 
     we return false, because we aren't going to handle any other URLs.
     -- */
    if ([[url absoluteString] rangeOfString:@"DataLinkerExampleDL://"].location != NSNotFound) {
        /* --
         Because in this app we are using NSNotificationCenter to deliver 
         messages from our AppDelegate to other classes, we build NSNotification 
         and pass it to default NSNotificationCenter.
         -- */
        NSNotification *notification = [NSNotification notificationWithName:@"DataLinkerServerAppDidRespond"
                                                                     object:nil
                                                                   userInfo:@{@"url" : url}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        return true;
    }
    return false;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
