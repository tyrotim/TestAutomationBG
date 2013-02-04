//
//  BGCInAppPurchaseManager.h
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/9/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface BGMInAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property(nonatomic, strong) SKProduct *bgProduct;
@property(nonatomic, strong) SKProductsRequest *productsRequest;

+ (BGMInAppPurchaseManager *)sharedInstance;

- (void)requestFreeProductData;
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)requestOneWeekSubscriptionProductData;
- (void)requestOneMonthSubscriptionProductData;
- (void)restoreInAppPurchase;

@end
