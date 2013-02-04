//
//  BGCActivityIndicatorViewController.m
//  BostonGlobe
//
//  Created by Nidal Fakhouri on 1/17/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCActivityIndicatorViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BGCActivityIndicatorViewController ()

@property (nonatomic, strong) IBOutlet UIView *centerView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *updateLabel;

@end

@implementation BGCActivityIndicatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.centerView.layer.cornerRadius = 11.0f;
    self.updateLabel.text = @"Data Parsing...";
}

- (void)centerSpinnerWithViewFrame:(CGRect)viewFrame
{
    self.view.frame = viewFrame;
    
    //Center Frame
    CGFloat h = self.view.frame.size.height;
    CGFloat frame_w = self.centerView.frame.size.width;
    CGFloat frame_h = self.centerView.frame.size.height;
    self.centerView.frame = CGRectMake(self.centerView.frame.origin.x,
                                       ((h - frame_h)/2.0),
                                       frame_w,
                                       frame_h);
}

- (void)start
{
    [self.activityIndicator startAnimating];
}

- (void)stop
{
    [self.activityIndicator stopAnimating];
}

@end
