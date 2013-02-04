//
//  BGMIssue.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGMCachedObject.h"

@interface BGMIssue : BGMCachedObject <NSCoding>

@property (nonatomic, copy) NSArray *sectionAbstracts; //This is the index file
@property (nonatomic, strong, readonly) NSString *issuePath;
@property (nonatomic, strong, readonly) NSDate *date;

- (id)initWithIssuePath:(NSString *)issuePath andDate:(NSDate *)date;

@end
