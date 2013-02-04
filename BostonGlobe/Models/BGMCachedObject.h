//
//  BGMCachedObject.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/21/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GDataXMLElement, BGMArticleImage, BGMArticleAbstract;

@interface BGMCachedObject : NSObject

@property (nonatomic, copy) NSString *filePath;

- (id)initWithCachedObjectPath:(NSString *)path;

- (BOOL)cacheToDirectory:(NSString *)path;

- (NSURL *)fileURL;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
