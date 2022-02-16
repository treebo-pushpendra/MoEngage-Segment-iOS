//
//  SEGAppDelegate.m
//  Segment-MoEngage
//
//  Created by Prateek Srivastava on 11/24/2015.
//  Copyright (c) 2015 Prateek Srivastava. All rights reserved.
//

#import "SEGAppDelegate.h"
#import <Segment/SEGAnalytics.h>
#import <SEGMoEngageIntegrationFactory.h>
#import <MoEngageSDK/MoEngageSDK.h>
#import <UserNotifications/UserNotifications.h>
#import <SEGMoEngageInitializer.h>

@interface  SEGAppDelegate()<UNUserNotificationCenterDelegate>

@end
@implementation SEGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    [SEGAnalytics debug:true];

    //TODO: Revert bundle id    
    MOSDKConfig* sdkConfig = [[MOSDKConfig alloc] initWithAppID:@"DAO6UGZ73D9RTK8B5W96TPYN"];
    sdkConfig.appGroupID = @"group.com.alphadevs.MoEngage.NotificationServices";
    [SEGMoEngageInitializer initializeDefaultInstance:sdkConfig];
    [MoEngage enableSDKLogs:true forAppID:sdkConfig.moeAppID];

    SEGAnalyticsConfiguration *configuration = [SEGAnalyticsConfiguration configurationWithWriteKey:@"6XjfktaG0LXHRwwn1quJwlW1Lo2Ol6WJ"];
    [configuration use:[SEGMoEngageIntegrationFactory instance]];
    configuration.trackApplicationLifecycleEvents = YES; // Enable this to record certain application events automatically!
    configuration.recordScreenViews = YES; // Enable this to record screen views automatically!
    [SEGAnalytics setupWithConfiguration:configuration];
    [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:nil];

    
    
    //Register for notification
    [[MoEngage sharedInstance] registerForRemoteNotificationWithCategories:nil withUserNotificationCenterDelegate:self];

    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[SEGAnalytics sharedAnalytics] registeredForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [[SEGAnalytics sharedAnalytics] receivedRemoteNotification:userInfo];
}

#pragma mark- UserNotifications delegate methods
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    [[MoEngage sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
    completionHandler();
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler((UNNotificationPresentationOptionSound
                       | UNNotificationPresentationOptionAlert));
}
@end
