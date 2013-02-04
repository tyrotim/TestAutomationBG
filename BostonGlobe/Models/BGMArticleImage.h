//
//  BGMArticleImage.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/12/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMCachedObject.h"
@class BGMArticleImageRefrence;

@interface BGMArticleImage : BGMCachedObject <NSCoding>

@property (nonatomic, copy) NSString *imageCredit;
@property (nonatomic, copy) NSString *imageCaption;
@property (nonatomic, copy) NSString *imageOrientation;
@property (nonatomic, copy) NSString *imageFileName;

@property (nonatomic, strong, readonly) BGMArticleImageRefrence *iPhone4Image;
@property (nonatomic, strong, readonly) BGMArticleImageRefrence *iPhone5Image;

- (id)initWithXMLElement:(GDataXMLElement *)element;

- (BOOL)doesImageExistOnDisk;
- (NSString *)imageFilePath;
- (NSString *)imageURL;
- (NSUInteger)height;
- (NSUInteger)width;

@end
