//
//  BGCSettingViewController.h
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/7/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BGCFreeSubscriptionViewController.h"
#import "BGCLoginViewController.h"
#import "BGCArticleViewController.h"

@interface BGCSettingViewController : UIViewController <FreeSubscriptionDelegate, BGLoginDelegate>

@property (nonatomic, strong) BGCFreeSubscriptionViewController *freeSubscriptionVC;
@property (nonatomic, strong) BGCLoginViewController *bgLoginViewController;
@property (weak, nonatomic) IBOutlet UIView *activitySpinnerView;
@property (weak, nonatomic) IBOutlet UIView *defaultSettingView;
@property (weak, nonatomic) IBOutlet UIView *defaultRestoreView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorRestore;

- (IBAction)freeSubscription:(id)sender;

- (IBAction)perMonthSubscription:(id)sender;
- (IBAction)perWeekSubscription:(id)sender;

- (IBAction)logInToBostonGlobe:(id)sender;
- (IBAction)restoreSubscribtions:(id)sender;

@end
