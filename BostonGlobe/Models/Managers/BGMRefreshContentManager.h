//
//  BGMCurrentContentCacheManager.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BGMArticle, BGMSection;

@interface BGMRefreshContentManager : NSObject

+ (BGMRefreshContentManager *)sharedInstance;
- (BGMSection *)sectionForID:(NSString *)identifier;
- (BGMArticle *)articleForID:(NSString *)identifier;

@end
