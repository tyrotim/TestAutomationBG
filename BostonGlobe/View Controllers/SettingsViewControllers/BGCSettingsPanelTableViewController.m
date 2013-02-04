//
//  BGCSettingsPanelTableViewController.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/11/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCSettingsPanelTableViewController.h"
#import "BGCPickTopicsViewController.h"
#import "BGCPreferencesTableViewController.h"
#import "BGCSubscriptionViewController.h"

@interface BGCSettingsPanelTableViewController ()

@property (copy, nonatomic) NSArray *headlineTitles;
@property (copy, nonatomic) NSArray *subTitles;

@end

@implementation BGCSettingsPanelTableViewController

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

    self.headlineTitles = [[NSArray alloc] initWithObjects:@"Pick topics", @"Set preferences", @"Manage subscription", nil];
    self.subTitles = [[NSArray alloc] initWithObjects:@"Pick topics", @"Set preferences", @"Manage subscription", nil];
    self.navigationController.navigationBarHidden = YES;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.headlineTitles objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.subTitles objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (indexPath.row == 0) {
        // Navigation logic may go here. Create and push another view controller.
        BGCPickTopicsViewController *deatlView = [[BGCPickTopicsViewController alloc] initWithNibName:@"BGCPickTopicsViewController" bundle:nil];
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:deatlView animated:YES];
    } else if (indexPath.row == 1) {
        // Navigation logic may go here. Create and push another view controller.
        BGCPreferencesTableViewController *deatlView = [[BGCPreferencesTableViewController alloc] initWithNibName:@"BGCPreferencesTableViewController" bundle:nil];
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:deatlView animated:YES];
    } else if (indexPath.row == 2) {
        // Navigation logic may go here. Create and push another view controller.
        BGCSubscriptionViewController *deatlView = [[BGCSubscriptionViewController alloc] initWithNibName:@"BGCSubscriptionViewController" bundle:nil];
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:deatlView animated:YES];
    }
}

@end
