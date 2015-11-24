#import "SEGMoEngageIntegration.h"
#import <MoEngage-iOS-SDK/MoEngage.h>
#import <MoEngage-iOS-SDK/MOEHelperConstants.h>


@implementation SEGMoEngageIntegration

- (id)initWithSettings:(NSDictionary *)settings
{
    if (self = [super init]) {
        self.settings = settings;

        NSString *apiKey = [self.settings objectForKey:@"apiKey"];

        [[MoEngage sharedInstance] initializeWithApiKey:apiKey inApplication:[UIApplication sharedApplication] withLaunchOptions:nil];
    }
    return self;
}

- (void)track:(SEGTrackPayload *)payload
{
    [[MoEngage sharedInstance] trackEvent:payload.event andPayload:[NSMutableDictionary dictionaryWithDictionary:payload.properties]];
}


- (void)identify:(SEGIdentifyPayload *)payload
{
    NSDictionary *traits = payload.traits;

    if ([traits objectForKey:@"id"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"id"] forKey:USER_ATTRIBUTE_UNIQUE_ID];
    }

    if ([traits objectForKey:@"email"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"email"] forKey:USER_ATTRIBUTE_USER_EMAIL];
    }

    if ([traits objectForKey:@"name"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"username"] forKey:USER_ATTRIBUTE_USER_NAME];
    }

    if ([traits objectForKey:@"phone"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"phone"] forKey:USER_ATTRIBUTE_USER_MOBILE];
    }

    if ([traits objectForKey:@"firstName"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"firstName"] forKey:USER_ATTRIBUTE_USER_FIRST_NAME];
    }

    if ([traits objectForKey:@"lastName"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"lastName"] forKey:USER_ATTRIBUTE_USER_LAST_NAME];
    }

    if ([traits objectForKey:@"gender"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"gender"] forKey:USER_ATTRIBUTE_USER_GENDER];
    }

    if ([traits objectForKey:@"birthday"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"birthday"] forKey:USER_ATTRIBUTE_USER_BDAY];
    }

    if ([traits objectForKey:@"address"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"address"] forKey:@"address"];
    }

    if ([traits objectForKey:@"age"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"age"] forKey:@"age"];
    }
}

- (void)flush
{
    [[MoEngage sharedInstance] syncNow];
}

- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken options:(NSDictionary *)options
{
    [[MoEngage sharedInstance] registerForPush:deviceToken];
}

- (void)reset
{
    [[MoEngage sharedInstance] resetUser];
}

- (void)applicationDidBecomeActive
{
    [[MoEngage sharedInstance] applicationBecameActiveinApplication:[UIApplication sharedApplication]];
}

- (void)applicationDidEnterBackground
{
    [[MoEngage sharedInstance] stop:[UIApplication sharedApplication]];
}

- (void)applicationWillTerminate
{
    [[MoEngage sharedInstance] applicationTerminated:[UIApplication sharedApplication]];
}

- (void)failedToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[MoEngage sharedInstance] didFailToRegisterForPush];
}

- (void)receivedRemoteNotification:(NSDictionary *)userInfo
{
    [[MoEngage sharedInstance] didReceieveNotificationinApplication:[UIApplication sharedApplication] withInfo:userInfo];
}

@end
