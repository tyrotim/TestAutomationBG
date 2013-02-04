//
//  BGBaseTestClass.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/3/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGBaseTestClass.h"

@interface BGBaseTestClass ()

@property (nonatomic, strong) NSString *bundleDataPath;
@property (nonatomic, strong) NSString *bundleDataPathCopied;

@end

#define dateString @"20130201"

@implementation BGBaseTestClass

- (void)setUp
{
    [super setUp];
    
    // Set up enviroment
    self.done = NO;
    [[BGMIssueManager sharedInstance] clearAllIssues];
    [[BGMImageManager sharedInstance] removeAllImages];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDoneFlagToYes) name:ISSUE_DONE_UNZIPPING_NOTIFICATION object:nil];
    
    // switch the implementations of the bounds call for uiscreen, so we can unit test agnist the
    // article images returning the correct image for the iphone 5
    [self swizzel];
    
    // Copy bundle so it is avalibile for all unit tests
    self.bundleDataPath = [[NSBundle bundleForClass:[self class]] pathForResource:[NSString stringWithFormat:@"%@_Data", dateString] ofType:@"zip"];
    self.bundleDataPathCopied = [self.bundleDataPath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@_Data.zip", dateString] withString:[NSString stringWithFormat:@"%@_Data_COPY.zip", dateString]];
    [[NSFileManager defaultManager] copyItemAtPath:self.bundleDataPath toPath:self.bundleDataPathCopied error:nil];

    // Download the issue and wait for it to parse
    [[BGMIssueManager sharedInstance] addIssueWithDate:[self date] andURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@", self.bundleDataPathCopied]]];
    [self waitForCompletion:60.0];
}

- (void)tearDown
{
    // switch implementations back
    [self swizzel];
    
    // remove the duped bundle
    [[NSFileManager defaultManager] removeItemAtPath:self.bundleDataPathCopied error:nil];
    
    // 
    [super tearDown];
}


#pragma mark - swizzel for testing image sizes

- (void)swizzel
{
    Method origMethod = class_getInstanceMethod([UIScreen class], @selector(bounds));
    Method altMethod = class_getInstanceMethod([BGBaseTestClass class], @selector(screenBounds));
    method_exchangeImplementations(origMethod, altMethod);
}

- (CGRect)screenBounds
{
    return CGRectMake(0.f, 0.f, 640.f, 1136.f);
}


#pragma mark - Helpers

- (void)setDoneFlagToYes
{
    self.done = YES;
}

- (NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

- (BOOL)areIntsEqualIntA:(NSInteger)a IntB:(NSInteger)b
{
    BOOL areEqual = NO;
    
    if (a == b) {
        areEqual = YES;
    }
    
    return areEqual;
}

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs
{
	NSDate	*timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
	
	while (!self.done) {
		
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
		
        if([timeoutDate timeIntervalSinceNow] < 0.0) {
			break;
        }
	}
	
	return self.done;
}

- (BGMSection *)newsSection;
{
    BGMIssue *issue = [[BGMIssueManager sharedInstance].issues objectAtIndex:0];
    
    BGMSectionAbstract *newsSectionAbstract = nil;
    
    for (BGMSectionAbstract *sectionAbstract in issue.sectionAbstracts) {
        if ([sectionAbstract.name isEqualToString:@"News"]) {
            newsSectionAbstract = sectionAbstract;
            break;
        }
    }
    STAssertNotNil(newsSectionAbstract, nil);
    
    BGMSection *newsSection = [[BGMSectionManager sharedInstance] sectionForID:newsSectionAbstract.identifier];
    
    return newsSection;
}

@end
