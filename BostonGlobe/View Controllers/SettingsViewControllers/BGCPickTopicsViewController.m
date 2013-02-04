//
//  BGPickTopicsViewController.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/14/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCPickTopicsViewController.h"
#import "BGMSectionListManager.h"
#import "BGMSectionAbstract.h"
#import "BGString.h"

@interface BGCPickTopicsViewController ()

@property (strong, nonatomic) NSMutableArray *originalSections;
@property (strong, nonatomic) NSMutableArray *canEditoriginalSections;

@end

@implementation BGCPickTopicsViewController

- (void)syncSettingPref
{
    NSUbiquitousKeyValueStore *keyStore = [NSUbiquitousKeyValueStore defaultStore];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.originalSections];
    [keyStore setData:data forKey:BGMyGlobeSectionList];
    
    [keyStore setArray:self.canEditoriginalSections forKey:BGMyGlobeSectionListEditableCell];
    [keyStore synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BG_PREMIUM_PICK_TOPICS_CHANGED object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUbiquitousKeyValueStore *keyStore = [NSUbiquitousKeyValueStore defaultStore];
    
    NSData *data = [keyStore dataForKey:BGMyGlobeSectionList];
    NSArray *sectionArry = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    // listen for key-value store changes externally from the cloud
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePickTopicItems:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:keyStore];
    
    
    self.originalSections = [NSMutableArray arrayWithArray:sectionArry];
    self.canEditoriginalSections = [NSMutableArray arrayWithArray:[keyStore arrayForKey:BGMyGlobeSectionListEditableCell]];

    self.title = @"Topic";
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
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
    return [self.originalSections  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BGMSectionAbstract *sectionAbstract = [self.originalSections objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = sectionAbstract.name;
    
    for (int i =0; i<[self.canEditoriginalSections count]; i++) {
        if ([self.canEditoriginalSections objectAtIndex:indexPath.row] == [NSNumber numberWithInt:0]) {
            cell.imageView.image = nil;
            cell.textLabel.textColor = [UIColor grayColor];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"CheckMark.png"];
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
        
    BGMSectionAbstract *rowSectionTitles = [self.originalSections  objectAtIndex:fromIndexPath.row];

    [self.originalSections  removeObjectAtIndex:fromIndexPath.row];
    [self.originalSections  insertObject:rowSectionTitles atIndex:toIndexPath.row];
    
    NSString *rowanEditTheCell = [self.canEditoriginalSections  objectAtIndex:fromIndexPath.row];
    [self.canEditoriginalSections  removeObjectAtIndex:fromIndexPath.row];
    [self.canEditoriginalSections  insertObject:rowanEditTheCell atIndex:toIndexPath.row];
    
    [self syncSettingPref];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{

    for (int i =0; i<[self.canEditoriginalSections count]; i++) {
        if ([self.canEditoriginalSections objectAtIndex:indexPath.row] == [NSNumber numberWithInt:0]) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.canEditoriginalSections objectAtIndex:indexPath.row] == [NSNumber numberWithInt:0]) {
        [self.canEditoriginalSections replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
    } else {
        [self.canEditoriginalSections replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:0]];
    }
    
    [self syncSettingPref];
    [tableView reloadData];
}


#pragma mark - Cloud support

/*
 This method is called when the key-value store in the cloud has changed externally.
 */
- (void)updatePickTopicItems:(NSNotification *)notification
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
            [self updateThePickTopicData];
        }
    }
}

- (void)updateThePickTopicData
{
    NSUbiquitousKeyValueStore *keyStore = [NSUbiquitousKeyValueStore defaultStore];
    
    NSData *data = [keyStore dataForKey:BGMyGlobeSectionList];
    NSArray *sectionArry = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.originalSections = [NSMutableArray arrayWithArray:sectionArry];
    self.canEditoriginalSections = [NSMutableArray arrayWithArray:[keyStore arrayForKey:BGMyGlobeSectionListEditableCell]];
    
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:BG_PREMIUM_PICK_TOPICS_CHANGED object:nil];
}

@end
