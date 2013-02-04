//
//  NSError+MobUZipArchive.h
//  MobUZip
//
//  Created by Christian Grise on 12/13/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MobUZipArchive)

/* ~~~~~ Error Domain ~~~~~ */
/***/
+ (NSString *)mobUZipArchive_errorDomain;


/* ~~~~~ Error Codes ~~~~~ */
/***/
+ (NSInteger)mobUZipArchive_unzipFailedErrorCode;

+ (NSInteger)mobUZipArchive_openFileFailedErrorCode;

+ (NSInteger)mobUZipArchive_getFileInfoFailedErrorCode;

/* ~~~~~ Generated Errors ~~~~~ */
/***/
+ (NSError *)mobUZipArchive_errorForUnzipFailedError;

+ (NSError *)mobUZipArchive_errorForOpenFileFailedError;

+ (NSError *)mobUZipArchive_errorForGetFileInfoFailedError;

@end
