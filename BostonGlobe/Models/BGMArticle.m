//
//  BGMArticle.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMArticle.h"
#import "BGMArticleAbstract.h"
#import "GDataXMLNode.h"

@implementation BGMArticle

- (id)initWithXMLElement:(GDataXMLElement *)element andArticleAbstract:(BGMArticleAbstract *)articleAbstract
{
    self = [super init];
    
    if (self) {
        
        self.articleAbstract = articleAbstract;
        
        GDataXMLElement *body = [element.children objectAtIndex:1];
        GDataXMLElement *bodyContent = [body.children objectAtIndex:1];
        GDataXMLElement *bodyBlock = [[bodyContent elementsForName:@"block"] objectAtIndex:0];
        
        // article paragraphs with xml tags left in place
        NSMutableArray *mutableParagrpahs = [NSMutableArray array];
        for (GDataXMLElement *XMLParagraph in [bodyBlock elementsForName:@"p"]) {
            [mutableParagrpahs addObject:XMLParagraph.XMLString];
        }
        self.paragraphs = [NSArray arrayWithArray:mutableParagrpahs];
    }
    
    return self;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.articleAbstract forKey:@"articleAbstract"];
    [encoder encodeObject:self.paragraphs forKey:@"paragraphs"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.articleAbstract = [decoder decodeObjectForKey:@"articleAbstract"];
    self.paragraphs = [decoder decodeObjectForKey:@"paragraphs"];
    return self;
}

@end
