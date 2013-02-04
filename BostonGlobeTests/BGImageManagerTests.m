//
//  BGImageManagerTests.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/3/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGImageManagerTests.h"

@interface BGImageManagerTests ()

@property (nonatomic, assign) BOOL imageDoneDownloadingNotificationReceived;
@property (nonatomic, strong) NSString *imagePath;

@end

@implementation BGImageManagerTests

#pragma mark - setUp / tearDown

- (void)setUp
{
    [super setUp];
    self.imageDoneDownloadingNotificationReceived = self.done = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDoneDownloading:) name:IMAGE_DONE_DOWNLOADING_NOTIFICATION object:nil];
}

- (void)tearDown
{
    [super tearDown];
}


#pragma mark - helpers

- (void)imageDoneDownloading:(NSNotification *)notificaiton
{
    self.imageDoneDownloadingNotificationReceived = YES;
    self.done = YES;
    
    BGMArticleImage *articleImage = notificaiton.object;
    self.imagePath = articleImage.imageFilePath;
}


#pragma mark - tests

- (void)testDownloadImageThenReadFromDisk
{
    NSString *imagePath = nil;
    BGMSection *newsSection = [self newsSection];
    BGMArticleImage *articleImageToTest = nil;
    
    for (BGMArticleAbstract *abstract in newsSection.articleAbstracts) {
        for (BGMArticleImage *articleImage in abstract.articleImages) {
            articleImageToTest = articleImage;
            break;
        }
    }
    
    STAssertNotNil(articleImageToTest, nil);
    
    if (articleImageToTest != nil) {
        //This proves it went to the server for the image becuase a notification was recived
        //only after downloading will the notification be recived
        imagePath = [[BGMImageManager sharedInstance] imagePathForArticleImage:articleImageToTest];
        STAssertFalse([articleImageToTest doesImageExistOnDisk], imagePath, nil);
        [self waitForCompletion:60.f];
        STAssertNotNil(self.imagePath, nil);
        
        //This proves that the same image was read from disk becuase the notification was never recivied
        self.imagePath = nil;
        self.imageDoneDownloadingNotificationReceived = NO;
        self.imagePath = [[BGMImageManager sharedInstance] imagePathForArticleImage:articleImageToTest];
        STAssertFalse(self.imageDoneDownloadingNotificationReceived, nil);
        STAssertNotNil(self.imagePath, nil);
    }
}

@end
