//
//  MobUZip.h
//  MobUZip
//
//  Created by Christian Grise on 12/12/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZipArchive.h"

@protocol MobUZipArchiveStatusDelegate;

typedef void (^MobUZipArchiveSuccessBlock)();
typedef void (^MobUZipArchiveFailureBlock)(NSError *error);

@interface MobUZipArchive : NSObject

@property (nonatomic, strong) NSString *path;

- (id)initWithPath:(NSString *)path;

- (void)unzipToPath:(NSString *)path
   withSuccessBlock:(MobUZipArchiveSuccessBlock)successBlock
       failureBlock:(MobUZipArchiveFailureBlock)failureBlock;

@end


@protocol MobUZipArchiveStatusDelegate <NSObject>

@end