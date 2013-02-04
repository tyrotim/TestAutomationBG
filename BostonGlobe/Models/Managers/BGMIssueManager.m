//
//  BGMIssueManager.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMIssueManager.h"
#import "BGMSection.h"
#import "BGMArticle.h"
#import "BGMIssue.h"
#import "BGMSectionAbstract.h"
#import "BGMArticleAbstract.h"
#import <MobUZip/MobUZipArchive.h>
#import <MobUZip/NSError+MobUZipArchive.h>

@interface BGMIssueManager () <NSURLConnectionDownloadDelegate>

@end

static BGMIssueManager *sharedInstance = nil;

@implementation BGMIssueManager

#pragma mark - init and initalize

- (id)init
{
    self = [super init];
    
    if (self) {

    }
    
    return self;
}

- (void)initalizeIssuesFromDisk
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *contentsOfDocumentDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDirectory error:nil];
    
    // load the issues
    NSMutableArray *mutableIssues = [NSMutableArray array];
    for (NSString *path in contentsOfDocumentDirectory) {
        
        if ([BGMIssueManager isValidIssuePath:path]) {
            NSString *filePath = [documentDirectory stringByAppendingPathComponent:[path stringByAppendingPathComponent:@"Issue"]];
            BGMIssue *issue = [[BGMIssue alloc] initWithCachedObjectPath:filePath];
            
            if (issue != nil) {
                [mutableIssues addObject:issue];
            }
        }
    }
    
    self.issues = [NSArray arrayWithArray:mutableIssues];
}


#pragma mark - sharedInstance

+ (BGMIssueManager *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[BGMIssueManager alloc] init];
    }
    
    return sharedInstance;
}


#pragma mark - Get sections

- (BGMSection *)sectionForID:(NSString *)identifier
{
    BGMIssue *issue = [self.issues objectAtIndex:0];
   
    BGMSection *section = nil;
    BGMSectionAbstract *sectionAbstract = [self sectionAbstractForIdentifier:identifier fromIssue:issue];
    
    if (sectionAbstract != nil) {
        section = [[BGMSection alloc] init];
        section.identifier = sectionAbstract.identifier;
        section.name = sectionAbstract.name;
        
        for (NSString *articleAbstractIdentifier in sectionAbstract.articleAbstractIdentifiers) {
            NSString *articleAbstractFilePath = [issue.issuePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", ArticleAbstractsFilePath, articleAbstractIdentifier]];
            BGMArticleAbstract *articleAbstract = [[BGMArticleAbstract alloc] initWithCachedObjectPath:articleAbstractFilePath];
           
            if (articleAbstract != nil) {
                [section addAbstractToSection:articleAbstract];
            }
        }
    }
    
    return section;
}

- (BGMSectionAbstract *)sectionAbstractForIdentifier:(NSString *)identifier fromIssue:(BGMIssue *)issue
{
    BGMSectionAbstract *sectionAbstractToReturn = nil;
    
    for (BGMSectionAbstract *sectionAbstract in issue.sectionAbstracts) {
        if ([sectionAbstract.identifier isEqualToString:identifier]) {
            sectionAbstractToReturn = sectionAbstract;
            break;
        }
    }
    
    return sectionAbstractToReturn;
}


#pragma mark - Get articles

- (BGMArticle *)articleForID:(NSString *)identifier
{
    BGMIssue *issue = [self.issues objectAtIndex:0];
    
    NSString *articleFilePath = [issue.issuePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", ArticlesFilePath, identifier]];
    
    BGMArticle *article = [[BGMArticle alloc] initWithCachedObjectPath:articleFilePath];
    
    return article;
}


#pragma mark - Download assets for an issue

- (void)addIssueWithDate:(NSDate *)date andURL:(NSURL *)assetURL
{
    NKIssue *issue = [[NKLibrary sharedLibrary] addIssueWithName:@"tempIssue" date:date];
    NSURLRequest *request = [NSURLRequest requestWithURL:assetURL];
    NKAssetDownload *assetDownload = [issue addAssetWithRequest:request];
    
    if (assetDownload != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ISSUE_BEGAN_DOWNLOADING_NOTIFICATION object:nil];
        [assetDownload downloadWithDelegate:self];
    }
}


#pragma mark - NSURLConnectionDownloadDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection error = %@", error.localizedDescription);
    [[NSNotificationCenter defaultCenter] postNotificationName:ISSUE_FAILED_DOWNLOADING_NOTIFICATION object:nil];
}

- (void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    
}

- (void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long) expectedTotalBytes
{
    
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ISSUE_DONE_DOWNLOADING_NOTIFICATION object:nil];
    
    NKIssue *nkissue = connection.newsstandAssetDownload.issue;
    NSString *issuePath = [BGMIssueManager issuePathForDate:nkissue.date];
    NSString *dataPath = [destinationURL path];
    
    dispatch_async(dispatch_queue_create("unzip", NULL), ^(void){
        MobUZipArchive *zipArchive = [[MobUZipArchive alloc] initWithPath:dataPath];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ISSUE_BEGAN_UNZIPPING_NOTIFICATION object:nil];
        
        [zipArchive unzipToPath:issuePath withSuccessBlock:^(void){
            BGMIssue *issue = [[BGMIssue alloc] initWithIssuePath:issuePath andDate:nkissue.date];
            NSMutableArray *mutableIssues = [NSMutableArray arrayWithArray:self.issues];
            [mutableIssues addObject:issue];
            self.issues = [NSArray arrayWithArray:mutableIssues];
            [[NKLibrary sharedLibrary] removeIssue:nkissue];
            
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ISSUE_DONE_UNZIPPING_NOTIFICATION object:nil];
            });
        }
        failureBlock:^(NSError *error){
           NSLog(@"unzip error = %@", error.localizedDescription);
           dispatch_sync(dispatch_get_main_queue(), ^(void) {
               [[NSNotificationCenter defaultCenter] postNotificationName:ISSUE_FAILED_UNZIPPING_NOTIFICATION object:nil];
           });
       }];
        
        // Remove the downloaded zip files
        [[NSFileManager defaultManager] removeItemAtPath:dataPath error:nil];
    });
}


#pragma mark - Helpers

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSURL *)downloadURLForDate:(NSDate *)date
{
    NSString *dateString = [BGMIssueManager stringFromDate:date];
    NSString *downloadURLString = [NSString stringWithFormat:@"http://www.boston.com/partners/greader/data/%@/%@_Data.zip", dateString, dateString];
    NSURL *downloadURL = [NSURL URLWithString:downloadURLString];
    return downloadURL;
}

+ (NSString *)issuePathForDate:(NSDate *)date
{
    NSString *dateString = [BGMIssueManager stringFromDate:date];
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *issuePath = [documentDirectory stringByAppendingPathComponent:dateString];    
    return issuePath;
}

+ (BOOL)isValidIssuePath:(NSString *)path
{
    BOOL isValidIssuePath = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateFormatter dateFromString:path];
    
    if (date) {
        isValidIssuePath = YES;
    }
    
    return isValidIssuePath;
}

- (void)clearAllIssues
{
    for (NKIssue *issue in [NKLibrary sharedLibrary].issues) {
        [[NKLibrary sharedLibrary] removeIssue:issue];
    }
    
    [BGMIssueManager sharedInstance].issues = [NSArray array];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *contentsOfDocumentDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentDirectory error:nil];
    for (NSString *path in contentsOfDocumentDirectory) {
        if ([BGMIssueManager isValidIssuePath:path]) {
            NSString *filePath = [documentDirectory stringByAppendingPathComponent:path];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}

@end
