//
//  SEGMoEngageInitializer.m
//  Segment-MoEngage
//
//  Created by Rakshitha on 03/02/22.
//

#import <Foundation/Foundation.h>
#import "SEGMoEngageInitializer.h"
#import <MoEngageSDK/MoEngageSDK.h>

static MOSDKConfig* currentSDKConfig = nil;

@implementation SEGMoEngageInitializer

+ (void)initializeDefaultInstance:(MOSDKConfig*)sdkConfig{
    
    [self updateSDKConfig:sdkConfig];
    
    #ifdef DEBUG
        [[MoEngage sharedInstance] initializeDefaultTestInstanceWithConfig:currentSDKConfig andLaunchOptions:nil];
    #else
        [[MoEngage sharedInstance] initializeDefaultLiveInstanceWithConfig:currentSDKConfig andLaunchOptions:nil];
    #endif
    
    [self trackPluginTypeAndVersion];
}

+ (void)initializeInstance:(MOSDKConfig*)sdkConfig{
    
    [self updateSDKConfig:sdkConfig];

    #ifdef DEBUG
        [[MoEngage sharedInstance] initializeTestInstanceWithConfig:currentSDKConfig andLaunchOptions:nil];
    #else
        [[MoEngage sharedInstance] initializeLiveInstanceWithConfig:currentSDKConfig andLaunchOptions:nil];
    #endif
    
    [self trackPluginTypeAndVersion];
}

+ (MOSDKConfig*)fetchSDKConfigObject {
    return currentSDKConfig;
}

+ (void)updateSDKConfig:(MOSDKConfig*)sdkConfig {
    [sdkConfig setPartnerIntegrationTypeWithIntegrationType: PartnerIntegrationTypeSegment];
    currentSDKConfig = sdkConfig;
}

+(NSString*)getSegmentMoEngageVersion{
    NSDictionary *infoDictionary = [[NSBundle bundleForClass:[SEGMoEngageInitializer class]] infoDictionary];
    NSString *version = [infoDictionary valueForKey:@"CFBundleShortVersionString"];
    return version;
}

+(void)trackPluginTypeAndVersion{
    MOIntegrationInfo* integrationInfo = [[MOIntegrationInfo alloc] initWithPluginType:@"segment" version:[self getSegmentMoEngageVersion]];
    [[MOCoreIntegrator sharedInstance]addIntergrationInfoWithInfo:integrationInfo appId:currentSDKConfig.moeAppID];
}

@end
