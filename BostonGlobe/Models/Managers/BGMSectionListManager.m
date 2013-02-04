//
//  BGMSectionListManager.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/16/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMSectionListManager.h"
#import "BGMSectionAbstract.h"

static BGMSectionListManager *sharedInstance = nil;

@implementation BGMSectionListManager

+ (BGMSectionListManager *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[BGMSectionListManager alloc] init];
        [sharedInstance initializeSections];
        [sharedInstance initalizeMyGlobeSectionToDefaultSetting];
    }
    
    return sharedInstance;
}

- (void)initializeSections
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"SectionList" withExtension:@"plist"];
    NSDictionary *plistRootDict = [[NSDictionary alloc] initWithContentsOfURL:fileURL];
    NSDictionary *plistSectionsDict = [plistRootDict objectForKey:@"Sections"];
 
    NSMutableArray *mutableSectionAbstracts = [NSMutableArray array];
    
    for (int i = 0; i < plistSectionsDict.count; i++) {
        NSDictionary *dictionary = [plistSectionsDict objectForKey:[NSString stringWithFormat:@"Section%i", i+1]];
        
        BGMSectionAbstract *sectionAbstract = [[BGMSectionAbstract alloc] init];
        sectionAbstract.name = [dictionary objectForKey:@"Name"];
        sectionAbstract.identifier = [dictionary objectForKey:@"Identifier"];
        
        [mutableSectionAbstracts addObject:sectionAbstract];
    }
    
    self.sectionAbstracts = [NSArray arrayWithArray:mutableSectionAbstracts];
}

- (void)initalizeMyGlobeSectionToDefaultSetting
{
    NSUbiquitousKeyValueStore *keyStore = [NSUbiquitousKeyValueStore defaultStore];
    
    if (![keyStore dataForKey:BGMyGlobeSectionList]) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.sectionAbstracts];
        [keyStore setData:data forKey:BGMyGlobeSectionList];
        [keyStore synchronize];
    }
    
    if (![keyStore arrayForKey:BGMyGlobeSectionListEditableCell]) {
        NSMutableArray *canEditTheOriginalCell = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < self.sectionAbstracts.count; i++) {
            if (i == 0 || i == 3 || i == 4) {
                [canEditTheOriginalCell addObject:[NSNumber numberWithInt:1]];
            } else {
                [canEditTheOriginalCell addObject:[NSNumber numberWithInt:0]];
            }
        }
        
        [keyStore setArray:canEditTheOriginalCell forKey:BGMyGlobeSectionListEditableCell];
        [keyStore synchronize];
    }
}

- (NSArray *)myGlobeSectionList {
    
    NSUbiquitousKeyValueStore *keyStore = [NSUbiquitousKeyValueStore defaultStore];
    NSMutableArray *reOrderedSections = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray *canEditReOrderedSections = [NSMutableArray arrayWithArray:[keyStore arrayForKey:BGMyGlobeSectionListEditableCell]];
    
    NSData *data = [keyStore dataForKey:BGMyGlobeSectionList];
    NSArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    for (int x = 0; x < [canEditReOrderedSections count]; x++) {
        if ([canEditReOrderedSections objectAtIndex:x] == [NSNumber numberWithInt:1]) {
            [reOrderedSections addObject:[dataArray objectAtIndex:x]];
        }
    }
    
    NSArray *myGlobeSectionList = [NSArray arrayWithArray:reOrderedSections];
    return myGlobeSectionList;
}

@end
