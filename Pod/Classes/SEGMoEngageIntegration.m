#import "SEGMoEngageIntegration.h"
#import <MoEngageSDK/MoEngageSDK.h>
#import "SEGAnalytics.h"
#import "SEGMoEngageInitializer.h"

#define SegmentAnonymousIDAttribute @"USER_ATTRIBUTE_SEGMENT_ID"

@interface SEGMoEngageIntegration()
@end


@implementation SEGMoEngageIntegration

#pragma mark- Initialization method

-(id)initWithSettings:(NSDictionary *)settings
{
    if (self = [super init]) {
        self.settings = settings;
        NSString *appID = [self.settings objectForKey:@"apiKey"];
        
        MOSDKConfig* currentConfig = [SEGMoEngageInitializer fetchSDKConfigObject];
        
        if (![appID isEqual:currentConfig.moeAppID]) {
            NSLog(@"Failed to Enable SDK due to AppID mismatch.Make sure to initialize SEGMoEngageInitializer with same appID.");
            return self;
        }
        
        [[MOCoreIntegrator sharedInstance] enableSDKForSegmentWithInstanceID:appID];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* segmentAnonymousID = [[SEGAnalytics sharedAnalytics] getAnonymousId];
            if(segmentAnonymousID != nil){
                NSLog(@"Anonymous ID :  %@",segmentAnonymousID);
                [[MOAnalytics sharedInstance] setUserAttribute:segmentAnonymousID withAttributeName:SegmentAnonymousIDAttribute forAppID: appID];
            }
        });
        
        if (@available(iOS 10.0, *)) {
            if ([UNUserNotificationCenter currentNotificationCenter].delegate == nil) {
                [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            }
        }
    }
    return self;
}

+(NSString*)getSegmentMoEngageVersion{
    NSDictionary *infoDictionary = [[NSBundle bundleForClass:[SEGMoEngageIntegration class]] infoDictionary];
    NSString *version = [infoDictionary valueForKey:@"CFBundleShortVersionString"];
    return version;
}

#pragma mark- Application Life cycle methods

-(void)applicationDidFinishLaunching:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        if([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]){
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    });
}

#pragma mark- Push Notification methods

-(void)registeredForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[MoEngage sharedInstance] setPushToken:deviceToken];
}

- (void)failedToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[MoEngage sharedInstance] didFailToRegisterForPush];
}

- (void)receivedRemoteNotification:(NSDictionary *)userInfo
{
    [[MoEngage sharedInstance] didReceieveNotificationinApplication:[UIApplication sharedApplication] withInfo:userInfo];
}

