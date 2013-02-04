//
//  BGDataParserTests.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/11/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGDataParserTests.h"

@implementation BGDataParserTests

#pragma mark - Tests

- (void)testSectionsWereCreated
{
    BGMIssue *issue = [[BGMIssueManager sharedInstance].issues objectAtIndex:0];
    
    NSUInteger sectionCount = issue.sectionAbstracts.count;
    
    BOOL sectionCountIsGreaterThanZero = NO;
    
    if (sectionCount > 0) {
        sectionCountIsGreaterThanZero = YES;
    }
    
    STAssertTrue(sectionCountIsGreaterThanZero, nil);
}

- (void)testSections
{
    BGMIssue *issue = [[BGMIssueManager sharedInstance].issues objectAtIndex:0];
    
    BOOL doesIssueHaveSections = NO;
    
    for (BGMSectionAbstract *sectionAbstract in issue.sectionAbstracts) {
        
        doesIssueHaveSections = YES;
        
        BGMSection *section = [[BGMSectionManager sharedInstance] sectionForID:sectionAbstract.identifier];
        
        for (BGMArticleAbstract *abstract in section.articleAbstracts) {
            STAssertNotNil(abstract.pubDate, @"pubDate nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.title, @"title nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.author, @"author nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.authorByTTL, @"authorByTTL nil for id = %@", abstract.identifier); 
            STAssertNotNil(abstract.articleDescription, @"articleDescription nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.kicker, @"kicker nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.printPubDate, @"printPubDate nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.articleURL, @"articleURL nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.shortURL, @"shortURL nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.firstparagraph, @"firstparagraph nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.articleImages, @"articleImages nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.sectionName, @"sectionName nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.sectionIdentifier, @"sectionIdentifier nil for id = %@", abstract.identifier);
            STAssertNotNil(abstract.identifier, @"identifier nil for id = %@", abstract.identifier);
            
            if (abstract.articleImages.count > 0) {
                for (BGMArticleImage *image in abstract.articleImages) {
                    //STAssertNotNil(image.imageCredit, @"image.imageCredit nil for id = %@", abstract.identifier); // sometimes empty
                    STAssertNotNil(image.imageCaption, @"imageCaption nil for id = %@", abstract.identifier);
                    STAssertNotNil(image.imageOrientation,  @"imageOrientation nil for id = %@", abstract.identifier);
                    STAssertNotNil(image.imageFileName, @"imageFileName nil for id = %@", abstract.identifier);
                    
                    STAssertNotNil(image.imageFilePath, @"imageFilePath nil for id = %@", abstract.identifier);
                    STAssertNotNil(image.imageURL, @"imageURL nil for id = %@", abstract.identifier);
                    //STAssertNotNil(image.height, @"height nil for id = %@", abstract.identifier);
                    //STAssertNotNil(image.width, @"width nil for id = %@", abstract.identifier);
                }
            }
        }
    }
    
    STAssertTrue(doesIssueHaveSections, nil);
}

- (void)testArticles
{
    BGMIssue *issue = [[BGMIssueManager sharedInstance].issues objectAtIndex:0];
    
    BOOL doesIssueHaveSections = NO;
    
    for (BGMSectionAbstract *sectionAbstract in issue.sectionAbstracts) {
        
        doesIssueHaveSections = YES;
        
        BGMSection *section = [[BGMSectionManager sharedInstance] sectionForID:sectionAbstract.identifier];
        
        for (BGMArticleAbstract *abstract in section.articleAbstracts) {
            BGMArticle *article = [[BGMArticleManager sharedInstance] articleForID:abstract.identifier];
            
            if (article != nil) {
                BOOL articleHasParagraphs = NO;
                
                if (article.paragraphs.count > 0) {
                    articleHasParagraphs = YES;
                }
                
                STAssertTrue(articleHasParagraphs, @"NO PARAGRAPHS FOR ARTILCE ID: %@", article.articleAbstract.identifier);
            }
            else {
                NSLog(@"NO ARTICLE FILE FOR ID: %@", abstract.identifier);
            }
        }
    }
    
    STAssertTrue(doesIssueHaveSections, nil);
}

- (void)testLoadIssuesFromDisk
{
    [BGMIssueManager sharedInstance].issues = [NSArray array];
    [[BGMIssueManager sharedInstance] initalizeIssuesFromDisk];
    
    BGMIssue *issue = [[BGMIssueManager sharedInstance].issues objectAtIndex:0];
    STAssertNotNil(issue, nil);
}

- (void)testAddSkipBackupAttribute
{
    BGMIssue *issue = [[BGMIssueManager sharedInstance].issues objectAtIndex:0];
    
    STAssertTrue([BGMCachedObject addSkipBackupAttributeToItemAtURL:[issue fileURL]], nil);
    
    BOOL doesIssueHaveSections = NO;
    
    for (BGMSectionAbstract *sectionAbstract in issue.sectionAbstracts) {
        
        doesIssueHaveSections = YES;
        
        BGMSection *section = [[BGMSectionManager sharedInstance] sectionForID:sectionAbstract.identifier];
        
        for (BGMArticleAbstract *abstract in section.articleAbstracts) {
            STAssertTrue([BGMCachedObject addSkipBackupAttributeToItemAtURL:[abstract fileURL]], nil);
            
            BGMArticle *article = [[BGMArticleManager sharedInstance] articleForID:abstract.identifier];
            if (article != nil) {
                STAssertTrue([BGMCachedObject addSkipBackupAttributeToItemAtURL:[article fileURL]], nil);
            }

        }
    }
    
    STAssertTrue(doesIssueHaveSections, nil);
}

- (void)testUseCorrectImageSizeForDevice
{
    BGMIssue *issue = [[BGMIssueManager sharedInstance].issues objectAtIndex:0];
    
    for (BGMSectionAbstract *sectionAbstract in issue.sectionAbstracts) {
        
        BGMSection *section = [[BGMSectionManager sharedInstance] sectionForID:sectionAbstract.identifier];
        
        for (BGMArticleAbstract *abstract in section.articleAbstracts) {
            
            if (abstract.articleImages.count > 0) {
                
                for (BGMArticleImage *image in abstract.articleImages) {
                    
                    NSString *URL = image.imageURL;
                    NSString *validURL = image.iPhone4Image.imageURL;
                    
                    if (image.iPhone5Image != nil) {
                        validURL = image.iPhone5Image.imageURL;
                    }

                    STAssertEqualObjects(URL, validURL, nil);
                }
            }
        }
    }
}

@end
