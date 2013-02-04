//
//  MobULog.h
//  MobULog
//
//  Created by Amit Vyawahare on 11/28/12.
//  Copyright (c) 2012 Amit Vyawahare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobULogManager.h"
#import "MobULogInternal.h"

#define MobULogError(frmt, ...)   LOG_OBJC_MAYBE(LOG_ASYNC_ERROR,   mobULogLevel, LOG_FLAG_ERROR,   0, frmt, ##__VA_ARGS__)
#define MobULogWarn(frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_WARN,    mobULogLevel, LOG_FLAG_WARN,    0, frmt, ##__VA_ARGS__)
#define MobULogInfo(frmt, ...)    LOG_OBJC_MAYBE(LOG_ASYNC_INFO,    mobULogLevel, LOG_FLAG_INFO,    0, frmt, ##__VA_ARGS__)
#define MobULogVerbose(frmt, ...) LOG_OBJC_MAYBE(LOG_ASYNC_VERBOSE, mobULogLevel, LOG_FLAG_VERBOSE, 0, frmt, ##__VA_ARGS__)

@interface MobULog : NSObject

@end
