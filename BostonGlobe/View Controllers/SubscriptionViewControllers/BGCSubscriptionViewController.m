//
//  BGCSubscriptionViewController.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/16/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCSubscriptionViewController.h"
#import "BGMSubscriptionManager.h"

@interface BGCSubscriptionViewController ()

@end

@implementation BGCSubscriptionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
        
    if (indexPath.row == 0) {
        
        if ([[BGMSubscriptionManager sharedInstance] subscriptionType] == BGPrintSubscription) {
            cell.textLabel.text = @"Print Subscription";
        } else if ([[BGMSubscriptionManager sharedInstance] subscriptionType] == BGAutoRenewableWeekSubscription) {
            cell.textLabel.text = @"1 Week Subscription";
        } else if ([[BGMSubscriptionManager sharedInstance] subscriptionType] == BGAutoRenewableMonthSubscription) {
            cell.textLabel.text = @"1 Month Subscription";
        } else if ([[BGMSubscriptionManager sharedInstance] subscriptionType] == BGFreeSubscription) {
            cell.textLabel.text = @"30-day free trial";
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        NSString *stringFromDate = [formatter stringFromDate:[[BGMSubscriptionManager sharedInstance] endDate]];
        cell.detailTextLabel.text = stringFromDate;
        
        UILabel *headline = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 50, 30)];
        headline.text = @"ends:";
        headline.backgroundColor = [UIColor clearColor];
        headline.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:headline];
    }
    
    if (indexPath.row == 1) {
        UILabel *headline = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 30)];
        headline.text = @"Renewal options";
        headline.backgroundColor = [UIColor clearColor];
        headline.font = [UIFont boldSystemFontOfSize:18];
        [cell.contentView addSubview:headline];
        
        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"7 Days", @"30 Days", nil]];
        control.segmentedControlStyle = UISegmentedControlStylePlain;
        control.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        control.frame = CGRectMake(10, 40, 300, 0);
        [cell.contentView addSubview:control];
        
        if ([[BGMSubscriptionManager sharedInstance] subscriptionType] == BGAutoRenewableWeekSubscription) {
            control.selectedSegmentIndex = 0;
        } else if ([[BGMSubscriptionManager sharedInstance] subscriptionType] == BGAutoRenewableMonthSubscription) {
            control.selectedSegmentIndex = 1;
        }
    }
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 65;
    } else {
        return 100;
    }
}

- (void)saveTheSettingPref
{
    
    NSLog(@"Awesome");
}

@end
