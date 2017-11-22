#import "SEGMoEngageIntegration.h"
#import "MoEngage.h"
#import "MOEHelperConstants.h"
#import "SEGAnalytics.h"

#define SegmentAnonymousIDAttribute @"USER_ATTRIBUTE_SEGMENT_ID"

@implementation SEGMoEngageIntegration

#pragma mark- Initialization method

- (id)initWithSettings:(NSDictionary *)settings
{
    if (self = [super init]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.settings = settings;
            NSString *apiKey = [self.settings objectForKey:@"apiKey"];
            #ifdef DEBUG
                [[MoEngage sharedInstance] initializeDevWithApiKey:apiKey inApplication:[UIApplication sharedApplication] withLaunchOptions:nil openDeeplinkUrlAutomatically:YES];
            #else
                [[MoEngage sharedInstance] initializeProdWithApiKey:apiKey inApplication:[UIApplication sharedApplication] withLaunchOptions:nil openDeeplinkUrlAutomatically:YES];
            #endif
            
            NSString* segmentAnonymousID = [[SEGAnalytics sharedAnalytics] getAnonymousId];
            if(segmentAnonymousID != nil){
                NSLog(@"Anonymous ID :  %@",segmentAnonymousID);
                [[MoEngage sharedInstance] setUserAttribute:segmentAnonymousID forKey:SegmentAnonymousIDAttribute];
            }
        });
    }
    return self;
}



#pragma mark- Application Life cycle methods

-(void)applicationDidFinishLaunching:(NSNotification *)notification{
    [[MoEngage sharedInstance]didReceieveNotificationinApplication:nil withInfo:notification.userInfo openDeeplinkUrlAutomatically:YES];
}

#pragma mark- Push Notification methods

- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken options:(NSDictionary *)options
{
    [[MoEngage sharedInstance] registerForPush:deviceToken];
}

-(void)registeredForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[MoEngage sharedInstance] registerForPush:deviceToken];
}

- (void)failedToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[MoEngage sharedInstance] didFailToRegisterForPush];
}

- (void)receivedRemoteNotification:(NSDictionary *)userInfo
{
    [[MoEngage sharedInstance] didReceieveNotificationinApplication:[UIApplication sharedApplication] withInfo:userInfo openDeeplinkUrlAutomatically:YES];
}

- (void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo{
    [[MoEngage sharedInstance] handleActionWithIdentifier:identifier forRemoteNotification:userInfo];
}

#pragma mark- Segment callback methods

- (void)identify:(SEGIdentifyPayload *)payload
{
    NSDictionary *moengagePayloadDict = [payload.traits copy];
    
    if (payload.anonymousId != nil) {
        [[MoEngage sharedInstance] setUserAttribute:payload.anonymousId forKey:SegmentAnonymousIDAttribute];
    }
    
    if(payload.userId != nil){
        [[MoEngage sharedInstance] setUserAttribute:payload.userId forKey:USER_ATTRIBUTE_UNIQUE_ID];
    }
    
    NSMutableDictionary *traits = [NSMutableDictionary dictionaryWithDictionary:moengagePayloadDict];
    if(![traits count]){
        return;
    }

    if ([traits objectForKey:@"id"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"id"] forKey:USER_ATTRIBUTE_UNIQUE_ID];
        [traits removeObjectForKey:@"id"];
    }
    
    if ([traits objectForKey:@"email"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"email"] forKey:USER_ATTRIBUTE_USER_EMAIL];
        [traits removeObjectForKey:@"email"];
    }
    
    if ([traits objectForKey:@"name"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"name"] forKey:USER_ATTRIBUTE_USER_NAME];
        [traits removeObjectForKey:@"name"];
    }
    
    if ([traits objectForKey:@"phone"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"phone"] forKey:USER_ATTRIBUTE_USER_MOBILE];
        [traits removeObjectForKey:@"phone"];
    }
    
    if ([traits objectForKey:@"firstName"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"firstName"] forKey:USER_ATTRIBUTE_USER_FIRST_NAME];
        [traits removeObjectForKey:@"firstName"];
    }
    
    if ([traits objectForKey:@"lastName"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"lastName"] forKey:USER_ATTRIBUTE_USER_LAST_NAME];
        [traits removeObjectForKey:@"lastName"];
    }
    
    if ([traits objectForKey:@"gender"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"gender"] forKey:USER_ATTRIBUTE_USER_GENDER];
        [traits removeObjectForKey:@"gender"];
    }
    
    if ([traits objectForKey:@"birthday"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"birthday"] forKey:USER_ATTRIBUTE_USER_BDAY];
        [traits removeObjectForKey:@"birthday"];
    }
    
    if ([traits objectForKey:@"address"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"address"] forKey:@"address"];
        [traits removeObjectForKey:@"address"];
    }
    
    if ([traits objectForKey:@"age"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"age"] forKey:@"age"];
        [traits removeObjectForKey:@"age"];
    }
    
    @try {
        for (NSString *key in [traits allKeys]) {
            id value = [traits objectForKey:key];
            if (value != nil){
                [[MoEngage sharedInstance] setUserAttribute:value forKey:key];
            }
        }
    }
    @catch (NSException *exception) {
        // Possible if value is an unsupported type in the dictionary
        NSLog(@"Segment - MoEngage - Exception while adding traits is %@", exception);
    }
}

-(void)alias:(SEGAliasPayload *)payload{
    @try{
        id newID = payload.theNewId;
        if (newID != nil){
            if ([[MoEngage sharedInstance] respondsToSelector:@selector(setAlias:)]){
                [[MoEngage sharedInstance] setAlias:newID];
            }
        }
    }
    @catch(NSException *exception) {
        NSLog(@"Segment - MoEngage - Exception while setAlias is %@", exception);
    }
}

- (void)track:(SEGTrackPayload *)payload
{
    [[MoEngage sharedInstance] trackEvent:payload.event andPayload:[NSMutableDictionary dictionaryWithDictionary:payload.properties]];
}

- (void)flush
{
    [[MoEngage sharedInstance] syncNow];
}


- (void)reset
{
    [[MoEngage sharedInstance] resetUser];
}
@end
