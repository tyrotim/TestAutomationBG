//
//  BGMSectionManager.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BGMSection;

@interface BGMSectionManager : NSObject

+ (BGMSectionManager *)sharedInstance;
- (BGMSection *)sectionForID:(NSString *)identifier;
- (BGMSection *)myGlobeSection;

- (void)clearAllCachedSections;

@end
