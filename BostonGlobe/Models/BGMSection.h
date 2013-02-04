//
//  BGMSection.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMCachedObject.h"

@interface BGMSection : BGMCachedObject <NSCoding>

@property (nonatomic, copy) NSArray *articleAbstracts;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;

- (void)addAbstractToSection:(BGMArticleAbstract *)abstract;

@end
