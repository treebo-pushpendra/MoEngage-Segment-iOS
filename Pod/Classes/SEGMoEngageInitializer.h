//
//  SEGMoEngageInitializer.h
//  Segment-MoEngage
//
//  Created by Rakshitha on 03/02/22.
//

#import <MoEngageSDK/MoEngageSDK.h>
@interface SEGMoEngageInitializer : NSObject

+ (void)initializeDefaultInstance:(MOSDKConfig*)sdkConfig;
+ (void)initializeInstance:(MOSDKConfig*)sdkConfig;
+ (MOSDKConfig*)fetchSDKConfigObject;
@end
