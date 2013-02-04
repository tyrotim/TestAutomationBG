//
//  BGCSubscriptionManager.h
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/17/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    BGPrintSubscription,                    // Print Subscription from Boston Globe
    BGAutoRenewableWeekSubscription,        // Auto Renewable Subscription for week from In App Purchase
    BGAutoRenewableMonthSubscription,       // Auto Renewable Subscription for month from In App Purchase
    BGFreeSubscription                      // Free Subscription from In App Purchase
    
} BGSubscriptionType;

@interface BGMSubscriptionManager : NSObject

+ (BGMSubscriptionManager *)sharedInstance;

- (BOOL)isSubscriptionValid;
- (BGSubscriptionType)subscriptionType;
- (NSDate *)startDate;
- (NSDate *)endDate;
- (NSString *)token;
- (NSString *)recipt;

- (void)storeReciptData:(NSDate *)startDate endDate:(NSDate *)endDate token:(NSString *)token recipt:(NSData *)recipt subscription:(BGSubscriptionType) subscriptionType;

@end
