//
//  BGCActivityIndicatorViewController.h
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/17/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGCActivityIndicatorViewController : UIViewController

- (void)centerSpinnerWithViewFrame:(CGRect)viewFrame;

- (void)start;
- (void)stop;

@end
