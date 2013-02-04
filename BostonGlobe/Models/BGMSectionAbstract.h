//
//  BGMSectionAbstract.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/13/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMCachedObject.h"

@interface BGMSectionAbstract : BGMCachedObject <NSCoding>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *articleAbstractIdentifiers;

- (id)initWithXMLElement:(GDataXMLElement *)element;
- (void)addArticleAbstractIdentifierToSection:(NSString *)articleAbstractIdentifier;

@end
