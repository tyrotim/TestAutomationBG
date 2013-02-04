//
//  BGCSettingViewController.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/7/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCSettingViewController.h"
#import "BGMInAppPurchaseManager.h"
#import "BGCActivityIndicatorViewController.h"

@interface BGCSettingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *perMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *perWeekButton;
@property (weak, nonatomic) IBOutlet UIButton *freeTrialButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *subscriptionActivityIndicator;

@end

@implementation BGCSettingViewController

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
    
    self.activitySpinnerView.layer.cornerRadius = 5;
    self.activitySpinnerView.layer.masksToBounds = YES;
    
    self.subscriptionActivityIndicator.transform = CGAffineTransformMakeScale(3, 3);
    
    self.defaultRestoreView.hidden = YES;
        
    self.freeSubscriptionVC = [[BGCFreeSubscriptionViewController alloc] initWithNibName:@"BGCFreeSubscriptionViewController" bundle:nil];    
    self.freeSubscriptionVC.delegate = self;
    
    self.bgLoginViewController = [[BGCLoginViewController alloc] initWithNibName:@"BGCLoginViewController" bundle:nil];
    self.bgLoginViewController.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bringToDefaultState) name:SETTINGS_TAB_CLICK_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postNotificationWithDelay) name:IN_APP_PURCHASE_MANAGER_TRANSACTION_SUCCEEDED_NOTIFICATION_ONE_WEEK_SUB object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postNotificationWithDelay) name:IN_APP_PURCHASE_MANAGER_TRANSACTION_SUCCEEDED_NOTIFICATION_ONE_MONTH_SUB object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableSubscriptionButtonsAndUI) name:IN_APP_PURCHASE_MANAGER_TRANSACTION_USER_CANCELLED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postNotificationWithDelay) name:IN_APP_PURCHASE_MANAGER_TRANSACTION_SUCCEEDED_NOTIFICATION_RESTORE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeRestoreView) name:IN_APP_PURCHASE_MANAGER_TRANSACTION_FAILED_NOTIFICATION_RESTORE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLoginView) name:BOSTON_GLOBE_LOGIN_SUCCEEDED_NOTIFICATION object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{  
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)freeSubscription:(id)sender
{
    self.freeSubscriptionVC.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height);
    [self.view addSubview:self.freeSubscriptionVC.view];
}

- (IBAction)perMonthSubscription:(id)sender
{
    [self disableSubscriptionButtonsAndUI];
    [[BGMInAppPurchaseManager sharedInstance] requestOneMonthSubscriptionProductData];
}

- (IBAction)perWeekSubscription:(id)sender
{
    [self disableSubscriptionButtonsAndUI];
    [[BGMInAppPurchaseManager sharedInstance] requestOneWeekSubscriptionProductData];
}

- (void)disableSubscriptionButtonsAndUI
{
    self.perMonthButton.enabled = NO;
    self.perWeekButton.enabled = NO;
    self.freeTrialButton.enabled = NO;
    
    [self.subscriptionActivityIndicator startAnimating];
}

- (void)enableSubscriptionButtonsAndUI
{
    self.perMonthButton.enabled = YES;
    self.perWeekButton.enabled = YES;
    self.freeTrialButton.enabled = YES;
    
    [self.subscriptionActivityIndicator stopAnimating];
}

- (IBAction)logInToBostonGlobe:(id)sender
{    
    self.bgLoginViewController.view.frame = CGRectMake(0, -self.view.bounds.size.height, 320, self.view.bounds.size.height);
    self.bgLoginViewController.delegate = self;
    CGRect newFrame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
    
    
    [self.view addSubview:self.bgLoginViewController.view];
    [self.bgLoginViewController didMoveToParentViewController:self];
    [self addChildViewController:self.bgLoginViewController];

    [UIView animateWithDuration:0.5
                     animations:^{
                         self.bgLoginViewController.view.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (IBAction)restoreSubscribtions:(id)sender
{    
    self.defaultRestoreView.hidden = NO;
    self.defaultSettingView.hidden = YES;
    
    [self.activityIndicatorRestore startAnimating];
    
    [[BGMInAppPurchaseManager sharedInstance] restoreInAppPurchase];
}

- (void)bringToDefaultState
{
    [self cancelButtonClickedFromFreeSub];
    [self cancelButtonClickedFromLogin];
}

- (void)cancelButtonClickedFromFreeSub
{
    [self.freeSubscriptionVC.view removeFromSuperview];
}

- (void)cancelButtonClickedFromLogin
{
    [self.bgLoginViewController.view removeFromSuperview];
}

- (void)postNotificationWithDelay
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SETTINGS_TAB_CLICK_NOTIFICATION object:nil];
    [self performSelector:@selector(resetSettingView) withObject:nil afterDelay:1.0];
    
    self.defaultRestoreView.hidden = YES;
    self.defaultSettingView.hidden = NO;
    
    [self.activityIndicatorRestore stopAnimating];
}

- (void)resetSettingView 
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RESET_SETTINGS_TAB_CLICK_NOTIFICATION object:nil];
}

- (void)removeRestoreView
{
    
    self.defaultRestoreView.hidden = YES;
    self.defaultSettingView.hidden = NO;
    
    [self.activityIndicatorRestore stopAnimating];
}

- (void)removeLoginView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SETTINGS_TAB_CLICK_NOTIFICATION object:nil];
}
@end
