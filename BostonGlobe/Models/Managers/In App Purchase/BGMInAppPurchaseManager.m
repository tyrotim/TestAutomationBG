//
//  BGCInAppPurchaseManager.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/9/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMInAppPurchaseManager.h"
#import "BGMSubscriptionManager.h"
#import "Base64.h"

@implementation BGMInAppPurchaseManager

+ (BGMInAppPurchaseManager *)sharedInstance
{
    static BGMInAppPurchaseManager *sharedInstance;
    
    @synchronized(self)
    {
        if (!sharedInstance)
            sharedInstance = [[BGMInAppPurchaseManager alloc] init];
        
        return sharedInstance;
    }
}

#pragma Load Store from Startup

- (void)loadStore
{
    // Restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

#pragma Request Product data

- (void)requestFreeProductData
{
    NSSet *productIdentifiers = [NSSet setWithObject:freeProductIdentifiers];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];    
}

- (void)requestOneWeekSubscriptionProductData
{
    NSSet *productIdentifiers = [NSSet setWithObject:oneWeekProductIdentifiers];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

- (void)requestOneMonthSubscriptionProductData
{
    NSSet *productIdentifiers = [NSSet setWithObject:oneMonthProductIdentifiers];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

- (void)restoreInAppPurchase {
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    self.bgProduct = [products count] == 1 ? [products lastObject] : nil;
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
    }
    
    if (self.bgProduct) {
        NSLog(@"Product title: %@" , self.bgProduct.localizedTitle);
        NSLog(@"Product description: %@" , self.bgProduct.localizedDescription);
        NSLog(@"Product price: %@" , self.bgProduct.price);
        NSLog(@"Product id: %@" , self.bgProduct.productIdentifier);
        
        SKPayment *payment = [SKPayment paymentWithProduct:self.bgProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_MANAGER_PRODUCTS_FETCHED_NOTIFICATION object:self userInfo:nil];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

// called when the transaction status is updated
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

// called when the transaction was successful
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self finishTransaction:transaction wasSuccessful:YES];
}

// called when a transaction has failed
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify        
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_MANAGER_TRANSACTION_USER_CANCELLED object:self userInfo:nil];
    }
}

// called when a transaction has been restored and and successfully completed
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

}

#pragma -
#pragma Purchase helpers


// saves a record of the transaction by storing the receipt to disk
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{    
    if ([transaction.payment.productIdentifier isEqualToString:freeProductIdentifiers]) {
        
        [[BGMSubscriptionManager sharedInstance] storeReciptData:[NSDate date] endDate:[NSDate date] token:nil recipt:transaction.transactionReceipt subscription:BGFreeSubscription];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_MANAGER_TRANSACTION_SUCCEEDED_NOTIFICATION_FREE_SUB object:self userInfo:userInfo];
        
    } else if ([transaction.payment.productIdentifier isEqualToString:oneWeekProductIdentifiers]) {

        [[BGMSubscriptionManager sharedInstance] storeReciptData:[NSDate date] endDate:[NSDate date] token:nil recipt:transaction.transactionReceipt subscription:BGAutoRenewableWeekSubscription];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_MANAGER_TRANSACTION_SUCCEEDED_NOTIFICATION_ONE_WEEK_SUB object:self userInfo:userInfo];
        
    } else if ([transaction.payment.productIdentifier isEqualToString:oneMonthProductIdentifiers]) {

        [[BGMSubscriptionManager sharedInstance] storeReciptData:[NSDate date] endDate:[NSDate date] token:nil recipt:transaction.transactionReceipt subscription:BGAutoRenewableMonthSubscription];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_MANAGER_TRANSACTION_SUCCEEDED_NOTIFICATION_ONE_MONTH_SUB object:self userInfo:userInfo];
    }
}


// removes the transaction from the queue and posts a notification with the transaction result
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful) {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_MANAGER_TRANSACTION_SUCCEEDED_NOTIFICATION object:self userInfo:userInfo];
    }
    else {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_MANAGER_TRANSACTION_FAILED_NOTIFICATION object:self userInfo:userInfo];
    }
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        if ([productID isEqualToString:freeProductIdentifiers]) {
            
            [[BGMSubscriptionManager sharedInstance] storeReciptData:[NSDate date] endDate:[NSDate date] token:nil recipt:transaction.transactionReceipt subscription:BGFreeSubscription];
            
        } else if ([productID isEqualToString:oneWeekProductIdentifiers]) {
            
            [[BGMSubscriptionManager sharedInstance] storeReciptData:[NSDate date] endDate:[NSDate date] token:nil recipt:transaction.transactionReceipt subscription:BGAutoRenewableWeekSubscription];
            
        } else if ([productID isEqualToString:oneMonthProductIdentifiers]) {
            
            [[BGMSubscriptionManager sharedInstance] storeReciptData:[NSDate date] endDate:[NSDate date] token:nil recipt:transaction.transactionReceipt subscription:BGAutoRenewableMonthSubscription];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_MANAGER_TRANSACTION_SUCCEEDED_NOTIFICATION_RESTORE object:nil];
}

- (void) paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IN_APP_PURCHASE_MANAGER_TRANSACTION_FAILED_NOTIFICATION_RESTORE object:nil];
}

@end
