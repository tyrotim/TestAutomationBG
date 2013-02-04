//
//  MobMSNetworkCall.h
//  MobMSNetwork
//
//  Created by Nidal Fakhouri on 11/17/12.
//  Copyright (c) 2012 mobiquity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+MobMSNetworkCall.h"
@protocol MobMSNetworkCallStatusDelegate;

typedef void (^MobMSNetworkCallSuccessBlock)();
typedef void (^MobMSNetworkCallFailureBlock)(NSError *error);

typedef enum MobMSHTTPMethodType {
    MobMSHTTPMethodTypeGet = 0,
    MobMSHTTPMethodTypePut,
    MobMSHTTPMethodTypePost,
    MobMSHTTPMethodTypeDelete
} MobMSHTTPMethodType;

typedef enum MobMSURLRequestCachePolicy {
    MobMSURLRequestUseProtocolCachePolicy = 0,
    MobMSURLRequestReloadIgnoringLocalCacheData,
    MobMSURLRequestReturnCacheDataElseLoad,
    MobMSURLRequestReturnCacheDataDontLoad
} MobMSURLRequestCachePolicy;

/***/
@interface MobMSNetworkCall : NSObject

/* ~~~~~ Status Delegate ~~~~~ */
/***/
@property (nonatomic, weak) id<MobMSNetworkCallStatusDelegate> statusDelegate;


/* ~~~~~ Inputs ~~~~~ */
/***/
@property (nonatomic, assign) MobMSHTTPMethodType HTTPMethod;

/***/
@property (nonatomic, assign) MobMSURLRequestCachePolicy cachePolicy;

/***/
@property (nonatomic, assign) NSTimeInterval timeout;

/***/
@property (nonatomic, assign) NSUInteger retryCount;

/***/
@property (nonatomic, assign) BOOL useHTTPS;


/* ~~~~~ URLs ~~~~~ */
/**If set will override the URL construction structure that uses: hostName, portNumber, basePath, relativePath*/
@property (nonatomic, copy) NSURL *requestURL;

// Total URL: http(s)://api.weightwatchers.com:8080/apiv1/login
/**"api.weightwatchers.com"*/
@property (nonatomic, copy) NSString *hostName;

/**"8080"*/
@property (nonatomic, copy) NSNumber *portNumber;

/**"apiv1"*/
@property (nonatomic, copy) NSString *basePath;

/**"login"*/
@property (nonatomic, copy) NSString *relativePath;


/* ~~~~~ Outputs / Readonly properties ~~~~~ */
/***/
@property (nonatomic, assign, readonly) NSTimeInterval duration;

/***/
@property (nonatomic, strong, readonly) NSData *responseData;

/**Full URL, including parameters*/ 
@property (nonatomic, strong, readonly) NSURL *combinedURL;

/***/
@property (nonatomic, strong, readonly) NSURLRequest *request;

/***/
@property (nonatomic, strong, readonly) NSURLConnection *connection;

/***/
@property (nonatomic, strong, readonly) NSURLResponse *response;

/***/
@property (nonatomic, strong, readonly) NSDictionary *responseHTTPHeaderFields;

/***/
@property (nonatomic, assign, readonly) NSInteger responseStatusCode;

/***/
@property (nonatomic, assign, readonly) NSUInteger executionCount;

/***/
@property (nonatomic, strong, readonly) NSDate *startTime;

/***/
@property (nonatomic, strong, readonly) NSDate *endTime;


/* ~~~~~ Add Parameters ~~~~~ */
/***/
- (void)setValue:(id)value forQueryStringParameter:(NSString *)parameter;

/***/
- (void)setValue:(id)value forWebFormBodyParameter:(NSString *)parameter;

/***/
- (void)setValue:(id)value forHTTPHeaderField:(NSString *)field;

/**If you set the body data explicitly any key/values set in setValue:forWebFormBodyParameter: will not be added to the body*/
- (void)setDataForRequestBody:(NSData *)data;


/* ~~~~~ Execute / Cancel ~~~~~ */
/***/
- (void)executeAsyncWithSuccessBlock:(MobMSNetworkCallSuccessBlock)successBlock
                        failureBlock:(MobMSNetworkCallFailureBlock)failureBlock;

/***/
- (void)executeSyncWithSuccessBlock:(MobMSNetworkCallSuccessBlock)successBlock
                       failureBlock:(MobMSNetworkCallFailureBlock)failureBlock;

/***/
- (void)cancel;


/* ~~~~~ Reachability ~~~~~ */
/***/
- (BOOL)isReachable;


/* ~~~~~ Must Override ~~~~~ */
/***/
- (void)addParametersForCall;

/***/
- (void)formatResponseWithData:(NSData *)data error:(NSError **)error;

@end


/***/
@protocol MobMSNetworkCallStatusDelegate <NSObject>

@optional

/***/
- (void)networkCallDidStartLoading:(MobMSNetworkCall *)call;

/***/
- (void)networkCall:(MobMSNetworkCall *)call willUpdateProgressWithPercentage:(float)percentage;

/***/
- (void)networkCallDidFinishLoading:(MobMSNetworkCall *)call;

@end
