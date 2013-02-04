//
//  BGCPreferencesTableViewController.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/16/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCPreferencesTableViewController.h"
#import "BGString.h"
#import "UAPush.h"

@interface BGCPreferencesTableViewController ()

@property (strong, nonatomic) NSMutableArray *PreferencesTitle;
@property (strong, nonatomic) NSMutableArray *PreferencesSubTitle;

@end

@implementation BGCPreferencesTableViewController

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
    
    self.PreferencesTitle = [[NSMutableArray alloc] initWithObjects:MyHomeTown, NewsAlert, SportScore, HideImage, StoreImage, nil];
    self.PreferencesSubTitle = [[NSMutableArray alloc] initWithObjects:MyHomeTownSub, NewsAlertSub, SportScoreSub, HideImageSub, StoreImageSub, nil];

    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // listen for key-value store changes externally from the cloud
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePreferencesTopicItems:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:[NSUbiquitousKeyValueStore defaultStore]];
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
    return [self.PreferencesTitle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    if (indexPath.row == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.PreferencesTitle objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.PreferencesSubTitle objectAtIndex:indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11.5];
    }
    
    if (indexPath.row == 1)
    {
        UISwitch *newsAlertSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = newsAlertSwitch;
        newsAlertSwitch.tag = indexPath.row;
        [newsAlertSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if ([[NSUbiquitousKeyValueStore defaultStore] boolForKey:NewsAlertSwitch]) {
            newsAlertSwitch.on = YES;
        } else {
            newsAlertSwitch.on = NO;
        }
        
        
        cell.textLabel.text = [self.PreferencesTitle objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.PreferencesSubTitle objectAtIndex:indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11.5];
    }
    
    if (indexPath.row == 2)
    {
        UISwitch *sportScoreSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = sportScoreSwitch;
        sportScoreSwitch.tag = indexPath.row;
        [sportScoreSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if ([[NSUbiquitousKeyValueStore defaultStore] boolForKey:SportScoreSwitch]) {
            sportScoreSwitch.on = YES;
        } else {
            sportScoreSwitch.on = NO;
        }
        
        cell.textLabel.text = [self.PreferencesTitle objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.PreferencesSubTitle objectAtIndex:indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11.5];
    }
    
    if (indexPath.row == 3)
    {
        UISwitch *hideImageSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = hideImageSwitch;
        hideImageSwitch.tag = indexPath.row;
        [hideImageSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if ([[NSUbiquitousKeyValueStore defaultStore] boolForKey:HideImageSwitch]) {
            hideImageSwitch.on = YES;
        } else {
            hideImageSwitch.on = NO;
        }
        
        cell.textLabel.text = [self.PreferencesTitle objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.PreferencesSubTitle objectAtIndex:indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11.5];
    }
    
    if (indexPath.row == 4)
    {
        
        UILabel *headline = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 30)];
        headline.text = [self.PreferencesTitle objectAtIndex:indexPath.row];
        headline.backgroundColor = [UIColor clearColor];
        headline.font = [UIFont boldSystemFontOfSize:18];
        [cell.contentView addSubview:headline];
        
        UILabel *subheadline = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 280, 60)];
        subheadline.text = [self.PreferencesSubTitle objectAtIndex:indexPath.row];
        subheadline.backgroundColor = [UIColor clearColor];
        subheadline.font = [UIFont systemFontOfSize:11.5];
        subheadline.textColor = [UIColor grayColor];
        subheadline.numberOfLines = 2;
        [cell.contentView addSubview:subheadline];
        
        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:OneDay, ThreeDay, SevenDay, nil]];
        control.segmentedControlStyle = UISegmentedControlStylePlain;
        control.frame = CGRectMake(10, 70, 280, 50);
        [cell.contentView addSubview:control];
        [control addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];
        
        if ([[NSUbiquitousKeyValueStore defaultStore] stringForKey:ArticleStorageSegment]) {
            control.selectedSegmentIndex = [[[NSUbiquitousKeyValueStore defaultStore] stringForKey:ArticleStorageSegment] integerValue];
        } else {
            control.selectedSegmentIndex = 2;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 130;
    } else {
        return 55;
    }
}

- (void)valueChanged:(UISwitch *)sender
{
    if (sender.tag == 1) {
        if (sender.on) {
            
            [[UAPush shared] addTagToCurrentDevice:BreakingNewsTag];
            [[UAPush shared] updateRegistration];
            
            [[NSUbiquitousKeyValueStore defaultStore] setBool:YES forKey:NewsAlertSwitch];
            
        } else {
            
            [[UAPush shared] removeTagFromCurrentDevice:BreakingNewsTag];
            [[UAPush shared] updateRegistration];
            
            [[NSUbiquitousKeyValueStore defaultStore] setBool:NO forKey:NewsAlertSwitch];
        }
    } else if (sender.tag == 2) {
        if (sender.on) {
            
            [[NSUbiquitousKeyValueStore defaultStore] setBool:YES forKey:SportScoreSwitch];
        } else {
            
            [[NSUbiquitousKeyValueStore defaultStore] setBool:NO forKey:SportScoreSwitch];
        }
    } else if (sender.tag == 3) {
        if (sender.on) {
            
            [[NSUbiquitousKeyValueStore defaultStore]setBool:YES forKey:HideImageSwitch];
        } else {
            
            [[NSUbiquitousKeyValueStore defaultStore] setBool:NO forKey:HideImageSwitch];
        }
    }
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)action:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    [[NSUbiquitousKeyValueStore defaultStore] setString:[NSString stringWithFormat:@"%i" ,segmentedControl.selectedSegmentIndex] forKey:ArticleStorageSegment];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

/*
 This method is called when the key-value store in the cloud has changed externally.
 */
- (void)updatePreferencesTopicItems:(NSNotification *)notification
{
	// We get more information from the notification, by using:
    //  NSUbiquitousKeyValueStoreChangeReasonKey or NSUbiquitousKeyValueStoreChangedKeysKey constants
    // against the notification's useInfo.
	
    NSDictionary *userInfo = [notification userInfo];
    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    
    if (reasonForChange)
    {
        NSInteger reason = [[userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey] integerValue];
        if (reason == NSUbiquitousKeyValueStoreServerChange ||
            // the value changed from the remote server
            reason == NSUbiquitousKeyValueStoreInitialSyncChange)
            // initial syncs happen the first time the device is synced
        {
            [self.tableView reloadData];
        }
    }
}


@end
