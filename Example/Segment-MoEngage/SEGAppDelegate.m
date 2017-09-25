//
//  SEGAppDelegate.m
//  Segment-MoEngage
//
//  Created by Prateek Srivastava on 11/24/2015.
//  Copyright (c) 2015 Prateek Srivastava. All rights reserved.
//

#import "SEGAppDelegate.h"
#import <Analytics/SEGAnalytics.h>
#import <SEGMoEngageIntegrationFactory.h>
#import <MoEngage.h>

@implementation SEGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [MoEngage debug:LOG_ALL];
    SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"gpo0YN1hKt9gtwsjMZQ6IT42wRyA4BTA"];
    [configuration use:[SEGMoEngageIntegrationFactory instance]];
    configuration.trackApplicationLifecycleEvents = YES; // Enable this to record certain application events automatically!
    configuration.recordScreenViews = YES; // Enable this to record screen views automatically!
    [SEGAnalytics setupWithConfiguration:configuration];
    [[SEGAnalytics sharedAnalytics] identify:@"yf" traits:@{}];
    //[[SEGAnalytics sharedAnalytics] identify:@"uniqueID" traits:@{@"email":@"azs",@"mobile":@"1234561234"}];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
