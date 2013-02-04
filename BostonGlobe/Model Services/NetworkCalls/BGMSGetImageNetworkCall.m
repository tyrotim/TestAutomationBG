//
//  BGMSGetImageNetworkCall.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/3/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMSGetImageNetworkCall.h"
#import "BGMArticleImage.h"

@implementation BGMSGetImageNetworkCall

- (id)initWithArticleImage:(BGMArticleImage *)articleImage
{
    self = [super init];
    
    if (self) {
        self.articleImage = articleImage;
    }
    
    return self;
}

- (void)addParametersForCall
{
    self.requestURL = [NSURL URLWithString:self.articleImage.imageURL];
    
    [super addParametersForCall];
}

- (void)formatResponseWithData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    [super formatResponseWithData:data error:error];

    if ([UIImage imageWithData:data] == nil) {
        *error = [NSError mobMSNetworkCall_errorDataFormatError];
    }
}

@end
