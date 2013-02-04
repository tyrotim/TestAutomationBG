//
//  BGMSGetArticleNetworkCall.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMSGetArticleNetworkCall.h"

@implementation BGMSGetArticleNetworkCall

- (void)addParametersForCall
{
    [super addParametersForCall];
}

- (void)formatResponseWithData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    [super formatResponseWithData:data error:error];
    
    self.article = nil;
    
    // parse the article here
    
    if (self.article == nil) {
        *error = [NSError mobMSNetworkCall_errorDataFormatError];
    }
}

@end
