//
//  UIFont+BostonGlobeFonts.m
//  BostonGlobe
//
//  Created by Christian Grise on 1/17/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "UIFont+BostonGlobeFonts.h"

@implementation UIFont (BostonGlobeFonts)

+ (UIFont *)bentonSansRegularFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:BentonSansRegular size:fontSize];
}

+ (UIFont *)bentonSansBoldFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:BentonSansBold size:fontSize];
}

+ (UIFont *)bentonSansBlackFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:BentonSansBlack size:fontSize];
}

+ (UIFont *)bentonSansMediumFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:BentonSansMedium size:fontSize];
}

+ (UIFont *)millerHeadlineBoldFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:MillerHeadlineBold size:fontSize];
}

+ (UIFont *)millerHeadlineLightFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:MillerHeadlineLight size:fontSize];
}

+ (UIFont *)millerHeadlineRomanFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:MillerHeadlineRoman size:fontSize];
}

+ (UIFont *)millerHeadlineSemiBoldFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:MillerHeadlineSemiBold size:fontSize];
}

+ (UIFont *)headlineLabelFont
{
    static UIFont *headlineFont;
    
    if (nil == headlineFont) {
        headlineFont = [UIFont millerHeadlineBoldFontOfSize:20];
    }
    
    return headlineFont;
}

+ (UIFont *)abstractParagraphLabelFont
{
    static UIFont *abstractParagraphFont;
    
    if (nil == abstractParagraphFont) {
        abstractParagraphFont = [UIFont fontWithName:Georgia size:11];
    }
    
    return abstractParagraphFont;
}

+ (UIFont *)publishedDateLabelFont
{
    static UIFont *publishedDateFont;
    
    if (nil == publishedDateFont) {
        publishedDateFont = [UIFont bentonSansRegularFontOfSize:7];
    }
    return publishedDateFont;
}

+ (UIFont *)sectionLabelFont
{
    static UIFont *sectionFont;
    
    if (nil == sectionFont) {
        sectionFont = [UIFont bentonSansRegularFontOfSize:7];
    }
    
    return sectionFont;
}

@end
