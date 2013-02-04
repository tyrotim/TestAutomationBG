//
//  BGMCachedObject.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/21/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMCachedObject.h"

@implementation BGMCachedObject

#pragma mark - Caching

- (id)initWithCachedObjectPath:(NSString *)path
{
    self = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    if (self) {
         self.filePath = path;
    }
    
    return self;
}

- (BOOL)cacheToDirectory:(NSString *)path
{
    self.filePath = path;
    
    BOOL wasAddingSkipBackupAttributeToItemAtURLSuccessful = NO;
    
    BOOL wasCacheToDirectorySuccessful = [NSKeyedArchiver archiveRootObject:self toFile:self.filePath];
    
    NSURL *URL = [self fileURL];
    if (URL != nil) {
         wasAddingSkipBackupAttributeToItemAtURLSuccessful = [BGMCachedObject addSkipBackupAttributeToItemAtURL:URL];
    }
    
    return wasCacheToDirectorySuccessful;
}

- (NSURL *)fileURL
{
    NSString *URLString = [NSString stringWithFormat:@"file://%@", self.filePath] ;
    NSString *encodedURLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:encodedURLString];
    return URL;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                  forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
    return success;
}

@end
