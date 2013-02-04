//
//  BGCMainViewController.h
//  BostonGlobe
//
//  Created by Christian Grise on 12/19/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BGCSectionSliderViewController;
@class BGCHeaderBarViewController;
@class BGCSettingViewController;
@class BGCSectionScrollViewController;
@class BGCSettingsPanelTableViewController;
@class BGCSplitViewController;

@interface BGCRootViewController : UIViewController

@property (strong, nonatomic) BGCSectionSliderViewController *sectionMenuController;
@property (nonatomic, strong) BGCHeaderBarViewController *headerBarController;
@property (nonatomic, strong) BGCSettingViewController *settingViewController;
@property (nonatomic, strong) BGCSectionScrollViewController *sectionScrollViewController;
@property (nonatomic, strong) BGCSettingsPanelTableViewController *settingTVC;
@property (nonatomic, strong) BGCSplitViewController *splitViewController;
@property (nonatomic, assign) CGRect storyFeedFrame;
@property (nonatomic, strong) NSTimer *chromeTimer;

- (void)changeHeaderSection:(NSString *)newSection;
- (void)changeChromeToArticleViewChrome;
- (void)changeChromeToSectionViewChrome;
- (void)toggleChromeWithDelay:(CGFloat)delay;
- (void)hideChromeWithDelay:(CGFloat)delay;
- (void)showChromeWithDelay:(CGFloat)delay;

- (void)storyfeedButtonPressed;
- (void)sectionDateButtonPressed;

@end
