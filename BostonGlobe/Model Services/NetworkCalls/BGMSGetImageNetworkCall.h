//
//  BGMSGetImageNetworkCall.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/3/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMSBaseNetworkCall.h"
@class BGMArticleImage;

@interface BGMSGetImageNetworkCall : BGMSBaseNetworkCall

- (id)initWithArticleImage:(BGMArticleImage *)articleImage;

@property (nonatomic, strong) BGMArticleImage *articleImage;

@end
