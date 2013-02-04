//
//  MobULogManager.h
//  MobULogManager
//
//  Created by Amit Vyawahare on 11/19/12.
//  Copyright (c) 2012 Amit Vyawahare. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class demonstrates MobULogManager. This will manage logging behavior of the framework.
 */

@interface MobULogManager : NSObject

/**
* The default maximumFileSize is 1 MB.
* You should carefully consider the proper configuration values for your application.
**/

@property (nonatomic) unsigned long long maximumFileSize;

/**
 * The default rollingFrequency is 48 hours/ 2days.
 * You should carefully consider the proper configuration values for your application.
**/

@property (nonatomic) NSTimeInterval rollingFrequency;

/**
 * The default maximumNumberOfLogFiles is 2.
 * You should carefully consider the proper configuration values for your application.
 **/
@property (nonatomic) NSUInteger maximumNumberOfLogFiles;

/**
* The default loogingEnabled is YES / 1.
**/
@property (nonatomic) BOOL loggingEnabled;

/**
 * The default loggingIncludeCodeLocation is NO / 0.
 **/

@property (nonatomic) BOOL loggingIncludeCodeLocation;

/**
 * The default loggingIncludeCodeLocation is NO / 0.
 **/

@property (nonatomic) BOOL loggingDeviceInfoEnabled;

/**
 * The default logLevelTrace is 0.
 **/

@property (nonatomic) BOOL logLevelTrace;

/**
 * The default logLevelInfo is 0.
 **/

@property (nonatomic) BOOL logLevelInfo;

/**
 * The default logLevelError is 0.
 **/
@property (nonatomic) BOOL logLevelError;

/**
 * The default logLevelDebug is 0.
 **/
@property (nonatomic) BOOL logLevelDebug;

/**
 * The default value logToServer is 0.
 0 -> It will not log to the server
 1 -> It will send log data to server
 **/
@property (nonatomic) BOOL logToServer;

/**
 * The default value logToFile is 0.
 0 -> It will not log to the file on disk
 1 -> It will log data to disk file
 **/
@property (nonatomic) BOOL logToFile;

/**
 * The default value logToConsole is 1.
 0 -> It will not log to concel
 1 -> It will log to concel
 **/
@property (nonatomic) BOOL logToConsole;

/**
 * Authentication key for loggly or any other looging server
**/

@property (nonatomic, strong) NSString *authenticationKey;

/**
 * Host name for loggly or any other looging server
 **/
@property (nonatomic, strong) NSString *hostName;

/** 
 Singleton MobULogManager
*/

+ (MobULogManager *)sharedInstance;

/*
 Method to call at the launch
 */

- (void)startUsingMobULog;

/**
 This method syncs log to loggly
 */

- (BOOL)syncLogToServer;

/**
 * Logging Primitive.
 *
 * This method is used by the macros above.
 * It is suggested you stick with the macros as they're easier to use.
 **/

+ (void)log:(BOOL)synchronous
      level:(int)level
       flag:(int)flag
    context:(int)context
       file:(const char *)file
   function:(const char *)function
       line:(int)line
        tag:(id)tag
     format:(NSString *)format, ... __attribute__ ((format (__NSString__, 9, 10)));

/**
 * Logging Primitive.
 *
 * This method can be used if you have a prepared va_list.
 **/

+ (void)log:(BOOL)asynchronous
      level:(int)level
       flag:(int)flag
    context:(int)context
       file:(const char *)file
   function:(const char *)function
       line:(int)line
        tag:(id)tag
     format:(NSString *)format
       args:(va_list)argList;

@end
