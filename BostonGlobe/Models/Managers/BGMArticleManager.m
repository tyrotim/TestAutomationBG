//
//  BGMArticleManager.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMArticleManager.h"
#import "BGMArticle.h"
#import "BGMRefreshContentManager.h"
#import "BGMIssueManager.h"
#import "BGMSGetArticleNetworkCall.h"

@interface BGMArticleManager ()

@end

static BGMArticleManager *sharedInstance = nil;

@implementation BGMArticleManager

#pragma mark - sharedInstance

+ (BGMArticleManager *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[BGMArticleManager alloc] init];
    }
    
    return sharedInstance;
}


#pragma mark - Get articles locally

- (BGMArticle *)articleForID:(NSString *)identifier
{    
    BGMArticle *articleToReturn = [[BGMRefreshContentManager sharedInstance] articleForID:identifier];
    
    if (articleToReturn == nil) {
        articleToReturn = [[BGMIssueManager sharedInstance] articleForID:identifier];
    }
    
    return articleToReturn;
}

@end
