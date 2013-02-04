//
//  BGCSubscriptionManager.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/17/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMSubscriptionManager.h"

@interface BGMSubscriptionManager ()

@property (nonatomic) BGSubscriptionType subscriptionIdentifier;
@property (nonatomic) BOOL subscriptionValid;
@property (nonatomic, strong) NSDate *subscriptionStartDate;
@property (nonatomic, strong) NSDate *subscriptionEndDtae;
@property (nonatomic, strong) NSString *loginToken;
@property (nonatomic, strong) NSString *subscriptionRecipt;

@end

@implementation BGMSubscriptionManager

+ (BGMSubscriptionManager *)sharedInstance
{
    static BGMSubscriptionManager *sharedInstance;
    
    @synchronized(self)
    {
        if (!sharedInstance)
            sharedInstance = [[BGMSubscriptionManager alloc] init];
            // Get the data from Boston Globe Subscription Manager
        return sharedInstance;
    }
}

- (BOOL)isSubscriptionValid
{    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:BGUserSubscribed]) {
        self.subscriptionValid = YES;
    } else {
        self.subscriptionValid = NO;
    }
    return self.subscriptionValid;
}

- (BGSubscriptionType)subscriptionType
{    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:BGSubscriptionIdentifier] == 0) {
        
        self.subscriptionIdentifier = BGPrintSubscription;
        
    } else if ([[NSUserDefaults standardUserDefaults] integerForKey:BGSubscriptionIdentifier] == 1) {
        
        self.subscriptionIdentifier = BGAutoRenewableWeekSubscription;
        
    } else if ([[NSUserDefaults standardUserDefaults] integerForKey:BGSubscriptionIdentifier] == 2) {
        
        self.subscriptionIdentifier = BGAutoRenewableMonthSubscription;

    } else {
        
        self.subscriptionIdentifier = BGFreeSubscription;

    }
    return self.subscriptionIdentifier;

}

- (NSDate *)startDate
{
    self.subscriptionStartDate = [[NSUserDefaults standardUserDefaults] objectForKey:BGSubscriptionStartDate];
    return self.subscriptionStartDate;
}

- (NSDate *)endDate
{
    self.subscriptionEndDtae = [[NSUserDefaults standardUserDefaults] objectForKey:BGSubscriptionEndDate];
    return self.subscriptionEndDtae;
}

- (NSString *)token
{
    self.loginToken = [[NSUserDefaults standardUserDefaults] objectForKey:BGSubscriptionToken];
    return self.loginToken;
}

- (NSString *)recipt
{
    self.subscriptionRecipt = [[NSUserDefaults standardUserDefaults] objectForKey:BGSubscriptionRecipt];
    return self.subscriptionRecipt;
}

- (void)storeReciptData:(NSDate *)startDate endDate:(NSDate *)endDate token:(NSString *)token recipt:(NSData *)recipt subscription:(BGSubscriptionType) subscriptionType
{    
    [[NSUserDefaults standardUserDefaults] setInteger:subscriptionType forKey:BGSubscriptionIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BGUserSubscribed];

    [[NSUserDefaults standardUserDefaults] setValue:token forKey:BGSubscriptionToken];
    [[NSUserDefaults standardUserDefaults] setValue:recipt forKey:BGSubscriptionRecipt];
    
    NSLog(@"Start Data: %@", startDate);
    [[NSUserDefaults standardUserDefaults] setObject:startDate forKey:BGSubscriptionStartDate];
    // End date logic
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    [dateFormatter setDateStyle:NSDateFormatterLongStyle]; // day, Full month and year
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *myStringDate = [dateFormatter stringFromDate:endDate];
    
    int addDaysCount = 0;
    // How much day to add
    if (subscriptionType == 0) {
        addDaysCount = 365;
    } else if (subscriptionType == 1) {
        addDaysCount = 7;
    } else if (subscriptionType == 2) {
        addDaysCount = 30;
    } else if (subscriptionType == 3) {
        addDaysCount = 30;
    }
    
    // Retrieve NSDate instance from stringified date presentation
    NSDate *dateFromString = [dateFormatter dateFromString:myStringDate];
    
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:addDaysCount];
    
    // Retrieve date with increased days count
    NSDate *newDate = [[NSCalendar currentCalendar]
                       dateByAddingComponents:dateComponents
                       toDate:dateFromString options:0];
    
    [[NSUserDefaults standardUserDefaults] setObject:newDate forKey:BGSubscriptionEndDate];
}

@end
