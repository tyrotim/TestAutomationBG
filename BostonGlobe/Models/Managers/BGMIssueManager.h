//
//  BGMIssueManager.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BGMArticle, BGMSection;

@interface BGMIssueManager : NSObject

@property (nonatomic, strong) NSArray *issues;

+ (BGMIssueManager *)sharedInstance;

// Searching
- (BGMSection *)sectionForID:(NSString *)identifier;
- (BGMArticle *)articleForID:(NSString *)identifier;

// Issue List Management
- (void)initalizeIssuesFromDisk;
- (void)clearAllIssues;

// Issue Creation
- (void)addIssueWithDate:(NSDate *)date andURL:(NSURL *)assetURL;
+ (NSURL *)downloadURLForDate:(NSDate *)date;

@end
