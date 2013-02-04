//
//  BGMCurrentContentCacheManager.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMRefreshContentManager.h"
#import "BGMSection.h"
#import "BGMArticle.h"

@interface BGMRefreshContentManager ()

@end

static BGMRefreshContentManager *sharedInstance = nil;

@implementation BGMRefreshContentManager

#pragma mark - sharedInstance

+ (BGMRefreshContentManager *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[BGMRefreshContentManager alloc] init];
    }
    
    return sharedInstance;
}


#pragma mark - Get articles and sections

- (BGMSection *)sectionForID:(NSString *)identifier
{
    BGMSection *section = nil;
    
    return section;
}

- (BGMArticle *)articleForID:(NSString *)identifier
{
    BGMArticle *article = nil;
    
    return article;
}

@end
