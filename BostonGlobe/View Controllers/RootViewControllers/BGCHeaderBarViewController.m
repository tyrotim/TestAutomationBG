//
//  BGCHeaderBarViewController.m
//  BostonGlobe
//
//  Created by Christian Grise on 12/20/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGCHeaderBarViewController.h"
#import "BGCRootViewController.h"

@interface BGCHeaderBarViewController ()

@end

@implementation BGCHeaderBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dateLabel.font = [UIFont fontWithName:@"BentonSans-Medium" size:8];
    self.dateLabel.textColor = [UIColor colorWithRed:0.596 green:0.596 blue:0.596 alpha:1];

    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"EEEE, MMM dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    self.dateLabel.text = dateString;
    
    self.sectionLabel.font = [UIFont fontWithName:@"BentonSans-Bold" size:19];
    self.sectionLabel.textColor = [UIColor colorWithRed:0.596 green:0.596 blue:0.596 alpha:1];
    self.temperatureLabel.font = [UIFont fontWithName:@"BentonSans-Bold" size:12];
    self.temperatureLabel.textColor = [UIColor colorWithRed:0.596 green:0.596 blue:0.596 alpha:1];
    [self.temperatureLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)storyfeedButtonPressed:(id)sender
{
    [self.rootViewController storyfeedButtonPressed];
}

- (IBAction)sectionDateButtonPressed:(id)sender
{
    [self.rootViewController sectionDateButtonPressed];
}

- (IBAction)settingsButtonPressed:(id)sender
{
    [self.rootViewController.chromeTimer invalidate];
    [self.rootViewController showChromeWithDelay:0.0];
    [[NSNotificationCenter defaultCenter] postNotificationName:SETTINGS_TAB_CLICK_NOTIFICATION object:nil];
}

- (IBAction)weatherButtonPressed:(id)sender
{
    [self.rootViewController.chromeTimer invalidate];
    [self.rootViewController showChromeWithDelay:0.0];
    [[NSNotificationCenter defaultCenter] postNotificationName:WEATHER_TAB_CLICK_NOTIFICATION object:nil];
}


@end
