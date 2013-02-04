//
//  BGCSectionScrollViewController.h
//  BostonGlobe
//
//  Created by Christian Grise on 1/10/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BGCRootViewController;
@class BGCSectionStoryFeedTableViewController;

@interface BGCSectionScrollViewController : UIViewController

@property (nonatomic, strong) UIScrollView *sectionScrollView;
@property (nonatomic, weak) BGCRootViewController *rootViewController;

@property (nonatomic, strong) BGCSectionStoryFeedTableViewController *prevSectionStoryFeedTableViewController;
@property (nonatomic, strong) BGCSectionStoryFeedTableViewController *sectionStoryFeedTableViewController;
@property (nonatomic, strong) BGCSectionStoryFeedTableViewController *nextSectionStoryFeedTableViewController;

@property (nonatomic, strong) NSArray *sectionAbstractArray;
@property (nonatomic) int prevIndex;
@property (nonatomic) int currIndex;
@property (nonatomic) int nextIndex;

- (void)setUpStoryFeedViewControllers;

@end
