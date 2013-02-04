//
//  BGMSectionManager.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMSectionManager.h"
#import "BGMSection.h"
#import "BGMRefreshContentManager.h"
#import "BGMIssueManager.h"
#import "BGMSectionAbstract.h"
#import "BGMSectionListManager.h"

@interface BGMSectionManager ()

@property (nonatomic, copy) NSArray *sections;

@end

static BGMSectionManager *sharedInstance = nil;

@implementation BGMSectionManager

#pragma mark - sharedInstance

+ (BGMSectionManager *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[BGMSectionManager alloc] init];
    }
    
    return sharedInstance;
}


#pragma mark - Get sections locally

- (BGMSection *)sectionForID:(NSString *)identifier
{
    BGMSection *sectionToReturn = nil;
    
    if ([identifier isEqualToString:MyGlobeSectionIdentifier]) {
        sectionToReturn = [self myGlobeSection];
    }
    else {
        
        for (BGMSection *section in self.sections) {
            if ([section.identifier isEqualToString:identifier]) {
                sectionToReturn = section;
                break;
            }
        }
        
        sectionToReturn = [[BGMRefreshContentManager sharedInstance] sectionForID:identifier];
        if (sectionToReturn == nil) {
            sectionToReturn = [[BGMIssueManager sharedInstance] sectionForID:identifier];
        }
        
        [self addSection:sectionToReturn];
    }
    
    return sectionToReturn;
}

- (void)addSection:(BGMSection *)section
{
    if (section != nil) {
        NSMutableArray *mutableSections = [NSMutableArray arrayWithArray:self.sections];
        [mutableSections addObject:section];
        self.sections = [NSArray arrayWithArray:mutableSections];
    }
}

- (void)clearAllCachedSections
{
    self.sections = [NSArray array];
}

- (BGMSection *)myGlobeSection
{
    BGMSection *myGlobeSection = [[BGMSection alloc] init];
    myGlobeSection.name = MyGlobeSectionName;
    myGlobeSection.identifier = MyGlobeSectionIdentifier;
    
    NSArray *myGlobeSectionList = [NSArray arrayWithArray:[[BGMSectionListManager sharedInstance] myGlobeSectionList]];
    for (BGMSectionAbstract *sectionAbstract in myGlobeSectionList) {
        BGMSection *sectionInMyGlobe = [[BGMSectionManager sharedInstance] sectionForID:sectionAbstract.identifier];
        [BGMSectionManager addArticleAbstractsToSection:myGlobeSection fromSection:sectionInMyGlobe];
    }
    
    return myGlobeSection;
}

+ (void)addArticleAbstractsToSection:(BGMSection *)toSection fromSection:(BGMSection *)fromSection
{
    for (BGMArticleAbstract *articleAbstract in fromSection.articleAbstracts) {
        [toSection addAbstractToSection:articleAbstract];
    }
}

@end
