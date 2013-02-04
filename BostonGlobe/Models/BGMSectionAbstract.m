//
//  BGMSectionAbstract.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/13/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMSectionAbstract.h"
#import "GDataXMLNode.h"

@implementation BGMSectionAbstract

#pragma mark - initWithXMLElement

- (id)initWithXMLElement:(GDataXMLElement *)element
{
    self = [super init];
    
    if (self) {
        GDataXMLElement *sectionName = [[element elementsForName:@"SectionName"] objectAtIndex:0];
        self.name = sectionName.stringValue;
        
        GDataXMLElement *sectionID = [[element elementsForName:@"SectionId"] objectAtIndex:0];
        self.identifier = sectionID.stringValue;
        
        NSArray *articles = [element elementsForName:@"ArticleId"];
        for (GDataXMLElement *articleIDElement in articles) {
            [self addArticleAbstractIdentifierToSection:articleIDElement.stringValue];
        }
    }
    
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.identifier forKey:@"identifier"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.articleAbstractIdentifiers forKey:@"articleAbstractIdentifiers"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.identifier = [decoder decodeObjectForKey:@"identifier"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.articleAbstractIdentifiers = [decoder decodeObjectForKey:@"articleAbstractIdentifiers"];
    return self;
}

- (void)addArticleAbstractIdentifierToSection:(NSString *)articleAbstractIdentifier
{
    NSMutableArray *mutableArticleAbstractIdentifiers = [NSMutableArray arrayWithArray:self.articleAbstractIdentifiers];
    [mutableArticleAbstractIdentifiers addObject:articleAbstractIdentifier];
    self.articleAbstractIdentifiers = [NSArray arrayWithArray:mutableArticleAbstractIdentifiers];
}

@end
