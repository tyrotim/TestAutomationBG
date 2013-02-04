//
//  BGCSectionScrollViewController.m
//  BostonGlobe
//
//  Created by Christian Grise on 1/10/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCSectionScrollViewController.h"
#import "BGCSectionStoryFeedTableViewController.h"
#import "BGCRootViewController.h"
#import "BGCSectionSliderViewController.h"
#import "BGMSection.h"
#import "BGMSectionManager.h"
#import "BGMArticle.h"
#import "BGMArticleManager.h"
#import "BGMSectionAbstract.h"
#import "BGMSectionListManager.h"
#import "BGCHeaderBarViewController.h"

@interface BGCSectionScrollViewController () <BGCSectionStoryFeedTableViewControllerDelegate, UIScrollViewDelegate>

@end

@implementation BGCSectionScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sectionScrollView = [[UIScrollView alloc] init];
        self.sectionScrollView.pagingEnabled = YES;
        self.sectionScrollView.delegate = self;
        self.sectionScrollView.bounces = NO;
        self.sectionScrollView.showsHorizontalScrollIndicator = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMyGlobeSection) name:BG_PREMIUM_PICK_TOPICS_CHANGED object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    BGMSectionAbstract *myGlobeSectionAbstract = [[BGMSectionAbstract alloc] init];
    myGlobeSectionAbstract.name = MyGlobeSectionName;
    myGlobeSectionAbstract.identifier = MyGlobeSectionIdentifier;
    self.sectionAbstractArray = [[NSArray arrayWithObject:myGlobeSectionAbstract] arrayByAddingObjectsFromArray:self.rootViewController.sectionMenuController.sectionArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rootViewController showChromeWithDelay:0.0];
    [self.rootViewController changeHeaderSection:[self.sectionAbstractArray[self.currIndex] name]];
    [self.rootViewController changeChromeToSectionViewChrome];
}

