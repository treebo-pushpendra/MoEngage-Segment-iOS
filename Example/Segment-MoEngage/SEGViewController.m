//
//  SEGViewController.m
//  Segment-MoEngage
//
//  Created by Prateek Srivastava on 11/24/2015.
//  Copyright (c) 2015 Prateek Srivastava. All rights reserved.
//

#import "SEGViewController.h"
#import <Analytics/SEGAnalytics.h>

@interface SEGViewController ()

@end


@implementation SEGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[SEGAnalytics sharedAnalytics] identify:@"UniqueID" traits:nil];
    [[SEGAnalytics sharedAnalytics] identify:@"UniqueID" traits:@{@"email":@"qwe@qaz.com"}];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
