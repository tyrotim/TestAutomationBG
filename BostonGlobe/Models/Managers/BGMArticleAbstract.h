//
//  BGMArticleAbstract.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/11/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMCachedObject.h"

@interface BGMArticleAbstract : BGMCachedObject <NSCoding>

@property (nonatomic, strong)   NSDate *pubDate;                //UI: Story Feed, Article
@property (nonatomic, copy)     NSString *title;                //UI: Story Feed, Article
@property (nonatomic, copy)     NSString *author;               //UI: Article 
@property (nonatomic, copy)     NSString *authorByTTL;          //UI: Article
@property (nonatomic, copy)     NSString *articleDescription;   //UI: Story Feed
@property (nonatomic, copy)     NSString *kicker;               //UI: Article
@property (nonatomic, strong)   NSDate *printPubDate;           //Do we need this
@property (nonatomic, copy)     NSString *articleURL;           //Do we need this
@property (nonatomic, copy)     NSString *firstparagraph;       //Do we need this
@property (nonatomic, copy)     NSString *shortURL;             //DATA
@property (nonatomic, assign)   BOOL isLockedContent;           //DATA
@property (nonatomic, assign)   BOOL shouldDisplayAd;           //DATA
@property (nonatomic, copy)     NSArray *articleImages;         //DATA
@property (nonatomic, copy)     NSString *sectionName;          //UI: Story Feed, Article 
@property (nonatomic, copy)     NSString *sectionIdentifier;    //DATA
@property (nonatomic, copy)     NSString *identifier;           //DATA

- (id)initWithXMLElement:(GDataXMLElement *)element;

@end
