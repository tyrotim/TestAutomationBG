//
//  BGAppDelegate.h
//  BGNewsstandUnitTestHost
//
//  Created by Nidal Fakhouri on 1/18/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BGViewController;

@interface BGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BGViewController *viewController;

@end
