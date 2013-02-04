//
//  BGMArticleManager.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BGMArticle;

@interface BGMArticleManager : NSObject

+ (BGMArticleManager *)sharedInstance;
- (BGMArticle *)articleForID:(NSString *)identifier;

@end
