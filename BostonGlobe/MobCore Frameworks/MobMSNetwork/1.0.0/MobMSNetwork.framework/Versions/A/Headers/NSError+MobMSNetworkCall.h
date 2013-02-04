//
//  NSError+MobMSNetworkCall.h
//  MobMSNetwork
//
//  Created by Nidal Fakhouri on 12/3/12.
//  Copyright (c) 2012 mobiquity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MobMSNetworkCall)

/* ~~~~~ Error Domain ~~~~~ */
/***/
+ (NSString *)mobMSNetworkCall_errorDomain;


/* ~~~~~ Error Codes ~~~~~ */
/***/
+ (NSInteger)mobMSNetworkCall_reachabilityErrorCode;

/***/
+ (NSInteger)mobMSNetworkCall_invalidHostNameErrorCode;

/***/
+ (NSInteger)mobMSNetworkCall_dataFormatErrorCode;


/* ~~~~~ Generated Errors ~~~~~ */
/***/
+ (NSError *)mobMSNetworkCall_errorForReachabilityError;

/***/
+ (NSError *)mobMSNetworkCall_errorForInvalidHostNameError;

/***/
+ (NSError *)mobMSNetworkCall_errorDataFormatError;


/* ~~~~~ Helpers ~~~~~ */
/***/
- (BOOL)mobMSNetworkCall_isReachabilityError;

@end
