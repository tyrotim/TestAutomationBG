//
//  BGCFreeSubscriptionViewController.h
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/8/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FreeSubscriptionDelegate <NSObject>

@required
-(void)cancelButtonClickedFromFreeSub;
@end

@interface BGCFreeSubscriptionViewController : UIViewController
@property (nonatomic, weak) id <FreeSubscriptionDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *startButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *cancelButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *titleFreeSubscriptionOutlet;
@property (weak, nonatomic) IBOutlet UILabel *detailDiscrptionOutlet;

@property (weak, nonatomic) IBOutlet UILabel *welcomeTitleOulet;
@property (weak, nonatomic) IBOutlet UILabel *startLineOutlet;
@property (weak, nonatomic) IBOutlet UILabel *endDateOutlet;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;

- (IBAction)startSubscription:(id)sender;
- (IBAction)cancelFreeSubscription:(id)sender;
@end

