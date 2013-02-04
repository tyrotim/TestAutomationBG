//
//  BGCFreeSubscriptionViewController.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/8/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCFreeSubscriptionViewController.h"
#import "BGMInAppPurchaseManager.h"
#import "BGMSubscriptionManager.h"

@interface BGCFreeSubscriptionViewController ()


@end

@implementation BGCFreeSubscriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.welcomeTitleOulet.hidden = YES;
    self.startLineOutlet.hidden = YES;
    self.endDateOutlet.hidden = YES;
    
    self.loginActivityIndicator.color = [UIColor grayColor];
    self.loginActivityIndicator.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showWelcomeScreen)
     name:IN_APP_PURCHASE_MANAGER_TRANSACTION_SUCCEEDED_NOTIFICATION_FREE_SUB
     object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoginActivityIndicator) name:IN_APP_PURCHASE_MANAGER_TRANSACTION_USER_CANCELLED object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startSubscription:(id)sender
{
    [[BGMInAppPurchaseManager sharedInstance] requestFreeProductData];
    self.loginActivityIndicator.hidden = NO;
    [self.loginActivityIndicator startAnimating];

}

- (IBAction)cancelFreeSubscription:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(cancelButtonClickedFromFreeSub)]) {
        [self.delegate cancelButtonClickedFromFreeSub];
    }
}

- (void)showWelcomeScreen
{
    
    [self.loginActivityIndicator stopAnimating];
    self.loginActivityIndicator.hidden = YES;
    
    self.startButtonOutlet.hidden = YES;
    self.cancelButtonOutlet.hidden = YES;
    self.titleFreeSubscriptionOutlet.hidden = YES;
    self.detailDiscrptionOutlet.hidden = YES;
    
    self.welcomeTitleOulet.hidden = NO;
    self.startLineOutlet.hidden = NO;
    self.endDateOutlet.hidden = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    [dateFormatter setDateStyle:NSDateFormatterLongStyle]; // day, Full month and year
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *myStringDate = [dateFormatter stringFromDate:[[BGMSubscriptionManager sharedInstance] startDate]];
    
    // How much day to add
    int addDaysCount = 30;
    
    // Retrieve NSDate instance from stringified date presentation
    NSDate *dateFromString = [dateFormatter dateFromString:myStringDate];
    
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:addDaysCount];
    
    // Retrieve date with increased days count
    NSDate *newDate = [[NSCalendar currentCalendar]
                       dateByAddingComponents:dateComponents
                       toDate:dateFromString options:0];
    
    self.endDateOutlet.text = [dateFormatter stringFromDate:newDate];
    
    [self performSelector:@selector(postNotificationWithDelay) withObject:nil afterDelay:2.0];

}

- (void)hideLoginActivityIndicator {
    
    [self.loginActivityIndicator stopAnimating];
    self.loginActivityIndicator.hidden = YES;
}

- (void)postNotificationWithDelay
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SETTINGS_TAB_CLICK_NOTIFICATION object:nil];
    [self performSelector:@selector(resetSettingView) withObject:nil afterDelay:1.0];

}

- (void)resetSettingView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RESET_SETTINGS_TAB_CLICK_NOTIFICATION object:nil];
}

@end
