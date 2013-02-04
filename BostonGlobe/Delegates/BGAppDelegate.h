//
//  BGAppDelegate.h
//  BostonGlobe
//
//  Created by Mark Pirri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UANewsstandHelper.h"

@interface BGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UANewsstandHelper *newsstandHelper;

@end
