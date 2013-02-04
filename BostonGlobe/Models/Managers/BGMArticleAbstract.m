//
//  BGMArticleAbstract.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/11/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMArticleAbstract.h"
#import "BGMArticleImage.h"
#import "GDataXMLNode.h"

@implementation BGMArticleAbstract

- (id)initWithXMLElement:(GDataXMLElement *)element
{
    self = [super init];
    
    if (self) {
        
        GDataXMLElement *pubDate = [[element elementsForName:@"PubDate"] objectAtIndex:0];
        self.pubDate = [self dateFromString:pubDate.stringValue];
        
        GDataXMLElement *title = [[element elementsForName:@"Title"] objectAtIndex:0];
        self.title = title.stringValue;
        
        GDataXMLElement *author = [[element elementsForName:@"Author"] objectAtIndex:0];
        self.author = author.stringValue;
        
        GDataXMLElement *authorByTTL = [[element elementsForName:@"AuthorByTTL"] objectAtIndex:0];
        self.authorByTTL = authorByTTL.stringValue;
        
        GDataXMLElement *articleDescription = [[element elementsForName:@"Description"] objectAtIndex:0];
        self.articleDescription = articleDescription.stringValue;
        
        GDataXMLElement *identifier = [[element elementsForName:@"ArticleId"] objectAtIndex:0];
        self.identifier = identifier.stringValue;
        
        GDataXMLElement *kicker = [[element elementsForName:@"Kicker"] objectAtIndex:0];
        self.kicker = kicker.stringValue;
        
        GDataXMLElement *printPubDate = [[element elementsForName:@"PrintPubDate"] objectAtIndex:0];
        self.printPubDate = [self dateFromString:printPubDate.stringValue];
        
        GDataXMLElement *articleURL = [[element elementsForName:@"ArticleUrl"] objectAtIndex:0];
        self.articleURL = articleURL.stringValue;
        
        GDataXMLElement *firstparagraph = [[element elementsForName:@"FirstParagraph"] objectAtIndex:0];
        self.firstparagraph = firstparagraph.stringValue;
        
        GDataXMLElement *shortURL = [[element elementsForName:@"ShortUrl"] objectAtIndex:0];
        self.shortURL = shortURL.stringValue;
        
        GDataXMLElement *isLockedContent = [[element elementsForName:@"LockedContent"] objectAtIndex:0];
        self.isLockedContent = [isLockedContent.stringValue boolValue];
        
        GDataXMLElement *shouldDisplayAd = [[element elementsForName:@"DisplayAd"] objectAtIndex:0];
        self.shouldDisplayAd = [shouldDisplayAd.stringValue boolValue];
        
        GDataXMLElement *sectionName = [[element elementsForName:@"SectionName"] objectAtIndex:0];
        self.sectionName = sectionName.stringValue;
        
        GDataXMLElement *sectionIdentifier = [[element elementsForName:@"SectionId"] objectAtIndex:0];
        self.sectionIdentifier = sectionIdentifier.stringValue;
        
        GDataXMLElement *imageGroup = [element elementsForName:@"ImageGroup"][0];
        NSArray *images = [imageGroup elementsForName:@"ImageReference"];
        NSMutableArray *mutableImages = [NSMutableArray array];
        for (GDataXMLElement *image in images) {
            BGMArticleImage *articleImage = [[BGMArticleImage alloc] initWithXMLElement:image];
            [mutableImages addObject:articleImage];
        }
        self.articleImages = [NSArray arrayWithArray:mutableImages];
    }
    
    return self;
}

- (NSDate *)dateFromString:(NSString *)string;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE,dd MMM yyyy HH:mm:ss ZZZ"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.pubDate forKey:@"pubDate"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:self.authorByTTL forKey:@"authorByTTL"];
    [encoder encodeObject:self.articleDescription forKey:@"articleDescription"];
    [encoder encodeObject:self.kicker forKey:@"kicker"];
    [encoder encodeObject:self.printPubDate forKey:@"printPubDate"];
    [encoder encodeObject:self.articleURL forKey:@"articleURL"];
    [encoder encodeObject:self.firstparagraph forKey:@"firstparagraph"];
    [encoder encodeObject:self.articleImages forKey:@"articleImages"];
    [encoder encodeObject:self.shortURL forKey:@"shortURL"];
    [encoder encodeBool:self.isLockedContent forKey:@"isLockedContent"];
    [encoder encodeBool:self.shouldDisplayAd forKey:@"shouldDisplayAd"];
    [encoder encodeObject:self.sectionName forKey:@"sectionName"];
    [encoder encodeObject:self.sectionIdentifier forKey:@"sectionIdentifier"];
    [encoder encodeObject:self.identifier forKey:@"identifier"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.pubDate = [decoder decodeObjectForKey:@"pubDate"];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.author = [decoder decodeObjectForKey:@"author"];
    self.authorByTTL = [decoder decodeObjectForKey:@"authorByTTL"];
    self.articleDescription = [decoder decodeObjectForKey:@"articleDescription"];
    self.kicker = [decoder decodeObjectForKey:@"kicker"];
    self.printPubDate = [decoder decodeObjectForKey:@"printPubDate"];
    self.articleURL = [decoder decodeObjectForKey:@"articleURL"];
    self.firstparagraph = [decoder decodeObjectForKey:@"firstparagraph"];
    self.articleImages = [decoder decodeObjectForKey:@"articleImages"];
    self.shortURL = [decoder decodeObjectForKey:@"shortURL"];
    self.isLockedContent = [decoder decodeBoolForKey:@"isLockedContent"];
    self.shouldDisplayAd = [decoder decodeBoolForKey:@"shouldDisplayAd"];
    self.sectionName = [decoder decodeObjectForKey:@"sectionName"];
    self.sectionIdentifier = [decoder decodeObjectForKey:@"sectionIdentifier"];
    self.identifier = [decoder decodeObjectForKey:@"identifier"];
    return self;
}

@end
