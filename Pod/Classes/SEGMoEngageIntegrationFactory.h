#import <Foundation/Foundation.h>

#if defined(__has_include) && __has_include(<Analytics/SEGIntegration.h>)
#import <Analytics/SEGIntegrationFactory.h>
#else
@import Segment;
#endif



@interface SEGMoEngageIntegrationFactory : NSObject <SEGIntegrationFactory>

+ (instancetype)instance;

@end
