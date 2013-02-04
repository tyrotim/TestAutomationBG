//
//  BGCHeaderBarViewController.h
//  BostonGlobe
//
//  Created by Christian Grise on 12/20/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BGCRootViewController;

@interface BGCHeaderBarViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *storyfeedButton;
@property (weak, nonatomic) IBOutlet UIButton *sectionDateButton;
@property (weak, nonatomic) IBOutlet UIButton *weatherButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (weak, nonatomic) IBOutlet UIImageView *verticalSeparatorImage1;
@property (weak, nonatomic) IBOutlet UIImageView *verticalSeparatorImage2;
@property (weak, nonatomic) IBOutlet UIImageView *verticalSeparatorImage3;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, strong) BGCRootViewController *rootViewController;
@end
