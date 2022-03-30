#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

#if defined(__has_include) && __has_include(<Analytics/SEGIntegration.h>)
#import <Analytics/SEGIntegration.h>
#else
@import Segment;
#endif

@interface SEGMoEngageIntegration : NSObject <SEGIntegration, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSDictionary *settings;

- (id)initWithSettings:(NSDictionary *)settings;

@end



