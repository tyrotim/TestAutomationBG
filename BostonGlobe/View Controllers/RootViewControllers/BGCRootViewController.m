//
//  BGCMainViewController.m
//  BostonGlobe
//
//  Created by Christian Grise on 12/19/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGCRootViewController.h"
#import "BGMIssue.h"
#import "BGMIssueManager.h"
#import "BGMSection.h"
#import "BGMSectionAbstract.h"
#import "BGMSectionManager.h"
#import "BGMArticleManager.h"
#import "BGCSectionStoryFeedTableViewController.h"
#import "BGCSectionSliderViewController.h"
#import "BGCHeaderBarViewController.h"
#import "BGCSettingViewController.h"
#import "BGCSectionScrollViewController.h"
#import "BGCSettingsPanelTableViewController.h"
#import "BGCActivityIndicatorViewController.h"
#import "BGMSubscriptionManager.h"
#import "BGCSplitViewController.h"

#define chromeTransparency 0.9

@interface BGCRootViewController () <BGCSectionSliderViewControllerDelegate>

@property (nonatomic, copy)   NSArray *subViewControllers;
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UINavigationController *sectionNavigationController;
@property (nonatomic, strong) UINavigationController *settingNavigationController;

@property (nonatomic, assign) CGPoint sectionSlideViewOrigin;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic,assign) CGFloat const menuClosedX;
@property (nonatomic,assign) CGFloat midPoint;
@property (nonatomic,assign) CGFloat const menuOpenX;
@property (nonatomic) BOOL isSettingViewOpen;
@property (nonatomic) BOOL isTrafficViewOpen;

@property (nonatomic) BOOL isDefaultSettingViewOpen;
@property (nonatomic) BOOL isSettingPanelViewOpen;

@property (nonatomic, assign) BOOL isChromeHidden;

@property (nonatomic, retain) BGCActivityIndicatorViewController *activityIndicator;

@end

@implementation BGCRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReady) name:ISSUE_DONE_UNZIPPING_NOTIFICATION object:nil];
    }
    
    return self;
}

- (void)dataReady
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
	UIView *view = [[UIView alloc] initWithFrame:frame];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self setUpHeaderBarController:view];
    [self setUpSectionMenuController:view];
    
    self.sectionSlideViewOrigin = self.sectionMenuController.view.frame.origin;
    
    self.menuOpenX = self.sectionSlideViewOrigin.x - self.sectionMenuController.sectionTableView.frame.size.width;
    self.menuClosedX = self.sectionMenuController.view.frame.origin.x;
    self.midPoint = self.sectionMenuController.sectionTableView.frame.origin.x + (self.sectionMenuController.sectionTableView.frame.size.width/2);
    
    self.sectionScrollViewController = [[BGCSectionScrollViewController alloc] initWithNibName:nil bundle:nil];
    self.sectionScrollViewController.rootViewController = self;
    
    self.sectionNavigationController = [[UINavigationController alloc] initWithRootViewController:self.sectionScrollViewController];
    self.sectionNavigationController.navigationBarHidden = YES;
    
    [view addSubview:self.sectionNavigationController.view];
    [self.sectionNavigationController didMoveToParentViewController:self];
    [self addChildViewController:self.sectionNavigationController];
    
    [self.sectionScrollViewController setUpStoryFeedViewControllers];
    
    self.splitViewController = [[BGCSplitViewController alloc] initWithNibName:@"BGCSplitViewController" bundle:nil];
    self.splitViewController.view.frame = CGRectMake(0, -460, 320, 460);
    [view addSubview:self.splitViewController.view];
    
    self.settingViewController = [[BGCSettingViewController alloc] initWithNibName:@"BGCSettingViewController" bundle:nil];
    self.settingViewController.view.frame = CGRectMake(0, -460, 320, 460);
    [view addSubview:self.settingViewController.view];
    
    self.settingTVC = [[BGCSettingsPanelTableViewController alloc] initWithNibName:@"BGCSettingsPanelTableViewController" bundle:nil];
    
    self.settingNavigationController = [[UINavigationController alloc] initWithRootViewController:self.settingTVC];
    
    self.settingNavigationController.view.frame = CGRectMake(0, -460, 320, 460);
    [view addSubview:self.settingNavigationController.view];
    
    [self.settingNavigationController didMoveToParentViewController:self];
    [self addChildViewController:self.settingNavigationController];
    
    [self addSettingViewToRootViewController];
    
    [view sendSubviewToBack:self.settingViewController.view];
    [view sendSubviewToBack:self.settingTVC.view];
    [view sendSubviewToBack:self.settingNavigationController.view];
    [view sendSubviewToBack:self.splitViewController.view];
    [view sendSubviewToBack:self.sectionMenuController.view];
    
    [view sendSubviewToBack:self.sectionNavigationController.view];
    self.sectionNavigationController.view.frame = [[UIScreen mainScreen] bounds];
    
    self.isSettingViewOpen = NO;
    self.isTrafficViewOpen = NO;
    
    [self.activityIndicator stop];
    [self.activityIndicator.view removeFromSuperview];
    
    [self.view addSubview:view];
}

