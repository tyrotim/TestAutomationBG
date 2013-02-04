//
//  BGVSectionStoryFeedCell.h
//  BostonGlobe
//
//  Created by Christian Grise on 1/15/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define abstractParagraphLineSpacing 2.0
#define headerLineSpacing 3.0

@interface BGVSectionStoryFeedCell : UITableViewCell

@property (nonatomic, strong) UILabel *headlineLabel;
@property (nonatomic, strong) UILabel *abstractParagraphLabel;
@property (nonatomic, strong) UILabel *publishedDateLabel;
@property (nonatomic, strong) UILabel *sectionLabel;
@property (nonatomic, strong) UIImageView *cellSeparator;

+ (CGFloat)heightForCellWithHeadline:(NSString *)headline
                   abstractParagraph:(NSString *)abstractParagraph
                       publishedDate:(NSDate *)publishedDate
                             section:(NSString *)section;

// Designated Initializer
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)setPublishedDate:(NSDate *)publishedDate;

@end
