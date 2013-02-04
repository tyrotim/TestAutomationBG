//
//  BGMArticle.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMCachedObject.h"

@interface BGMArticle : BGMCachedObject <NSCoding>

@property (nonatomic, strong) BGMArticleAbstract *articleAbstract;
@property (nonatomic, copy) NSArray *paragraphs;

- (id)initWithXMLElement:(GDataXMLElement *)element andArticleAbstract:(BGMArticleAbstract *)articleAbstract;

@end
