//
//  MobULogInternal.h
//  MobULogInternal
//
//  Created by Amit Vyawahare on 11/21/12.
//  Copyright (c) 2012 Amit Vyawahare. All rights reserved.
//

#define LOG_MACRO(isAsynchronous, lvl, flg, ctx, atag, fnct, frmt, ...) \
[MobULogManager log:isAsynchronous                                             \
                level:lvl                                                      \
                flag:flg                                                       \
                context:ctx                                                    \
                file:__FILE__                                                  \
                function:fnct                                                  \
                line:__LINE__                                                  \
                tag:atag                                                       \
                format:(frmt), ##__VA_ARGS__]

#define  SYNC_LOG_OBJC_MACRO(lvl, flg, ctx, frmt, ...) \
LOG_OBJC_MACRO( NO, lvl, flg, ctx, frmt, ##__VA_ARGS__)

#define LOG_MAYBE(async, lvl, flg, ctx, fnct, frmt, ...) \
do { if(lvl & flg) LOG_MACRO(async, lvl, flg, ctx, nil, fnct, frmt, ##__VA_ARGS__); } while(0)

#define LOG_OBJC_MAYBE(async, lvl, flg, ctx, frmt, ...) \
LOG_MAYBE(async, lvl, flg, ctx, sel_getName(_cmd), frmt, ##__VA_ARGS__)

#define  SYNC_LOG_OBJC_MAYBE(lvl, flg, ctx, frmt, ...) \
LOG_OBJC_MAYBE( NO, lvl, flg, ctx, frmt, ##__VA_ARGS__)

#define LOG_FLAG_ERROR    (1 << 0)  // 0...0001
#define LOG_FLAG_WARN     (1 << 1)  // 0...0010
#define LOG_FLAG_INFO     (1 << 2)  // 0...0100
#define LOG_FLAG_VERBOSE  (1 << 3)  // 0...1000

#define LOG_LEVEL_OFF     0

#define LOG_LEVEL_ERROR   (LOG_FLAG_ERROR)                                                    // 0...0001
#define LOG_LEVEL_WARN    (LOG_FLAG_ERROR | LOG_FLAG_WARN)                                    // 0...0011
#define LOG_LEVEL_INFO    (LOG_FLAG_ERROR | LOG_FLAG_WARN | LOG_FLAG_INFO)                    // 0...0111
#define LOG_LEVEL_VERBOSE (LOG_FLAG_ERROR | LOG_FLAG_WARN | LOG_FLAG_INFO | LOG_FLAG_VERBOSE) // 0...1111

#define LOG_ERROR   (mobULogLevel & LOG_FLAG_ERROR)
#define LOG_WARN    (mobULogLevel & LOG_FLAG_WARN)
#define LOG_INFO    (mobULogLevel & LOG_FLAG_INFO)
#define LOG_VERBOSE (mobULogLevel & LOG_FLAG_VERBOSE)

#define LOG_ASYNC_ENABLED YES

#define LOG_ASYNC_ERROR   ( NO && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_WARN    (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_INFO    (YES && LOG_ASYNC_ENABLED)
#define LOG_ASYNC_VERBOSE (YES && LOG_ASYNC_ENABLED)
