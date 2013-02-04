//
//  BGMSLoginNetworkCall.h
//  BostonGlobe
//
//  Created by Christian Grise on 1/15/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMSBaseNetworkCall.h"

@class BGMUser;

@interface BGMSLoginNetworkCall : BGMSBaseNetworkCall

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSDictionary *userData;

@end