#pragma mark - View lifecycle

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
	UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    self.activityIndicator = [[BGCActivityIndicatorViewController alloc] initWithNibName:@"BGCActivityIndicatorViewController" bundle:nil];
    [self.activityIndicator centerSpinnerWithViewFrame:frame];
    [view addSubview:self.activityIndicator.view];
    [self.activityIndicator start];
    
    self.view = view;
}

- (void)addSettingViewToRootViewController
{
    if ([[BGMSubscriptionManager sharedInstance] isSubscriptionValid]) {
        self.isDefaultSettingViewOpen = NO;
        self.isSettingPanelViewOpen = YES;
    } else {
        self.isDefaultSettingViewOpen = YES;
        self.isSettingPanelViewOpen = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSettingTab) name:SETTINGS_TAB_CLICK_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTrafficTab) name:WEATHER_TAB_CLICK_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSettingViewToRootViewController) name:RESET_SETTINGS_TAB_CLICK_NOTIFICATION object:nil];
}

- (void)setUpHeaderBarController:(UIView *)view
{
    self.headerBarController = [[BGCHeaderBarViewController alloc] initWithNibName:@"BGCHeaderBarViewController" bundle:nil];
    self.headerBarController.rootViewController = self;

    [view addSubview:self.headerBarController.view];
    [self.headerBarController didMoveToParentViewController:self];
    [self addChildViewController:self.headerBarController];

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    self.storyFeedFrame = screenBound;
}

- (void)setUpSectionMenuController:(UIView *)view
{
    self.sectionMenuController = [[BGCSectionSliderViewController alloc] initWithNibName:@"BGCSectionSliderViewController" bundle:nil];
    self.sectionMenuController.delegate = self;

    self.sectionMenuController.view.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - self.sectionMenuController.sectionSliderNub.frame.size.width, 82, self.sectionMenuController.view.frame.size.width, self.sectionMenuController.view.frame.size.height);
    
    [view addSubview:self.sectionMenuController.view];
    [self.sectionMenuController didMoveToParentViewController:self];
    [self addChildViewController:self.sectionMenuController];
    
}

#pragma mark - Get BGCSectionSliderViewControllerDelegate

