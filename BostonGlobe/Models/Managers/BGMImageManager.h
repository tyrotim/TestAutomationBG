//
//  BGMImageManager.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/3/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BGMArticleImage;

@interface BGMImageManager : NSObject

// class methods
+ (BGMImageManager *)sharedInstance;
+ (NSString *)imagesFilePath;

// will load if not cached
- (NSString *)imagePathForArticleImage:(BGMArticleImage *)articleImage;
- (NSString *)imagePathForArticleImage:(BGMArticleImage *)articleImage loadIfNotCached:(BOOL)loadIfNotCached;

// file management
- (void)removeAllImages;

@end
