//
//  BGMArticleImageRefrence.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/31/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMArticleImageRefrence.h"
#import "GDataXMLNode.h"

@implementation BGMArticleImageRefrence

- (id)initWithXMLElement:(GDataXMLElement *)element
{
    self = [super init];
    
    if (self) {
        for (GDataXMLElement *imageElement in element.attributes) {
            if ([imageElement.name isEqualToString:@"width"]) {
                self.width = imageElement.stringValue.intValue;
            }
            else if ([imageElement.name isEqualToString:@"height"]) {
                self.height = imageElement.stringValue.intValue;                
            }
            else if ([imageElement.name isEqualToString:@"type"]) {
                self.imageType = imageElement.stringValue;
            }
            else if ([imageElement.name isEqualToString:@"url"]) {
                self.imageURL = imageElement.stringValue;
            }
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:self.height forKey:@"height"];
    [encoder encodeInt:self.width forKey:@"width"];
    [encoder encodeObject:self.imageType forKey:@"imageType"];
    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.height = [decoder decodeIntForKey:@"height"];
    self.width = [decoder decodeIntForKey:@"width"];
    self.imageType = [decoder decodeObjectForKey:@"imageType"];
    self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
    return self;
}

@end
