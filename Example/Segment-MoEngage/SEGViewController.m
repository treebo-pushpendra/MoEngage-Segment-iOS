//
//  SEGViewController.m
//  Segment-MoEngage
//
//  Created by Prateek Srivastava on 11/24/2015.
//  Copyright (c) 2015 Prateek Srivastava. All rights reserved.
//

#import "SEGViewController.h"
#import <Segment/SEGAnalytics.h>
#import <MoEngageSDK/MoEngageSDK.h>
@import MoEngageInApps;

@interface SEGViewController ()

@property (strong, nonatomic) NSArray *data;

@end


@implementation SEGViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:@{@"email":@"testinload11@moe.com"}];
    self.data = @[@"Set Unique ID", @"Set User Attribute", @"Set Custom Attribute", @"Set Alias",@"Track Event",@"Show InApp", @"Reset User"];
    [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:@{@"lastName":@"lastname1"}];
    [MoEngageSDKInApp.sharedInstance showInApp];

}

-(NSString*)getFormattedDate{
    NSString* format = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'";
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:[NSDate date]];
}

-(void)viewDidAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:nil];

            break;
        case 1:
            [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:@{@"email":@"test@moe.com"}];
            [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:@{@"firstName":@"fname"}];
            [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:@{@"name":@"uname"}];
            [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:@{@"phone":@"123456789"}];
            [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:@{@"age":@"22"}];
            [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:@{@"address":@"bangalore"}];


            break;
            
        case 2:
            [[SEGAnalytics sharedAnalytics] identify:@"UniqueID2" traits:@{@"test_user_attr":[self getFormattedDate]}];
            break;
            
        case 3:
           [[SEGAnalytics sharedAnalytics] alias:@"23456"];;
            break;;

        case 4:
            
            [[SEGAnalytics sharedAnalytics] track:@"testSegmentEvent" properties:@{@"testDate": [self getFormattedDate], @"testStr": @"gufsdhjf0", @"testNum": @100}];
            break;
        
        case 5:
            [[MoEngageSDKInApp sharedInstance] showInAppForAppId:@"DAO6UGZ73D9RTK8B5W96TPYN"];
            break;
        case 6:
            [[SEGAnalytics sharedAnalytics] reset];
            break;
        

    }
}

@end
