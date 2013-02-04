//
//  BGMArticleImage.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/12/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMArticleImage.h"
#import "BGMArticleImageRefrence.h"
#import "BGMImageManager.h"
#import "GDataXMLNode.h"

@interface BGMArticleImage ()

@property (nonatomic, strong, readwrite) BGMArticleImageRefrence *iPhone4Image;
@property (nonatomic, strong, readwrite) BGMArticleImageRefrence *iPhone5Image;

@end

@implementation BGMArticleImage

#pragma mark - initWithXMLElement and initalizeImageRefrences

- (id)initWithXMLElement:(GDataXMLElement *)element
{
    self = [super init];
    
    if (self) {
        
        [self initalizeImageRefrencesWithXMLElement:[element elementsForName:@"Images"][0]];

        GDataXMLElement *imageCredit = [[element elementsForName:@"ImageCredit"] objectAtIndex:0];
        self.imageCredit = imageCredit.stringValue;
        
        GDataXMLElement *imageCaption = [[element elementsForName:@"ImageCaption"] objectAtIndex:0];
        self.imageCaption = imageCaption.stringValue;
        
        GDataXMLElement *imageOrientation = [[element elementsForName:@"ImageOrientation"] objectAtIndex:0];
        self.imageOrientation = imageOrientation.stringValue;
        
        NSArray *pathComponents = [self.imageURL componentsSeparatedByString:@"/"];
        self.imageFileName = [pathComponents lastObject];
    }
    
    return self;
}

- (void)initalizeImageRefrencesWithXMLElement:(GDataXMLElement *)element
{
    NSArray *images = [element elementsForName:@"Image"];
    
    BGMArticleImageRefrence *image1 = nil;
    BGMArticleImageRefrence *image2 = nil;
    
    if (images.count == 2) {
        image1 = [[BGMArticleImageRefrence alloc] initWithXMLElement:images[0]];
        image2 = [[BGMArticleImageRefrence alloc] initWithXMLElement:images[1]];
    }
    else if (images.count == 1) {
        image1 = [[BGMArticleImageRefrence alloc] initWithXMLElement:images[0]];
    }
    
    if ([image1.imageType isEqualToString:@"iphone4"]) {
        self.iPhone4Image = image1;
        self.iPhone5Image = image2;
    }
    else if ([image1.imageType isEqualToString:@"iphone5"]) {
        self.iPhone4Image = image2;
        self.iPhone5Image = image1;
    }
}


#pragma mark - readonly properties

- (BOOL)doesImageExistOnDisk
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self.imageFilePath];
}

- (NSString *)imageFilePath
{
    NSString *imageFilePath = [[BGMImageManager imagesFilePath] stringByAppendingPathComponent:self.imageFileName];
    return imageFilePath;
}

- (NSString *)imageURL
{
    NSString *imageURL = self.iPhone4Image.imageURL;
    
    if ([BGMArticleImage isCurrentDeviceiPhone5] && self.iPhone5Image != nil) {
        imageURL = self.iPhone5Image.imageURL;
    }
    
    return imageURL;
}

- (NSUInteger)height
{
    NSUInteger height = self.iPhone4Image.height;
    
    if ([BGMArticleImage isCurrentDeviceiPhone5] && self.iPhone5Image != nil) {
        height = self.iPhone5Image.height;
    }
    
    return height;
}

- (NSUInteger)width
{
    NSUInteger width = self.iPhone4Image.width;
    
    if ([BGMArticleImage isCurrentDeviceiPhone5] && self.iPhone5Image != nil) {
        width = self.iPhone5Image.width;
    }
    
    return width;
}

+ (BOOL)isCurrentDeviceiPhone5
{
    BOOL isCurrentDeviceiPhone5 = NO;
    
    UIScreen *mainScreen = [UIScreen mainScreen];
    
    if (mainScreen.bounds.size.height == 1136.0) {
        isCurrentDeviceiPhone5 = YES;
    }
    
    return isCurrentDeviceiPhone5;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.imageCredit forKey:@"imageCredit"];
    [encoder encodeObject:self.imageCaption forKey:@"imageCaption"];
    [encoder encodeObject:self.imageOrientation forKey:@"imageOrientation"];
    
    [encoder encodeObject:self.iPhone4Image forKey:@"iPhone4Image"];
    [encoder encodeObject:self.iPhone5Image forKey:@"iPhone5Image"];
    
    [encoder encodeObject:self.imageFileName forKey:@"imageFileName"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.imageCredit = [decoder decodeObjectForKey:@"imageCredit"];
    self.imageCaption = [decoder decodeObjectForKey:@"imageCaption"];
    self.imageOrientation = [decoder decodeObjectForKey:@"imageOrientation"];
    
    self.iPhone4Image = [decoder decodeObjectForKey:@"iPhone4Image"];
    self.iPhone5Image = [decoder decodeObjectForKey:@"iPhone5Image"];
    
    self.imageFileName = [decoder decodeObjectForKey:@"imageFileName"];
    return self;
}

@end
