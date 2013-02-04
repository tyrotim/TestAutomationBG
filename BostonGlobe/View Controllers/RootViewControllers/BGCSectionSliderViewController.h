//
//  BGCSectionSliderViewController.h
//  BostonGlobe
//
//  Created by Christian Grise on 12/17/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BGCSectionSliderViewController;
@protocol BGCSectionSliderViewControllerDelegate <NSObject>

- (void)sectionSliderViewController:(BGCSectionSliderViewController *)sectionSliderViewController
     didSelectSectionWithIdentifier:(NSString *)identifier;

@end

@interface BGCSectionSliderViewController : UIViewController

@property (nonatomic, weak) id<BGCSectionSliderViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *sectionSliderNub;
@property (weak, nonatomic) IBOutlet UITableView *sectionTableView;
@property (nonatomic, strong) NSArray *sectionArray;

@end
