//
//  SEGMoEngageInitializer.m
//  Segment-MoEngage
//
//  Created by Rakshitha on 03/02/22.
//

#import <Foundation/Foundation.h>
#import "SEGMoEngageInitializer.h"
#import <MoEngageSDK/MoEngageSDK.h>


static MoEngageSDKConfig* currentSDKConfig = nil;
static NSString * const segmentVersion = @"8.2.0";

@implementation SEGMoEngageInitializer

+ (void)initializeDefaultInstance:(MoEngageSDKConfig*)sdkConfig{
    
    [self updateSDKConfig:sdkConfig];
    
#ifdef DEBUG
    [[MoEngage sharedInstance] initializeDefaultTestInstance:currentSDKConfig];
#else
    [[MoEngage sharedInstance] initializeDefaultLiveInstance:currentSDKConfig];
#endif
    
    [self trackPluginTypeAndVersion];
}

+ (void)initializeInstance:(MoEngageSDKConfig*)sdkConfig{
    
    [self updateSDKConfig:sdkConfig];
    
#ifdef DEBUG
    [[MoEngage sharedInstance] initializeTestInstance:sdkConfig];
#else
    [[MoEngage sharedInstance] initializeLiveInstance:sdkConfig];
#endif
    
    [self trackPluginTypeAndVersion];
}

+ (MoEngageSDKConfig*)fetchSDKConfigObject {
    return currentSDKConfig;
}

+ (void)updateSDKConfig:(MoEngageSDKConfig*)sdkConfig {
    [sdkConfig setPartnerIntegrationTypeWithIntegrationType: MoEngagePartnerIntegrationTypeSegment];
    currentSDKConfig = sdkConfig;
}

+(void)trackPluginTypeAndVersion{
    MoEngageIntegrationInfo* integrationInfo = [[MoEngageIntegrationInfo alloc] initWithPluginType:@"segment" version: segmentVersion];
    [[MoEngageCoreIntegrator sharedInstance]addIntergrationInfoWithInfo:integrationInfo appId:currentSDKConfig.appId];
}

@end
