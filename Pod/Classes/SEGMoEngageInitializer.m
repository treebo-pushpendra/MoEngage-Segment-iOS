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
static NSString * const segmentVersion = @"7.1.0";

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

+(void)trackPluginTypeAndVersion{
    MOIntegrationInfo* integrationInfo = [[MOIntegrationInfo alloc] initWithPluginType:@"segment" version: segmentVersion];
    [[MOCoreIntegrator sharedInstance]addIntergrationInfoWithInfo:integrationInfo appId:currentSDKConfig.moeAppID];
}

@end
