//
//  UIFont+BostonGlobeFonts.h
//  BostonGlobe
//
//  Created by Christian Grise on 1/17/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (BostonGlobeFonts)

+ (UIFont *)bentonSansRegularFontOfSize:(CGFloat)fontSize;
+ (UIFont *)bentonSansBoldFontOfSize:(CGFloat)fontSize;
+ (UIFont *)bentonSansBlackFontOfSize:(CGFloat)fontSize;
+ (UIFont *)bentonSansMediumFontOfSize:(CGFloat)fontSize;

+ (UIFont *)headlineLabelFont;
+ (UIFont *)abstractParagraphLabelFont;
+ (UIFont *)publishedDateLabelFont;
+ (UIFont *)sectionLabelFont;

@end
