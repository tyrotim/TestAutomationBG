//
//  BGSectionManagerTests.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/22/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGSectionManagerTests.h"

@implementation BGSectionManagerTests

- (void)testMyGlobeSection
{    
    BGMSection *myGlobeSection = [[BGMSectionManager sharedInstance] sectionForID:MyGlobeSectionIdentifier];
    STAssertNotNil(myGlobeSection, nil);

    NSArray *myGlobeSectionList = [NSArray arrayWithArray:[[BGMSectionListManager sharedInstance] myGlobeSectionList]];
    NSInteger combinedArticlesCount = 0;
    for (BGMSectionAbstract *sectionAbstract in myGlobeSectionList) {
        BGMSection *section = [[BGMSectionManager sharedInstance] sectionForID:sectionAbstract.identifier];
        combinedArticlesCount += section.articleAbstracts.count;
    }
    
    NSInteger myGlobeSectionArticlesCount = myGlobeSection.articleAbstracts.count;
    STAssertTrue([self areIntsEqualIntA:myGlobeSectionArticlesCount IntB:combinedArticlesCount], nil);
}

@end
