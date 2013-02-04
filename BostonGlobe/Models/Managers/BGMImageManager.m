//
//  BGMImageManager.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/3/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMImageManager.h"
#import "BGMArticleImage.h"
#import "BGMSGetImageNetworkCall.h"

@interface BGMImageManager ()

@property (nonatomic, strong) NSMutableArray *activeDownloads;

@end

static BGMImageManager *sharedInstance = nil;

@implementation BGMImageManager

#pragma mark - sharedInstance

+ (BGMImageManager *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[BGMImageManager alloc] init];
        sharedInstance.activeDownloads = [NSMutableArray array];
    }
    
    return sharedInstance;
}


#pragma mark - return image file path

- (NSString *)imagePathForArticleImage:(BGMArticleImage *)articleImage
{
    return [self imagePathForArticleImage:articleImage loadIfNotCached:YES];
}

- (NSString *)imagePathForArticleImage:(BGMArticleImage *)articleImage loadIfNotCached:(BOOL)loadIfNotCached;
{
    [[BGMImageManager sharedInstance] createImagesFolderIfNotCreated];
    
    NSString *imagePath = nil;
    
    if ([self shouldProceedWithDownloadForArticleImage:articleImage]) {
        
        if (![articleImage doesImageExistOnDisk] && loadIfNotCached) {
            
            BGMSGetImageNetworkCall *call = [[BGMSGetImageNetworkCall alloc] initWithArticleImage:articleImage];
            [self addArticleImageToActiveDownloads:call.articleImage];
            
            [call executeAsyncWithSuccessBlock:^(void){
                
                [self removeArticleImageFromActiveDownloads:call.articleImage];
                [call.responseData writeToFile:[call.articleImage imageFilePath] atomically:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:IMAGE_DONE_DOWNLOADING_NOTIFICATION object:call.articleImage];
                
            } failureBlock:^(NSError *error){
                NSLog(@"image failed to download error = %@", error.localizedDescription);
            }];
        }
        else {
            imagePath = [articleImage imageFilePath];
        }
    }
    
    return imagePath;
}


#pragma mark - download helpers

- (BOOL)shouldProceedWithDownloadForArticleImage:(BGMArticleImage *)articleImage
{
    BOOL shouldProceedWithDownloadForArticleImage = YES;
    
    for (BGMArticleImage *image in self.activeDownloads) {
        if ([image.imageURL isEqualToString:articleImage.imageURL]) {
            shouldProceedWithDownloadForArticleImage = NO;
            break;
        }
    }
    
    return shouldProceedWithDownloadForArticleImage;
}

- (void)addArticleImageToActiveDownloads:(BGMArticleImage *)articleImage
{
    [self.activeDownloads addObject:articleImage];
}

- (void)removeArticleImageFromActiveDownloads:(BGMArticleImage *)articleImage
{
    NSMutableArray *objectsToRemove = [NSMutableArray array];
    
    for (BGMArticleImage *image in self.activeDownloads) {
        if ([image.imageURL isEqualToString:articleImage.imageURL]) {
            [objectsToRemove addObject:image];
        }
    }
    
    [self.activeDownloads removeObjectsInArray:objectsToRemove];
}


#pragma mark - file management

+ (NSString *)imagesFilePath
{
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imagesFilePath = [cachesDirectory stringByAppendingPathComponent:ImagesFilePath];    
    return imagesFilePath;
}

- (void)createImagesFolderIfNotCreated
{
    BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:[BGMImageManager imagesFilePath]];
    
    if (!fileExistsAtPath) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:[BGMImageManager imagesFilePath]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
}

- (void)removeAllImages
{
    NSString *imagesFilePath = [BGMImageManager imagesFilePath];
    [[NSFileManager defaultManager] removeItemAtPath:imagesFilePath error:nil];
}


@end
