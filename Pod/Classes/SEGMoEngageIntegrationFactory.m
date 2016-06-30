#import "SEGMoEngageIntegrationFactory.h"
#import "SEGMoEngageIntegration.h"


@implementation SEGMoEngageIntegrationFactory

+ (instancetype)instance
{
    static dispatch_once_t once;
    static SEGMoEngageIntegrationFactory *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    return self;
}

- (id<SEGIntegration>)createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
    return [[SEGMoEngageIntegration alloc] initWithSettings:settings];
}

- (NSString *)key
{
    return @"MoEngage";
}
@end
