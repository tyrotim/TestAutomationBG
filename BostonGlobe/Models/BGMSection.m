//
//  BGMSection.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMSection.h"
#import "GDataXMLNode.h"

@implementation BGMSection

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.articleAbstracts forKey:@"articleAbstracts"];
    [encoder encodeObject:self.identifier forKey:@"identifier"];
    [encoder encodeObject:self.name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.articleAbstracts = [decoder decodeObjectForKey:@"articleAbstracts"];
    self.identifier = [decoder decodeObjectForKey:@"identifier"];
    self.name = [decoder decodeObjectForKey:@"name"];
    return self;
}

- (void)addAbstractToSection:(BGMArticleAbstract *)abstract
{
    NSMutableArray *mutableAbstracts = [NSMutableArray arrayWithArray:self.articleAbstracts];
    [mutableAbstracts addObject:abstract];
    self.articleAbstracts = [NSArray arrayWithArray:mutableAbstracts];
}

@end