#pragma mark- User Notification Center delegate methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(ios(10.0)){
    completionHandler((UNNotificationPresentationOptionSound
                       | UNNotificationPresentationOptionAlert ));
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(nonnull void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    [[MoEngage sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
    completionHandler();
}

#pragma mark- Segment callback methods

- (void)identify:(SEGIdentifyPayload *)payload
{
    @try {
        NSDictionary *moengagePayloadDict = [payload.traits copy];
        
        NSString* appID = [SEGMoEngageIntegration fetchCurrentAppID];
        
        if (payload.anonymousId != nil) {
            [[MOAnalytics sharedInstance] setUserAttribute:payload.anonymousId withAttributeName:SegmentAnonymousIDAttribute forAppID:appID];
        }
        
        if(payload.userId != nil){
            [[MOAnalytics sharedInstance] setUserAttribute:payload.userId withAttributeName:@"USER_ATTRIBUTE_UNIQUE_ID" forAppID:appID];
        }
        
        NSMutableDictionary *traits = [NSMutableDictionary dictionaryWithDictionary:moengagePayloadDict];
        if(![traits count]){
            return;
        }
        
        if ([traits objectForKey:@"id"]) {
            [[MOAnalytics sharedInstance] setUniqueID:[traits objectForKey:@"id"] forAppID: appID];
            [traits removeObjectForKey:@"id"];
        }
        
        if ([traits objectForKey:@"email"]) {
            [[MOAnalytics sharedInstance] setEmailID:[traits objectForKey:@"email"] forAppID:appID];
            [traits removeObjectForKey:@"email"];
        }
        
        if ([traits objectForKey:@"name"]) {
            [[MOAnalytics sharedInstance] setName:[traits objectForKey:@"name"] forAppID:appID];
            [traits removeObjectForKey:@"name"];
        }
        
        if ([traits objectForKey:@"phone"]) {
            [[MOAnalytics sharedInstance] setMobileNumber:[traits objectForKey:@"phone"] forAppID:appID];
            [traits removeObjectForKey:@"phone"];
        }
        
        if ([traits objectForKey:@"firstName"]) {
            [[MOAnalytics sharedInstance]setUserAttribute:[traits objectForKey:@"firstName"] withAttributeName:@"USER_ATTRIBUTE_USER_FIRST_NAME" forAppID:appID];
            [traits removeObjectForKey:@"firstName"];
        }
        
        if ([traits objectForKey:@"lastName"]) {
            [[MOAnalytics sharedInstance] setLastName:[traits objectForKey:@"lastName"] forAppID:appID];
            [traits removeObjectForKey:@"lastName"];
        }
        
        if ([traits objectForKey:@"gender"]) {
            [[MOAnalytics sharedInstance] setUserAttribute:[traits objectForKey:@"gender"] withAttributeName:@"USER_ATTRIBUTE_USER_GENDER" forAppID:appID];
            [traits removeObjectForKey:@"gender"];
        }
        
        if ([traits objectForKey:@"birthday"]) {
            id birthdayVal = [traits objectForKey:@"birthday"];
            if (birthdayVal != nil){
                [self identifyDateUserAttribute:birthdayVal withKey:@"USER_ATTRIBUTE_USER_BDAY"];
            }
            [traits removeObjectForKey:@"birthday"];
        }
        
        if ([traits objectForKey:@"address"]) {
            [[MOAnalytics sharedInstance]setUserAttribute:[traits objectForKey:@"address"] withAttributeName:@"address" forAppID:appID];
            [traits removeObjectForKey:@"address"];
        }
        
        if ([traits objectForKey:@"age"]) {
            [[MOAnalytics sharedInstance] setUserAttribute:[traits objectForKey:@"age"] withAttributeName:@"age" forAppID:appID];
            [traits removeObjectForKey:@"age"];
        }
        for (NSString *key in [traits allKeys]) {
            id value = [traits objectForKey:key];
            if (value != nil){
                [self identifyDateUserAttribute:value withKey:key];
            }
        }
    }
    @catch (NSException *exception) {
        // Possible if value is an unsupported type in the dictionary
        NSLog(@"Segment - MoEngage - Exception while adding traits is %@", exception);
    }
}

-(void)identifyDateUserAttribute:(id)value withKey:(NSString*)attr_name{
    NSString* appID = [SEGMoEngageIntegration fetchCurrentAppID];
    if ([value isKindOfClass:[NSString class]]) {
        NSDate* converted_date = [SEGMoEngageIntegration dateFromISOdateStr:value];
        if (converted_date != nil) {
            [[MOAnalytics sharedInstance] setUserAttributeEpochTime:[converted_date timeIntervalSince1970] withAttributeName:attr_name forAppID:appID];
            return;
        }
    }
    [[MOAnalytics sharedInstance]setUserAttribute:value withAttributeName:attr_name forAppID:appID];
}

-(void)alias:(SEGAliasPayload *)payload{
    @try{
        NSString* appID = [SEGMoEngageIntegration fetchCurrentAppID];
        id newID = payload.theNewId;
        if (newID != nil){
            if ([[MOAnalytics sharedInstance] respondsToSelector:@selector(setAlias:)]){
                [[MOAnalytics sharedInstance] setAlias:newID forAppID:appID];
            }
        }
    }
    @catch(NSException *exception) {
        NSLog(@"Segment - MoEngage - Exception while setAlias is %@", exception);
    }
}

- (void)track:(SEGTrackPayload *)payload
{
    
    @try{
        NSString* appID = [SEGMoEngageIntegration fetchCurrentAppID];
        if (payload.properties != nil) {
            NSMutableDictionary* generalAttributeDict = [NSMutableDictionary dictionaryWithDictionary:payload.properties];
            NSMutableDictionary* dateAttributeDict = [NSMutableDictionary dictionary];
            
            for (NSString* key in payload.properties.allKeys) {
                id val = [payload.properties valueForKey:key];
                if (val == nil || val == [NSNull null]) {
                    [generalAttributeDict removeObjectForKey:key];
                    continue;
                }
                else if ([val isKindOfClass:[NSString class]]){
                    NSDate* converted_date = [SEGMoEngageIntegration dateFromISOdateStr:val];
                    if (converted_date != nil) {
                        [dateAttributeDict setValue:converted_date forKey:key];
                        [generalAttributeDict removeObjectForKey:key];
                    }
                }
            }
            
            MOProperties* moe_properties = [[MOProperties alloc] initWithAttributes:generalAttributeDict];
            for (NSString* key in dateAttributeDict.allKeys) {
                NSDate *dateVal = [dateAttributeDict valueForKey:key];
                [moe_properties addDateAttribute:dateVal withName:key];
            }
            [[MOAnalytics sharedInstance] trackEvent:payload.event withProperties:moe_properties forAppID:appID];
        }
        else{
            [[MOAnalytics sharedInstance] trackEvent:payload.event withProperties:nil forAppID:appID];
        }
    }
    @catch(NSException* exception){
        NSLog(@"Segment - MoEngage - Exception while Tracking Event : %@", exception);
    }
}

- (void)flush{
    NSString* appID = [SEGMoEngageIntegration fetchCurrentAppID];
    [[MOAnalytics sharedInstance]flushForAppID:appID];
}


- (void)reset{
    NSString* appID = [SEGMoEngageIntegration fetchCurrentAppID];
    [[MOAnalytics sharedInstance] resetUserForAppID:appID];
}

#pragma mark- Utils

+(NSDate*)dateFromISOdateStr:(NSString*)isoDateStr{
    if (isoDateStr != nil) {
        static NSDateFormatter *dateFormatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
            dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'";
            dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        });
        return [dateFormatter dateFromString:isoDateStr];
    }
    return nil;
}

+(NSString*)fetchCurrentAppID {
    return [SEGMoEngageInitializer fetchSDKConfigObject].moeAppID;
}
@end
