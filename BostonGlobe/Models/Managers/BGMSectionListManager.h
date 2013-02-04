//
//  BGMSectionListManager.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/16/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGMSectionListManager : NSObject

// These are hard coded sections from "SectionList.plist"
@property (nonatomic, copy) NSArray *sectionAbstracts;

+ (BGMSectionListManager *)sharedInstance;

- (NSArray *)myGlobeSectionList;

@end
