//
//  SEGViewController.m
//  Segment-MoEngage
//
//  Created by Prateek Srivastava on 11/24/2015.
//  Copyright (c) 2015 Prateek Srivastava. All rights reserved.
//

#import "SEGViewController.h"
#import <Analytics/SEGAnalytics.h>
#import <MoEngage/MoEngage.h>

@interface SEGViewController ()

@end


@implementation SEGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[SEGAnalytics sharedAnalytics] identify:@"UniqueID1" traits:nil];
    [[SEGAnalytics sharedAnalytics] identify:@"UniqueID1" traits:@{@"email":@"test@moe.com"}];
    
    [[SEGAnalytics sharedAnalytics] identify:@"UniqueID1" traits:@{@"test_user_attr":[self getFormattedDate]}];
    [[SEGAnalytics sharedAnalytics] track:@"testSegmentEvent" properties:@{@"testDate": [self getFormattedDate], @"testStr": @"gufsdhjf0", @"testNum": @100}];
}

-(NSString*)getFormattedDate{
    NSString* format = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'";
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:[NSDate date]];
}

-(void)viewDidAppear:(BOOL)animated{
    [self performSelector:@selector(resetUser) withObject:nil afterDelay:10.0];
}

-(void)resetUser{
    [[SEGAnalytics sharedAnalytics] reset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
