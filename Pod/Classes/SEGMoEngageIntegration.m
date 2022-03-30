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
        
        [MoEngage.sharedInstance enableSDKForSegment:currentConfig];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSString* segmentAnonymousID = [[SEGAnalytics sharedAnalytics] getAnonymousId];
            if(segmentAnonymousID != nil){
                NSLog(@"Anonymous ID :  %@",segmentAnonymousID);
                [[MoEngage sharedInstance] setUserAttribute:segmentAnonymousID forKey:SegmentAnonymousIDAttribute forAppID: appID];
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
            [[MoEngage sharedInstance] setUserAttribute:payload.anonymousId forKey:SegmentAnonymousIDAttribute forAppID:appID];
        }
        
        if(payload.userId != nil){
            [[MoEngage sharedInstance] setUserAttribute:payload.userId forKey:@"USER_ATTRIBUTE_UNIQUE_ID" forAppID:appID];
        }
        
        NSMutableDictionary *traits = [NSMutableDictionary dictionaryWithDictionary:moengagePayloadDict];
        if(![traits count]){
            return;
        }
        
        if ([traits objectForKey:@"id"]) {
            [[MoEngage sharedInstance] setUniqueID:[traits objectForKey:@"id"] forAppID: appID];
            [traits removeObjectForKey:@"id"];
        }
        
        if ([traits objectForKey:@"email"]) {
            [[MoEngage sharedInstance] setEmailID:[traits objectForKey:@"email"] forAppID:appID];
            [traits removeObjectForKey:@"email"];
        }
        
        if ([traits objectForKey:@"name"]) {
            [[MoEngage sharedInstance] setName:[traits objectForKey:@"name"] forAppID:appID];
            [traits removeObjectForKey:@"name"];
        }
        
        if ([traits objectForKey:@"phone"]) {
            [[MoEngage sharedInstance] setMobileNo:[traits objectForKey:@"phone"] forAppID:appID];
            [traits removeObjectForKey:@"phone"];
        }
        
        if ([traits objectForKey:@"firstName"]) {
            [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"firstName"] forKey:@"USER_ATTRIBUTE_USER_FIRST_NAME" forAppID:appID];
            [traits removeObjectForKey:@"firstName"];
        }
        
        if ([traits objectForKey:@"lastName"]) {
            [[MoEngage sharedInstance] setLastName:[traits objectForKey:@"lastName"] forAppID:appID];
            [traits removeObjectForKey:@"lastName"];
        }
        
        if ([traits objectForKey:@"gender"]) {
            [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"gender"] forKey:@"USER_ATTRIBUTE_USER_GENDER" forAppID:appID];
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
            [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"address"] forKey:@"address" forAppID:appID];
            [traits removeObjectForKey:@"address"];
        }
        
        if ([traits objectForKey:@"age"]) {
            [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"age"] forKey:@"age" forAppID:appID];
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
            [[MoEngage sharedInstance] setUserAttributeEpochTime:[converted_date timeIntervalSince1970] forKey:attr_name forAppID:appID];
            return;
        }
    }
    [[MoEngage sharedInstance] setUserAttribute:value forKey:attr_name forAppID:appID];
}

-(void)alias:(SEGAliasPayload *)payload{
    @try{
        NSString* appID = [SEGMoEngageIntegration fetchCurrentAppID];
        id newID = payload.theNewId;
        if (newID != nil){
            if ([[MoEngage sharedInstance] respondsToSelector:@selector(setAlias:)]){
                [[MoEngage sharedInstance] setAlias:newID forAppID:appID];
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
            [[MoEngage sharedInstance] trackEvent:payload.event withProperties:moe_properties forAppID:appID];
        }
        else{
            [[MoEngage sharedInstance] trackEvent:payload.event withProperties:nil forAppID:appID];
        }
    }
    @catch(NSException* exception){
        NSLog(@"Segment - MoEngage - Exception while Tracking Event : %@", exception);
    }
}

- (void)flush{
    NSString* appID = [SEGMoEngageIntegration fetchCurrentAppID];
    [[MoEngage sharedInstance] flushForAppID:appID];
}


- (void)reset{
    NSString* appID = [SEGMoEngageIntegration fetchCurrentAppID];
    [[MoEngage sharedInstance] resetUserForAppID:appID];
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
