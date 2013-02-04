//
//  BGMIssue.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMIssue.h"
#import "BGMSection.h"
#import "BGMArticle.h"
#import "BGMArticleAbstract.h"
#import "BGMSectionAbstract.h"
#import "GDataXMLNode.h"

@interface BGMIssue ()

@property (nonatomic, strong, readwrite) NSString *issuePath;
@property (nonatomic, strong, readwrite) NSDate *date;

@end

@implementation BGMIssue

- (id)initWithIssuePath:(NSString *)issuePath andDate:(NSDate *)date
{
    self = [super init];
    
    if (self) {
        self.issuePath = issuePath;
        self.date = date;        
        [self buildIssueFromXML];
    }
    
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.sectionAbstracts forKey:@"sectionAbstracts"];
    [encoder encodeObject:self.issuePath forKey:@"issuePath"];
    [encoder encodeObject:self.date forKey:@"date"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.sectionAbstracts = [decoder decodeObjectForKey:@"sectionAbstracts"];
    self.issuePath = [decoder decodeObjectForKey:@"issuePath"];
    self.date = [decoder decodeObjectForKey:@"date"];
    return self;
}

#pragma mark - helpers

- (NSString *)stringFromDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter stringFromDate:self.date];
}

#pragma mark - Load Issue

- (void)buildIssueFromXML
{
    NSError *error = nil;
    NSString *indexFilePath = [self.issuePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/index.xml", [self stringFromDate]]];
    
    if (indexFilePath != nil) {
        NSString *indexString = [[NSString alloc] initWithContentsOfFile:indexFilePath encoding:NSUTF8StringEncoding error:&error];
        GDataXMLDocument *indexDocument = [[GDataXMLDocument alloc] initWithXMLString:indexString options:0 error:&error];
        
        if (error == nil) {
            NSArray *sections = [[indexDocument rootElement] elementsForName:@"Section"];
            
            //Create the Folders
            [self createDirectoryWithName:[NSString stringWithFormat:@"%@/", ArticleAbstractsFilePath] atPath:self.issuePath];
            [self createDirectoryWithName:[NSString stringWithFormat:@"%@/", ArticlesFilePath] atPath:self.issuePath];
            
            NSMutableArray *mutableSectionAbstracts = [NSMutableArray array];
            for (GDataXMLElement *element in sections) {
                BGMSectionAbstract *sectionAbstract = [[BGMSectionAbstract alloc] initWithXMLElement:element];
                [mutableSectionAbstracts addObject:sectionAbstract];
                
                for (NSString *identifier in sectionAbstract.articleAbstractIdentifiers) {
                    
                    //first create the article abstract
                    BGMArticleAbstract *articleAbstract = nil;
                    NSString *articleAbstractFilePath = [self.issuePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@_abstract.xml", [self stringFromDate], ArticleAbstractsFilePath, identifier]];
                    NSString *articleAbstractXMLString = [[NSString alloc] initWithContentsOfFile:articleAbstractFilePath encoding:NSUTF8StringEncoding error:&error];
                    
                    if (articleAbstractXMLString != nil) {
                        GDataXMLDocument *articleAbstractXMLDocument = [[GDataXMLDocument alloc] initWithXMLString:articleAbstractXMLString options:0 error:&error];
                        
                        if (error == nil) {
                            articleAbstract = [[BGMArticleAbstract alloc] initWithXMLElement:[articleAbstractXMLDocument rootElement]];
                            NSString *articleAbstractCacheFilePath = [self.issuePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", ArticleAbstractsFilePath, identifier]];
                            [articleAbstract cacheToDirectory:articleAbstractCacheFilePath];
                        }
                        
                        //next create the articles
                        NSString *articleFilePath = [self.issuePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/%@_article.xml", [self stringFromDate], ArticlesFilePath, identifier]];
                        NSString *articleXMLString = [[NSString alloc] initWithContentsOfFile:articleFilePath encoding:NSUTF8StringEncoding error:&error];
                        if (articleXMLString != nil) {
                            GDataXMLDocument *articleXMLDocument = [[GDataXMLDocument alloc] initWithXMLString:articleXMLString options:0 error:&error];
                            
                            if (error == nil) {
                                BGMArticle *article = [[BGMArticle alloc] initWithXMLElement:[articleXMLDocument rootElement] andArticleAbstract:articleAbstract];
                                NSString *articleCacheFilePath = [self.issuePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", ArticlesFilePath, identifier]];
                                [article cacheToDirectory:articleCacheFilePath];
                            }
                        }
                    }
                }
            }
            self.sectionAbstracts = [NSMutableArray arrayWithArray:mutableSectionAbstracts];
            
            // Cache the Issue
            [self cacheToDirectory:[self.issuePath stringByAppendingPathComponent:ISSUE]];
            
            //Remove the bundle
            [[NSFileManager defaultManager] removeItemAtPath:[self.issuePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [self stringFromDate]]] error:&error];
        }
        else {
            NSLog(@"error = %@", error.localizedDescription);
        }
    }
}

- (BOOL)createDirectoryWithName:(NSString *)newDirectoryName atPath:(NSString *)path
{
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:[path stringByAppendingPathComponent:newDirectoryName]
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&error];
    
    return success;
}

@end