- (void)sectionSliderViewController:(BGCSectionSliderViewController *)sectionSliderViewController didSelectSectionWithIdentifier:(NSString *)identifier
{
    if (self.sectionNavigationController.topViewController.class != self.sectionScrollViewController.class) {
        [self.sectionNavigationController popToRootViewControllerAnimated:YES];
        [self changeChromeToSectionViewChrome];
    }
    if (self.isChromeHidden) {
        [self showChromeWithDelay:0.0];
    }
    BGMSection *section = [[BGMSectionManager sharedInstance] sectionForID:identifier];
    self.sectionScrollViewController.sectionStoryFeedTableViewController.section = section;
    [self.sectionScrollViewController.sectionStoryFeedTableViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    int sectionIndex = [self indexForID:identifier];
    int prevSectionIndex = sectionIndex - 1;
    int nextSectionIndex = sectionIndex + 1;
    
    if (prevSectionIndex == -1) {
        prevSectionIndex = self.sectionScrollViewController.sectionAbstractArray.count - 1;
    }
    
    if (nextSectionIndex >= self.sectionScrollViewController.sectionAbstractArray.count) {
        nextSectionIndex = 0;
    }
    
    BGMSection *prevSection = [[BGMSectionManager sharedInstance] sectionForID:[self.sectionScrollViewController.sectionAbstractArray[prevSectionIndex] identifier]];
    self.sectionScrollViewController.prevSectionStoryFeedTableViewController.section = prevSection;
    [self.sectionScrollViewController.prevSectionStoryFeedTableViewController.tableView reloadData];
    
    BGMSection *nextSection = [[BGMSectionManager sharedInstance] sectionForID:[self.sectionScrollViewController.sectionAbstractArray[nextSectionIndex] identifier]];
    self.sectionScrollViewController.nextSectionStoryFeedTableViewController.section = nextSection;
    [self.sectionScrollViewController.nextSectionStoryFeedTableViewController.tableView reloadData];
    
    self.sectionScrollViewController.currIndex = sectionIndex;
    
    if ([self.sectionScrollViewController.sectionStoryFeedTableViewController.tableView numberOfRowsInSection:0] > 0) {
        [self.sectionScrollViewController.sectionStoryFeedTableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    [self closeSlideView];
    
    [self changeHeaderSection:[self.sectionScrollViewController.sectionAbstractArray[self.sectionScrollViewController.currIndex] name]];
}

- (int)indexForID:(NSString *)identifier
{
    int returnVal = -1;
    for (BGMSectionAbstract *sectionAbstract in self.sectionScrollViewController.sectionAbstractArray) {
        if ([sectionAbstract.identifier isEqualToString:identifier]) {
            returnVal = [self.sectionScrollViewController.sectionAbstractArray indexOfObject:sectionAbstract];
        }
    }
    return returnVal;
}

- (void)changeHeaderSection:(NSString *)newSection
{
    self.headerBarController.sectionLabel.text = newSection;
}

- (void)changeChromeToArticleViewChrome
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [self.headerBarController.storyfeedButton setAlpha:chromeTransparency];
    [self.headerBarController.verticalSeparatorImage1 setAlpha:chromeTransparency];
    [self.headerBarController.sectionDateButton setAlpha:chromeTransparency];
    [self.headerBarController.verticalSeparatorImage2 setAlpha:chromeTransparency];
    [self.headerBarController.weatherButton setAlpha:chromeTransparency];
    [self.headerBarController.verticalSeparatorImage3 setAlpha:chromeTransparency];
    [self.headerBarController.settingsButton setAlpha:chromeTransparency];
    [UIView commitAnimations];
}

- (void)changeChromeToSectionViewChrome
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [self.headerBarController.storyfeedButton setAlpha:1.0];
    [self.headerBarController.verticalSeparatorImage1 setAlpha:1.0];
    [self.headerBarController.sectionDateButton setAlpha:1.0];
    [self.headerBarController.verticalSeparatorImage2 setAlpha:1.0];
    [self.headerBarController.weatherButton setAlpha:1.0];
    [self.headerBarController.verticalSeparatorImage3 setAlpha:1.0];
    [self.headerBarController.settingsButton setAlpha:1.0];
    [UIView commitAnimations];
}

- (void)storyfeedButtonPressed
{
    if (self.isSettingViewOpen) {
        [self handleSettingTab];
    }
    
    if (self.isTrafficViewOpen) {
        [self handleTrafficTab];
    }
    
    [self sectionSliderViewController:self.sectionMenuController
       didSelectSectionWithIdentifier:MyGlobeSectionIdentifier];
}

- (void)sectionDateButtonPressed
{
    if (self.isSettingViewOpen) {
        [self handleSettingTab];
    }
    
    if (self.isTrafficViewOpen) {
        [self handleTrafficTab];
    }
    
    [self.sectionNavigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Touch Event Listeners
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    for (UITouch *touch in allTouches) {
        if([touch.view isEqual:self.sectionMenuController.sectionSliderNub]){
            self.sectionSlideViewOrigin = self.sectionMenuController.view.frame.origin;
            self.startPoint = [touch locationInView:self.view];
        }
    }
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    for (UITouch *touch in allTouches) {
        if([touch.view isEqual:self.sectionMenuController.sectionSliderNub]){
            self.endPoint = [touch locationInView:self.view];
            [self moveSlideView:YES];
        } else {
            
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    for (UITouch *touch in allTouches) {
        if([touch.view isEqual:self.sectionMenuController.sectionSliderNub]){
            self.endPoint = [touch locationInView:self.view];
            [self moveSlideView:YES];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    for (UITouch *touch in allTouches) {
        if ([touch.view isEqual:self.sectionMenuController.sectionSliderNub]){
            self.endPoint = [touch locationInView:self.view];
            [self moveSlideView:NO];
        }
    }
}

- (void)moveSlideView:(BOOL)shouldSnap
{
    CGFloat dx = self.endPoint.x - self.startPoint.x;
    CGRect frame = CGRectMake(self.sectionSlideViewOrigin.x + dx, self.sectionMenuController.view.frame.origin.y, self.sectionMenuController.view.frame.size.width, self.sectionMenuController.view.frame.size.height);
    CGPoint origin = frame.origin;
    
    BOOL isPullingLeft = NO;
    BOOL isPullingRight = NO;
    
    if(dx < 0){
        isPullingLeft = YES;
    }
    if(dx > 0){
        isPullingRight = YES;
    }
    
    if (frame.origin.x > self.menuClosedX) {
        frame = CGRectMake(self.menuClosedX, frame.origin.y, frame.size.width, frame.size.height);
    } else if (frame.origin.x < self.menuOpenX) {
        frame = CGRectMake(self.menuOpenX, frame.origin.y, frame.size.width, frame.size.height);
    }
    
    if (shouldSnap) {
        if((isPullingLeft && dx < -self.midPoint) || origin.x < self.midPoint){
            origin = CGPointMake(self.menuOpenX, self.sectionMenuController.view.frame.origin.y);
        }
        else if((isPullingRight && dx > self.midPoint) || origin.x >= self.midPoint){
            origin = CGPointMake(self.menuClosedX, self.sectionMenuController.view.frame.origin.y);
        }
        
        frame = CGRectMake(origin.x, origin.y, frame.size.width, frame.size.height);
        self.startPoint = self.endPoint = CGPointZero;
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.sectionMenuController.view.frame = frame;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
    else{
        self.sectionMenuController.view.frame = frame;
    }
}

- (void)closeSlideView
{
    CGRect frame = CGRectMake(self.menuClosedX, self.sectionSlideViewOrigin.y, self.sectionMenuController.view.frame.size.width, self.sectionMenuController.view.frame.size.height);
    self.startPoint = self.endPoint = CGPointZero;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.sectionMenuController.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)toggleChromeWithDelay:(CGFloat)delay
{
    if (self.isChromeHidden) {
        [self showChromeWithDelay:delay];
    } else {
        [self hideChromeWithDelay:delay];
    }
}

- (void)showChromeWithDelay:(CGFloat)delay
{
    [self.chromeTimer invalidate];
    
    self.chromeTimer = nil;
    
    self.chromeTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                        target:self
                                                      selector:@selector(showChrome)
                                                      userInfo:nil
                                                       repeats:NO];
}

- (void)showChrome
{
    [self showSlideTray];
    [self showHeaderBar];
}

- (void)showSlideTray
{
    CGRect frame = CGRectMake(self.menuClosedX, self.sectionSlideViewOrigin.y, self.sectionMenuController.view.frame.size.width, self.sectionMenuController.view.frame.size.height);
    self.startPoint = self.endPoint = CGPointZero;
    
    [UIView animateWithDuration:0.0
                     animations:^{
                         self.sectionMenuController.view.frame = self.sectionMenuController.view.frame;
                     }
                     completion:^(BOOL finished){
                     }];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.sectionMenuController.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         self.isChromeHidden = NO;
                     }];
}

- (void)showHeaderBar
{
    CGRect frame = CGRectMake(self.headerBarController.view.frame.origin.x, 0, self.headerBarController.view.frame.size.width, self.headerBarController.view.frame.size.height);
    self.startPoint = self.endPoint = CGPointZero;
    
    [self.headerBarController.view.layer removeAllAnimations];
    
    [UIView animateWithDuration:0.0
                     animations:^{
                         self.headerBarController.view.frame = self.headerBarController.view.frame;
                     }
                     completion:^(BOOL finished){
                     }];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.headerBarController.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)hideChromeWithDelay:(CGFloat)delay
{
    self.chromeTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                        target:self
                                                      selector:@selector(hideChrome)
                                                      userInfo:nil
                                                       repeats:NO];
}

- (void)hideChrome
{
    [self hideSlideTray];
    [self hideHeaderBar];
}

- (void)hideSlideTray
{
    CGRect frame = CGRectMake(320, self.sectionSlideViewOrigin.y, self.sectionMenuController.view.frame.size.width, self.sectionMenuController.view.frame.size.height);
    self.startPoint = self.endPoint = CGPointZero;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.sectionMenuController.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         self.isChromeHidden = YES;
                     }];
}

- (void)hideHeaderBar
{
    CGRect frame = CGRectMake(self.headerBarController.view.frame.origin.x, -(self.headerBarController.view.frame.size.height+1), self.headerBarController.view.frame.size.width, self.headerBarController.view.frame.size.height);
    self.startPoint = self.endPoint = CGPointZero;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.headerBarController.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

#pragma mark - Setting

- (void)handleSettingTab
{
    if (self.isTrafficViewOpen) {
        [self handleTrafficTab];
    }
    
    if (!self.isSettingViewOpen) {
        [self loadSettingView];
    } else {
        [self removeSettingView];
    }
}

- (void)loadSettingView
{
    
    if (self.isSettingPanelViewOpen) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.settingNavigationController.view.frame = CGRectMake(0, 43, 320, [[UIScreen mainScreen] bounds].size.height - 43);;
                         }
                         completion:^(BOOL finished){
                         }];
        self.isSettingViewOpen = YES;
    }
    
    if (self.isDefaultSettingViewOpen) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.settingViewController.view.frame = CGRectMake(0, 43, 320, [[UIScreen mainScreen] bounds].size.height - 43);;
                         }
                         completion:^(BOOL finished){
                         }];
        self.isSettingViewOpen = YES;
    }

}

