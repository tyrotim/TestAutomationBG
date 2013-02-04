//
//  BGCTrafficViewController.m
//  BostonGlobe
//
//  Created by Amit Vyawahare on 1/23/13.
//  Copyright (c) 2013 Mobiquity, Inc. All rights reserved.
//

#import "BGCTrafficViewController.h"
#import "GRMustache.h"
#import "BGString.h"

#define Default_Latitude @"42.269517"
#define Default_Longitude @"-71.026967"

@interface BGCTrafficViewController ()

@property (nonatomic, strong) NSString *htmlPath;
@property (nonatomic, strong) NSString *htmlContent;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDictionary *htmlRenderObject;
@end

@implementation BGCTrafficViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)defaultData
{
    if ([[UIScreen mainScreen] bounds].size.height < 500) {
        self.htmlRenderObject = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:Default_Latitude, Default_Longitude, @"420", nil]
                                                            forKeys:[NSArray arrayWithObjects:Latitude, Longitude, TrafficWebviewsize, nil]];
    } else {
        self.htmlRenderObject = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:Default_Latitude, Default_Longitude, @"500", nil]
                                                            forKeys:[NSArray arrayWithObjects:Latitude, Longitude, TrafficWebviewsize, nil]];
    }
    
    self.htmlPath = [[NSBundle mainBundle] pathForResource:@"layer-traffic" ofType:@"html"];
    
    self.htmlContent = [NSString stringWithContentsOfFile:self.htmlPath
                                                 encoding:NSUTF8StringEncoding
                                                    error:NULL];
    
    [self.trafficWebView loadHTMLString:[GRMustacheTemplate renderObject:self.htmlRenderObject fromString:self.htmlContent error:nil] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self defaultData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserLocation) name:WEATHER_TAB_CLICK_NOTIFICATION object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{    
    if (newLocation.coordinate.latitude != oldLocation.coordinate.latitude && newLocation.coordinate.longitude != oldLocation.coordinate.longitude)
    {
        if ([[UIScreen mainScreen] bounds].size.height < 500) {
            self.htmlRenderObject = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude], [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude], @"420", nil]
                                                                forKeys:[NSArray arrayWithObjects:Latitude, Longitude, TrafficWebviewsize, nil]];
        } else {
            self.htmlRenderObject = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude], [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude], @"500", nil]
                                                                forKeys:[NSArray arrayWithObjects:Latitude, Longitude, TrafficWebviewsize, nil]];
        }
        
        self.htmlPath = [[NSBundle mainBundle] pathForResource:@"layer-traffic" ofType:@"html"];
        
        self.htmlContent = [NSString stringWithContentsOfFile:self.htmlPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
        
        [self.trafficWebView loadHTMLString:[GRMustacheTemplate renderObject:self.htmlRenderObject fromString:self.htmlContent error:nil] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BGUserAcceptedUserLocation];
    }
}

- (void)updateUserLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager startUpdatingLocation];
}

@end
