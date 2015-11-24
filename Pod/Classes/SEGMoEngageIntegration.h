#import <Foundation/Foundation.h>
#import <Analytics/SEGIntegration.h>


@interface SEGMoEngageIntegration : NSObject <SEGIntegration>

@property (nonatomic, strong) NSDictionary *settings;

- (id)initWithSettings:(NSDictionary *)settings;

@end
