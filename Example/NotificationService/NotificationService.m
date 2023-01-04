//
//  NotificationService.m
//  NotificationService
//
//  Created by Rakshitha on 22/12/21.
//  Copyright © 2021 Prateek Srivastava. All rights reserved.
//

#import "NotificationService.h"
#import <MoEngageRichNotification/MoEngageRichNotification.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    [MoEngageSDKRichNotification setAppGroupID:@"group.com.alphadevs.MoEngage.NotificationServices"];
    [MoEngageSDKRichNotification handleWithRichNotificationRequest:request withContentHandler:contentHandler];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
