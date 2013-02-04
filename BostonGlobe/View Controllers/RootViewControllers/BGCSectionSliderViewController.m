//
//  BGCSectionSliderViewController.m
//  BostonGlobe
//
//  Created by Christian Grise on 12/17/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGCSectionSliderViewController.h"
#import "BGMIssue.h"
#import "BGMIssueManager.h"
#import "BGMSectionAbstract.h"
#import "BGMSectionManager.h"
#import "BGMSectionListManager.h"

@interface BGCSectionSliderViewController ()

@end

@implementation BGCSectionSliderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sectionArray = [NSArray arrayWithArray:[BGMSectionListManager sharedInstance].sectionAbstracts];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sectionTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.55];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.sectionTableView.frame = CGRectMake(self.sectionTableView.frame.origin.x, self.sectionTableView.frame.origin.y, self.sectionTableView.frame.size.width, self.sectionArray.count * self.sectionTableView.rowHeight + self.sectionTableView.sectionHeaderHeight);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sectionArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (headerCell == nil) {
        headerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    UIButton *myGlobeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myGlobeButton.frame = CGRectMake(0, 0, self.sectionTableView.frame.size.width * .42, 40);
    [myGlobeButton setTitle:@"my globe" forState:UIControlStateNormal];
    [myGlobeButton addTarget:self
                      action:@selector(myGlobeButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    [headerCell addSubview:myGlobeButton];
    
    UIButton *fiveInFiveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fiveInFiveButton.frame = CGRectMake(myGlobeButton.frame.size.width, 0, self.sectionTableView.frame.size.width * .30, 40);
    [fiveInFiveButton setTitle:@"5/5" forState:UIControlStateNormal];
    [fiveInFiveButton addTarget:self
                      action:@selector(fiveInFiveButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    [headerCell addSubview:fiveInFiveButton];

    UIButton *trafficButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    trafficButton.frame = CGRectMake(fiveInFiveButton.frame.size.width + fiveInFiveButton.frame.origin.x, 0, self.sectionTableView.frame.size.width * .28, 40);
    [trafficButton setTitle:@"vroom" forState:UIControlStateNormal];
    [trafficButton addTarget:self
                      action:@selector(trafficButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    [headerCell addSubview:trafficButton];
    
    return headerCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BGMSectionAbstract *sectionAbstract = self.sectionArray[indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = sectionAbstract.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    BGMSectionAbstract *sectionAbstract = self.sectionArray[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(sectionSliderViewController:didSelectSectionWithIdentifier:)]) {
        [self.delegate sectionSliderViewController:self
                    didSelectSectionWithIdentifier:sectionAbstract.identifier];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)myGlobeButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(sectionSliderViewController:didSelectSectionWithIdentifier:)]) {
        [self.delegate sectionSliderViewController:self
                    didSelectSectionWithIdentifier:MyGlobeSectionIdentifier];
    }
}

- (IBAction)fiveInFiveButtonPressed:(id)sender
{
    
}

- (IBAction)trafficButtonPressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_TAB_CLICK_NOTIFICATION object:nil];
}

@end
