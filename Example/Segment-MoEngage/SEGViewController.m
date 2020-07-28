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
    
    [[SEGAnalytics sharedAnalytics] identify:@"UniqueID1" traits:@{@"test_user_attr":[NSDate date]}];
    [[SEGAnalytics sharedAnalytics] track:@"testSegmentEvent" properties:@{@"testDate": [NSDate date], @"testStr": @"gufsdhjf0", @"testNum": @100}];
    
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
