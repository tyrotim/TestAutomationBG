//
//  ArticleWithImageViewController.h
//  bostonglob
//
//  Created by Christian Grise on 12/28/12.
//  Copyright (c) 2012 Amit Vyawahare. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BGMArticle;
@class BGCSectionStoryFeedTableViewController;
@class BGCRootViewController;

@interface BGCArticleViewController : UIViewController

@property (nonatomic, strong) BGMArticle *article;
@property (nonatomic, weak) BGCSectionStoryFeedTableViewController *sectionViewController;
@property (nonatomic, weak) BGCRootViewController *rootViewController;

- (id)initWithArticle:(BGMArticle *)article;

@end
