//
//  BGStoryFeedTableViewController.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 12/28/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGCSectionStoryFeedTableViewController.h"
#import "UIFont+BostonGlobeFonts.h"
#import "BGMIssue.h"
#import "BGMSectionAbstract.h"
#import "BGMIssueManager.h"
#import "BGMSectionManager.h"
#import "BGMArticleManager.h"
#import "BGMArticleAbstract.h"
#import "BGMArticle.h"
#import "BGCArticleViewController.h"
#import "BGMSection.h"
#import "BGMArticleImage.h"
#import "BGMImageManager.h"
#import "BGVSectionStoryFeedCell.h"

@interface BGCSectionStoryFeedTableViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableDictionary *tableCellHeights;

@end

@implementation BGCSectionStoryFeedTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScreen *screen = [UIScreen mainScreen];
    [self.view setFrame:[screen applicationFrame]];
    
    self.articleViewController = [[BGCArticleViewController alloc] initWithArticle:nil];
    self.tableCellHeights = [[NSMutableDictionary alloc] init];
}

- (void)clearTableCellHeights
{
    [self.tableCellHeights removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.section.articleAbstracts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BGVSectionStoryFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BGMArticleAbstract *articleAbstract = [self.section.articleAbstracts objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[BGVSectionStoryFeedCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle  alloc] init] ;
    paragraphStyle.lineSpacing = headerLineSpacing;
    cell.headlineLabel.attributedText = [[NSAttributedString alloc]
                                         initWithString:articleAbstract.title
                                         attributes: @{ NSParagraphStyleAttributeName : paragraphStyle,
                                         NSFontAttributeName : [UIFont headlineLabelFont],
                                         NSForegroundColorAttributeName : [UIColor colorWithRed:0.02 green:0.027 blue:0.031 alpha:1]}];
    
    paragraphStyle = [[NSMutableParagraphStyle  alloc] init] ;
    paragraphStyle.lineSpacing = abstractParagraphLineSpacing;
    cell.abstractParagraphLabel.attributedText = [[NSAttributedString alloc]
                                                  initWithString:articleAbstract.articleDescription
                                                  attributes: @{  NSParagraphStyleAttributeName : paragraphStyle,
                                                  NSFontAttributeName : [UIFont abstractParagraphLabelFont],
                                                  NSForegroundColorAttributeName : [UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1]}];
    
    [cell setPublishedDate:articleAbstract.pubDate];
    cell.publishedDateLabel.font = [UIFont sectionLabelFont];
    cell.publishedDateLabel.textColor = [UIColor colorWithRed:0.278 green:0.278 blue:0.278 alpha:1];
    [cell.publishedDateLabel sizeToFit];
    
    cell.sectionLabel.text = [@"|    " stringByAppendingString:[articleAbstract.sectionName uppercaseString]];
    cell.sectionLabel.font = [UIFont sectionLabelFont];
    cell.sectionLabel.textColor = [UIColor colorWithRed:0.02 green:0.027 blue:0.031 alpha:1];
    [cell.sectionLabel sizeToFit];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (indexPath.row == self.section.articleAbstracts.count - 1) {
        cell.imageView.image = nil;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BGMArticleAbstract *articleAbstract = [self.section.articleAbstracts objectAtIndex:indexPath.row];
    
    BGVSectionStoryFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[BGVSectionStoryFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    CGFloat cellHeight = [BGVSectionStoryFeedCell heightForCellWithHeadline:articleAbstract.title abstractParagraph:articleAbstract.articleDescription publishedDate:articleAbstract.pubDate section:articleAbstract.sectionName];
    return cellHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BGMArticleAbstract *articleAbstract = [self.section.articleAbstracts objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(sectionStoryFeedTableViewController:didSelectArticleWithIdentifier:)]) {
        [self.delegate sectionStoryFeedTableViewController:self didSelectArticleWithIdentifier:articleAbstract.identifier];
    }
    self.articleViewController.sectionViewController = self;
}

- (void)goBackToSectionStoryFeed
{
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}

@end
