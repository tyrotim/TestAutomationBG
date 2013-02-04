//
//  MobMSNetworkMockDataManager.h
//  MobMSNetwork
//
//  Created by Nidal Fakhouri on 11/29/12.
//  Copyright (c) 2012 mobiquity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobMSNetworkCall.h"

typedef NSData * (^MobMSNetworkMockDataManagerBlock)(void);

/***/
@interface MobMSNetworkMockDataManager : NSObject

/***/
+ (MobMSNetworkMockDataManager *)sharedInstance;

/***/
- (void)clear;


/* ~~~~~ Register Data ~~~~~ */
/***/
- (void)registerData:(NSData *)data forApiCallWithURL:(NSURL *)URL;

/***/
- (void)registerData:(NSData *)data forNetworkCallClass:(Class)networkCallClass;


/* ~~~~~ Register File ~~~~~ */
/***/
- (void)registerFile:(NSString *)filePath ofType:(NSString *)type forApiCallWithURL:(NSURL *)URL;

/***/
- (void)registerFile:(NSString *)filePath ofType:(NSString *)type forNetworkCallClass:(Class)networkCallClass;


/* ~~~~~ Register Block ~~~~~ */
/***/
- (void)registerBlock:(MobMSNetworkMockDataManagerBlock)dataBlock forApiCallWithURL:(NSURL *)URL;

/***/
- (void)registerBlock:(MobMSNetworkMockDataManagerBlock)dataBlock forNetworkCallClass:(Class)networkCallClass;


/* ~~~~~ Query For Data ~~~~~ */
/***/
- (NSData *)dataFromMockDataManagerForNetworkCall:(MobMSNetworkCall *)call;

/***/
+ (NSData*)dataWithName:(NSString*)fileName andType:(NSString*)type;

@end
