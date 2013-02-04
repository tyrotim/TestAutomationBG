//
//  BGVSectionStoryFeedCell.m
//  BostonGlobe
//
//  Created by Christian Grise on 1/15/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGVSectionStoryFeedCell.h"
#import "UIFont+BostonGlobeFonts.h"

#define cellTopPadding 14
#define cellBottomPadding 20
#define cellLeftPadding 15
#define cellRightPadding 15
#define headlineToAbstractPadding 4
#define abstractToPublishedDatePadding 7

#define screenSize 320

@implementation BGVSectionStoryFeedCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // set all fonts on all fields
        self.headlineLabel = self.textLabel;
        self.headlineLabel.font = [UIFont headlineLabelFont];
        self.headlineLabel.numberOfLines = 0;
       
        self.abstractParagraphLabel = self.detailTextLabel;
        self.abstractParagraphLabel.font = [UIFont abstractParagraphLabelFont];
        self.abstractParagraphLabel.numberOfLines = 0;
        
        self.publishedDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.publishedDateLabel.font = [UIFont publishedDateLabelFont];
        
        self.sectionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.sectionLabel.font = [UIFont sectionLabelFont];
        
        self.cellSeparator = self.imageView;
        
        [self addSubview:self.sectionLabel];
        [self addSubview:self.publishedDateLabel];
        
        self.clipsToBounds = YES;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithReuseIdentifier:reuseIdentifier];
}

+ (NSString *)formatPublishedStringfromDate:(NSDate *)publishedDate
{
    static NSDateFormatter *publishedDateFormatter = nil;
    
    if (nil == publishedDateFormatter) {
        publishedDateFormatter = [[NSDateFormatter alloc] init];
        publishedDateFormatter.dateFormat = @"hh:mm a";
        [publishedDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
    
    return [publishedDateFormatter stringFromDate:publishedDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.headlineLabel.frame = [[self class] headlineFrameWithHeadlineString:self.headlineLabel.text];
    self.abstractParagraphLabel.frame = [[self class] abstractParagraphFrameWithAbstractParagraph:self.abstractParagraphLabel.text headlineLabelFrame:self.headlineLabel.frame];
    self.publishedDateLabel.frame = [[self class] publishedDateFrameWithPublishedDate:self.publishedDateLabel.text abstractParagraphFrame:self.abstractParagraphLabel.frame];
    self.sectionLabel.frame = [[self class] sectionFrameWithSectionString:self.sectionLabel.text publishedDateFrame:self.publishedDateLabel.frame];
    self.cellSeparator.image = [UIImage imageNamed:@"storyfeed_Cell_Separator.png"];
    self.cellSeparator.frame = [[self class] cellSeparatorWithPublishedDateFrame:self.publishedDateLabel.frame];
}

#pragma mark - Get custom cell height for TableViewCell

+ (CGFloat)heightForCellWithHeadline:(NSString *)headline abstractParagraph:(NSString *)abstractParagraph publishedDate:(NSDate *)publishedDate section:(NSString *)section
{
    CGFloat cellHeight = 0;
    
    NSString *publishedDateString = [[self class] formatPublishedStringfromDate:publishedDate];

    CGRect headlineLabelFrame = [[self class] headlineFrameWithHeadlineString:headline];
    CGRect abstractParagraphLabelFrame = [[self class] abstractParagraphFrameWithAbstractParagraph:abstractParagraph headlineLabelFrame:headlineLabelFrame];
    CGRect publishedDateLabelFrame = [[self class] publishedDateFrameWithPublishedDate:publishedDateString abstractParagraphFrame:abstractParagraphLabelFrame];
    
    cellHeight = publishedDateLabelFrame.origin.y + publishedDateLabelFrame.size.height + cellBottomPadding + 1;

    return cellHeight;
}

- (void)setPublishedDate:(NSDate *)publishedDate
{
    self.publishedDateLabel.text = [[self class] formatPublishedStringfromDate:publishedDate];
}

+ (CGRect)headlineFrameWithHeadlineString:(NSString *)headline
{    
    CGRect headlineFrame = CGRectZero;
    headlineFrame.origin.x = cellLeftPadding;
    headlineFrame.origin.y = cellTopPadding;
    headlineFrame.size = [headline sizeWithFont:[UIFont headlineLabelFont] constrainedToSize:CGSizeMake(screenSize - cellLeftPadding - cellRightPadding, 10000)];
    
    CGFloat numberOfLines = headlineFrame.size.height/[[UIFont headlineLabelFont] lineHeight];
    headlineFrame.size.height = headlineFrame.size.height + (numberOfLines - 1) * headerLineSpacing;
    
    return headlineFrame;
}

+ (CGRect)abstractParagraphFrameWithAbstractParagraph:(NSString *)abstractParagraph headlineLabelFrame:(CGRect)headlineLabelFrame
{
    CGRect abstractParaFrame = CGRectZero;
    abstractParaFrame.origin.x = cellLeftPadding;
    abstractParaFrame.origin.y = headlineLabelFrame.origin.y + headlineLabelFrame.size.height + headlineToAbstractPadding;
    abstractParaFrame.size = [abstractParagraph sizeWithFont:[UIFont abstractParagraphLabelFont] constrainedToSize:CGSizeMake(screenSize - cellLeftPadding - cellRightPadding, 10000)];
    
    CGFloat numberOfLines = abstractParaFrame.size.height/[[UIFont abstractParagraphLabelFont] lineHeight];
    abstractParaFrame.size.height = abstractParaFrame.size.height + (numberOfLines - 1) * abstractParagraphLineSpacing;
    
    return abstractParaFrame;
}

+ (CGRect)publishedDateFrameWithPublishedDate:(NSString *)publishedDateString abstractParagraphFrame:(CGRect)abstractParagraphFrame
{
    CGRect publishedDateFrame = CGRectZero;
    publishedDateFrame.size = [publishedDateString sizeWithFont:[UIFont publishedDateLabelFont] constrainedToSize:CGSizeMake(screenSize - cellLeftPadding - cellRightPadding, 10000)];
    publishedDateFrame.origin.x = cellLeftPadding;
    publishedDateFrame.origin.y = abstractParagraphFrame.origin.y + abstractParagraphFrame.size.height + abstractToPublishedDatePadding;
    
    return publishedDateFrame;
}

+ (CGRect)sectionFrameWithSectionString:(NSString *)sectionString publishedDateFrame:(CGRect)publishedDateFrame
{
    CGRect sectionFrame = CGRectZero;
    sectionFrame.size = [sectionString sizeWithFont:[UIFont sectionLabelFont] constrainedToSize:CGSizeMake(screenSize - cellLeftPadding - cellRightPadding, 10000)];
    sectionFrame.origin.x = publishedDateFrame.origin.x + publishedDateFrame.size.width + cellLeftPadding/3;
    sectionFrame.origin.y = publishedDateFrame.origin.y;
    
    return sectionFrame;
}

+ (CGRect)cellSeparatorWithPublishedDateFrame:(CGRect)publishedDateFrame
{
    CGRect cellSeparatorFrame = CGRectZero;
    cellSeparatorFrame.origin.x = cellLeftPadding;
    cellSeparatorFrame.origin.y = publishedDateFrame.origin.y + publishedDateFrame.size.height + cellBottomPadding;
    cellSeparatorFrame.size.height = 1;
    cellSeparatorFrame.size.width = screenSize - cellLeftPadding - cellRightPadding;
    return cellSeparatorFrame;
}

@end