- (void)reloadMyGlobeSection
{
    [[BGMSectionListManager sharedInstance] myGlobeSectionList];
    
    BGMSection *newSection = [[BGMSectionManager sharedInstance] sectionForID:MyGlobeSectionIdentifier];
    
    if ([self.prevSectionStoryFeedTableViewController.section.identifier isEqualToString:MyGlobeSectionIdentifier]) {
        self.prevSectionStoryFeedTableViewController.section = newSection;
        [self.prevSectionStoryFeedTableViewController clearTableCellHeights];
        [self.prevSectionStoryFeedTableViewController.tableView reloadData];
    } else if ([self.sectionStoryFeedTableViewController.section.identifier isEqualToString:MyGlobeSectionIdentifier]) {
        self.sectionStoryFeedTableViewController.section = newSection;
        [self.sectionStoryFeedTableViewController clearTableCellHeights];
        [self.sectionStoryFeedTableViewController.tableView reloadData];
    } else if ([self.nextSectionStoryFeedTableViewController.section.identifier isEqualToString:MyGlobeSectionIdentifier]) {
        self.nextSectionStoryFeedTableViewController.section = newSection;
        [self.nextSectionStoryFeedTableViewController clearTableCellHeights];
        [self.nextSectionStoryFeedTableViewController.tableView reloadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
	if(self.sectionScrollView.contentOffset.x > self.sectionScrollView.frame.size.width) {
		[self loadPageWithId:self.currIndex onPage:0];
		self.currIndex = (self.currIndex >= self.sectionAbstractArray.count-1) ? 0 : self.currIndex + 1;
		[self loadPageWithId:self.currIndex onPage:1];
		self.nextIndex = (self.currIndex >= self.sectionAbstractArray.count-1) ? 0 : self.currIndex + 1;
		[self loadPageWithId:self.nextIndex onPage:2];
        if ([self.sectionStoryFeedTableViewController.tableView numberOfRowsInSection:0] > 0) {
            [self.sectionStoryFeedTableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
	}
	if(self.sectionScrollView.contentOffset.x < self.sectionScrollView.frame.size.width) {
		[self loadPageWithId:self.currIndex onPage:2];
		self.currIndex = (self.currIndex == 0) ? self.sectionAbstractArray.count-1 : self.currIndex - 1;
		[self loadPageWithId:self.currIndex onPage:1];
		self.prevIndex = (self.currIndex == 0) ? self.sectionAbstractArray.count-1 : self.currIndex - 1;
		[self loadPageWithId:self.prevIndex onPage:0];
        if ([self.sectionStoryFeedTableViewController.tableView numberOfRowsInSection:0] > 0) {
            [self.sectionStoryFeedTableViewController.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
	}
	
	[self.sectionScrollView scrollRectToVisible:CGRectMake(self.rootViewController.storyFeedFrame.origin.x + self.rootViewController.storyFeedFrame.size.width, self.rootViewController.headerBarController.view.frame.size.height, self.rootViewController.storyFeedFrame.size.width,self.rootViewController.storyFeedFrame.size.height) animated:NO];
}

- (void)loadPageWithId:(int)index onPage:(int)page
{
	// load data for page
    BGMSection *newSection = [[BGMSectionManager sharedInstance] sectionForID:[[self.sectionAbstractArray objectAtIndex:index] identifier]];
	switch (page) {
		case 0:
			self.prevSectionStoryFeedTableViewController.section = newSection;
            [self.prevSectionStoryFeedTableViewController clearTableCellHeights];
            [self.prevSectionStoryFeedTableViewController.tableView reloadData];
			break;
		case 1:
			self.sectionStoryFeedTableViewController.section = newSection;
            [self.sectionStoryFeedTableViewController clearTableCellHeights];
			[self.sectionStoryFeedTableViewController.tableView reloadData];
            break;
		case 2:
			self.nextSectionStoryFeedTableViewController.section = newSection;
            [self.nextSectionStoryFeedTableViewController clearTableCellHeights];
			[self.nextSectionStoryFeedTableViewController.tableView reloadData];
            break;
	}
    [self.rootViewController changeHeaderSection:[self.sectionAbstractArray[self.currIndex] name]];
}

#pragma mark - BGCSectionStoryFeedTableViewControllerDelegate

- (void)sectionStoryFeedTableViewController:(BGCSectionStoryFeedTableViewController *)sectionStoryFeedTableViewController didSelectArticleWithIdentifier:(NSString *)identifier{
    BGMArticle *article = [[BGMArticleManager sharedInstance] articleForID:identifier];
    self.sectionStoryFeedTableViewController.articleViewController = [[BGCArticleViewController alloc] initWithArticle:article];
    [self.navigationController pushViewController:self.sectionStoryFeedTableViewController.articleViewController animated:YES];
    [self.rootViewController changeChromeToArticleViewChrome];
    self.sectionStoryFeedTableViewController.articleViewController.rootViewController = self.rootViewController;
}

- (void)setUpStoryFeedViewControllers
{
    self.sectionScrollView.frame = self.rootViewController.storyFeedFrame;
    
    [self.view addSubview:self.sectionScrollView];
    
    self.sectionStoryFeedTableViewController = [[BGCSectionStoryFeedTableViewController alloc] initWithNibName:@"BGCSectionStoryFeedTableViewController" bundle:nil];
    BGMSectionAbstract *sectionAbstract = self.sectionAbstractArray[0];
    self.sectionStoryFeedTableViewController.section = [[BGMSectionManager sharedInstance] sectionForID:sectionAbstract.identifier];
    self.sectionStoryFeedTableViewController.view.frame = CGRectMake(self.rootViewController.storyFeedFrame.origin.x + self.rootViewController.storyFeedFrame.size.width, self.rootViewController.headerBarController.view.frame.size.height, self.rootViewController.storyFeedFrame.size.width, self.rootViewController.storyFeedFrame.size.height - self.rootViewController.headerBarController.view.frame.size.height);
    
    [self.sectionScrollView addSubview:self.sectionStoryFeedTableViewController.view];
    [self.sectionStoryFeedTableViewController didMoveToParentViewController:self];
    [self addChildViewController:self.sectionStoryFeedTableViewController];
    
    self.nextSectionStoryFeedTableViewController = [[BGCSectionStoryFeedTableViewController alloc] initWithNibName:@"BGCSectionStoryFeedTableViewController" bundle:nil];
    self.nextSectionStoryFeedTableViewController.section = [[BGMSectionManager sharedInstance] sectionForID:[self.sectionAbstractArray[1] identifier]];
    self.nextSectionStoryFeedTableViewController.view.frame = CGRectMake(self.rootViewController.storyFeedFrame.origin.x + self.rootViewController.storyFeedFrame.size.width + self.rootViewController.storyFeedFrame.size.width, self.rootViewController.headerBarController.view.frame.size.height, self.rootViewController.storyFeedFrame.size.width, self.rootViewController.storyFeedFrame.size.height - self.rootViewController.headerBarController.view.frame.size.height);
    
    [self.sectionScrollView addSubview:self.nextSectionStoryFeedTableViewController.view];
    [self.nextSectionStoryFeedTableViewController didMoveToParentViewController:self];
    [self addChildViewController:self.nextSectionStoryFeedTableViewController];

    self.prevSectionStoryFeedTableViewController = [[BGCSectionStoryFeedTableViewController alloc] initWithNibName:@"BGCSectionStoryFeedTableViewController" bundle:nil];
    self.prevSectionStoryFeedTableViewController.section = [[BGMSectionManager sharedInstance] sectionForID:[self.sectionAbstractArray[self.sectionAbstractArray.count-1] identifier]];
    self.prevSectionStoryFeedTableViewController.view.frame = CGRectMake(self.rootViewController.storyFeedFrame.origin.x, self.rootViewController.headerBarController.view.frame.size.height, self.rootViewController.storyFeedFrame.size.width, self.rootViewController.storyFeedFrame.size.height - self.rootViewController.headerBarController.view.frame.size.height);
    
    [self.sectionScrollView addSubview:self.prevSectionStoryFeedTableViewController.view];
    [self.prevSectionStoryFeedTableViewController didMoveToParentViewController:self];
    [self addChildViewController:self.prevSectionStoryFeedTableViewController];
    
    self.sectionScrollView.contentSize = CGSizeMake(960, self.sectionStoryFeedTableViewController.view.frame.size.height);
	[self.sectionScrollView scrollRectToVisible:CGRectMake(320,0,320,self.sectionStoryFeedTableViewController.view.frame.size.height) animated:NO];
    self.sectionStoryFeedTableViewController.delegate = self;
}

@end
