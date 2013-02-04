//
//  BGMSGetArticleNetworkCall.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMSBaseNetworkCall.h"

@class BGMArticle;

@interface BGMSGetArticleNetworkCall : BGMSBaseNetworkCall

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) BGMArticle *article;

@end
