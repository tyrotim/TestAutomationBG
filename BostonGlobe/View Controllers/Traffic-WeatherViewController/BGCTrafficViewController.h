//
//  BGCTrafficViewController.h
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/23/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BGCTrafficViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *trafficWebView;

@end
