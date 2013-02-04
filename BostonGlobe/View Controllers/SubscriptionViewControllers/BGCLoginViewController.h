//
//  BGCBGLoginViewController.h
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/8/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BGLoginDelegate <NSObject>

@required
- (void)cancelButtonClickedFromLogin;
@end

@interface BGCLoginViewController : UIViewController
@property (nonatomic, weak) id <BGLoginDelegate> delegate;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
