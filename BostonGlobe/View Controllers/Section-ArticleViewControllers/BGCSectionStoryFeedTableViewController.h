//
//  BGStoryFeedTableViewController.h
//  BostonGlobe
//
//  Created by Amit Vyawahare on 12/28/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGCArticleViewController.h"

@class BGMSection;
@class BGCSectionStoryFeedTableViewController;

@protocol BGCSectionStoryFeedTableViewControllerDelegate <NSObject>

- (void)sectionStoryFeedTableViewController:(BGCSectionStoryFeedTableViewController *)sectionStoryFeedTableViewController didSelectArticleWithIdentifier:(NSString *)identifier;

@end

@interface BGCSectionStoryFeedTableViewController : UITableViewController

@property (nonatomic, weak) id<BGCSectionStoryFeedTableViewControllerDelegate> delegate;
@property (nonatomic, strong) BGMSection *section;
@property (nonatomic, strong) BGCArticleViewController *articleViewController;

- (void)goBackToSectionStoryFeed;
- (void)clearTableCellHeights;

@end