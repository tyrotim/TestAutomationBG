//
//  BGBaseTestClass.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/3/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <NewsstandKit/NewsstandKit.h>
#import "BGMIssue.h"
#import "BGMIssueManager.h"
#import "BGMSection.h"
#import "BGMSectionAbstract.h"
#import "BGMArticleAbstract.h"
#import "BGMArticleImage.h"
#import "BGMSectionManager.h"
#import "BGMArticleManager.h"
#import "BGMArticle.h"
#import "BGMSGetImageNetworkCall.h"
#import "BGMImageManager.h"
#import "BGMSectionListManager.h"
#import "BGMArticleImageRefrence.h"
#import "objc/runtime.h"

@interface BGBaseTestClass : SenTestCase

@property (nonatomic, assign) BOOL done;

- (void)setDoneFlagToYes;
- (BOOL)areIntsEqualIntA:(NSInteger)a IntB:(NSInteger)b;
- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs;
- (BGMSection *)newsSection;

@end
