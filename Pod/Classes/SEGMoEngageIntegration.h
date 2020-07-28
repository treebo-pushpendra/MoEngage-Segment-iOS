#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>
#import <UserNotifications/UserNotifications.h>

@interface SEGMoEngageIntegration : NSObject <SEGIntegration, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSDictionary *settings;

- (id)initWithSettings:(NSDictionary *)settings;

@end