- (void)removeSettingView
{

    if (self.isSettingPanelViewOpen) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.settingNavigationController.view.frame = CGRectMake(0, - [[UIScreen mainScreen] bounds].size.height, 320, [[UIScreen mainScreen] bounds].size.height);;
                         }
                         completion:^(BOOL finished){
                         }];
        self.isSettingViewOpen = NO;
    }
    
    if (self.isDefaultSettingViewOpen) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             self.settingViewController.view.frame = CGRectMake(0, - [[UIScreen mainScreen] bounds].size.height, 320, [[UIScreen mainScreen] bounds].size.height);;
                         }
                         completion:^(BOOL finished){
                         }];
        self.isSettingViewOpen = NO;
    }
}

- (void)handleTrafficTab
{
    if (self.isSettingViewOpen) {
        [self handleSettingTab];
    }
    
    if (!self.isTrafficViewOpen) {
        [self loadTrafficVC];
    } else {
        [self removeTrafficVC];
    }
}

- (void)loadTrafficVC
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.splitViewController.view.frame = CGRectMake(0, 43, 320, [[UIScreen mainScreen] bounds].size.height - 43);;
                     }
                     completion:^(BOOL finished){
                     }];
    self.isTrafficViewOpen = YES;
}

- (void)removeTrafficVC
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.splitViewController.view.frame = CGRectMake(0, - [[UIScreen mainScreen] bounds].size.height, 320, [[UIScreen mainScreen] bounds].size.height);;
                     }
                     completion:^(BOOL finished){
                     }];
    self.isTrafficViewOpen = NO;
}

@end
