//
//  BGMArticleImageRefrence.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/31/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMCachedObject.h"

@interface BGMArticleImageRefrence : BGMCachedObject <NSCoding>

@property (nonatomic, assign) NSUInteger height;
@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, copy)   NSString *imageType;
@property (nonatomic, copy)   NSString *imageURL;

- (id)initWithXMLElement:(GDataXMLElement *)element;

@end
