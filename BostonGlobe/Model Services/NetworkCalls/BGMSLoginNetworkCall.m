//
//  BGMSLoginNetworkCall.m
//  BostonGlobe
//
//  Created by Christian Grise on 1/15/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGMSLoginNetworkCall.h"
#import "BGMUser.h"
#import "GDataXMLNode.h"

@implementation BGMSLoginNetworkCall

- (void)addParametersForCall
{
    self.hostName = @"members.boston.com";
    self.basePath = @"profiles/outside/REST/npd";
    self.relativePath = @"login";
    
    [self setValue:self.username forQueryStringParameter:@"username"];
    [self setValue:self.password forQueryStringParameter:@"password"];
    
    [super addParametersForCall];
}

- (void)formatResponseWithData:(NSData *)data error:(NSError *__autoreleasing *)error
{
    [super formatResponseWithData:data error:error];
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
    
    GDataXMLDocument *responseXML = [[GDataXMLDocument alloc] initWithXMLString:responseString options:0 error:error];
    NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
    
    NSArray *elements = [[responseXML rootElement] children];
    for (GDataXMLElement *element in elements) {
        [userData setObject:element.stringValue forKey:element.name];
    }
    
    if ([userData objectForKey:@"userID"] && ![[userData objectForKey:@"userID"] isEqualToString:@"0"]) {
        self.userData = userData;
    } else {
        *error = [NSError mobMSNetworkCall_errorDataFormatError];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"loginSuccessful"];
    }
}

@end
