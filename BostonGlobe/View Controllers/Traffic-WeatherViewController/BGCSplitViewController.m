//
//  BGCSplitViewController.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/24/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCSplitViewController.h"
#import "BGCTrafficViewController.h"
#import "BGCWeatherTableViewController.h"

@interface BGCSplitViewController ()

@property (strong, nonatomic) BGCTrafficViewController *trafficVC;
@property (strong, nonatomic) BGCWeatherTableViewController *weatherVC;

@end

@implementation BGCSplitViewController

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
    
    self.weatherVC = [[BGCWeatherTableViewController alloc] initWithNibName:@"BGCWeatherTableViewController" bundle:nil];
    self.weatherVC.view.frame = CGRectMake(0, 50, 320, 480);
    [self.view addSubview:self.weatherVC.view];
    
    self.trafficVC = [[BGCTrafficViewController alloc] initWithNibName:@"BGCTrafficViewController" bundle:Nil];
    self.trafficVC.view.frame = CGRectMake(0, 50, 320, 480);
    [self.view addSubview:self.trafficVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Weather:(id)sender {
    
    self.trafficVC.view.hidden = YES;
    self.weatherVC.view.hidden = NO;
}

- (IBAction)Traffic:(id)sender {
    
    self.weatherVC.view.hidden = YES;
    self.trafficVC.view.hidden = NO;
}
@end
