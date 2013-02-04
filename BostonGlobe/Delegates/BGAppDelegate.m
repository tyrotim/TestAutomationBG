//
//  BGAppDelegate.m
//  BostonGlobe
//
//  Created by Mark Pirri on 12/4/12.
//  Copyright (c) 2012 Mobiquity, Inc. All rights reserved.
//

#import "BGAppDelegate.h"
#import "UAirship.h"
#import "UAPush.h"
#import "BGMIssueManager.h"
#import "BGMInAppPurchaseManager.h"
#import "BGCRootViewController.h"
#import "BGCPickTopicsViewController.h"
#import "BGString.h"
#import "UASubscriptionManager.h"

@implementation BGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    NSURL *downloadURL = [BGMIssueManager downloadURLForDate:[NSDate date]];
    [[BGMIssueManager sharedInstance] clearAllIssues];
    [[BGMIssueManager sharedInstance] addIssueWithDate:[NSDate date] andURL:downloadURL];
    /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [application setStatusBarHidden:YES];
    
    // Override point for customization after application launch.
    
    BGCRootViewController *masterViewController = [[BGCRootViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = masterViewController;
    [self.window makeKeyAndVisible];
    
    //Init Airship launch options
    NSMutableDictionary *takeOffOptions = [[NSMutableDictionary alloc] init];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    [UAirship takeOff:takeOffOptions];

    // Register for notifications
    [[UAPush shared] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeNewsstandContentAvailability |
                                                         UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound |
                                                         UIRemoteNotificationTypeAlert)];
    
    self.newsstandHelper = [[UANewsstandHelper alloc] init];
    [[UASubscriptionManager shared] addObserver:self.newsstandHelper];
      
    // For debugging only - allow multiple pushes per day
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NKDontThrottleNewsstandContentNotifications];
    
    // Handle incoming pushes
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    [self handleNewsstandPushInfo:userInfo];
    
    // Load Store on Launch
    [[BGMInAppPurchaseManager sharedInstance] loadStore];
    
    // Add or Update tags
    [self updateUrbanAirshipTags];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    // Log the device token
    NSString *dToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dToken = [dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"Device Token: %@",dToken);
    
    // Updates the device token and registers the token with UA
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0)
{
    NSLog(@"Error: %@", error.localizedDescription);
}

// Notifications for application while the app is running.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleNewsstandPushInfo:userInfo];
}

- (void)updateUrbanAirshipTags
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:FirstTimeLaunchFlag] != 99)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:99 forKey:FirstTimeLaunchFlag];
        [[NSUbiquitousKeyValueStore defaultStore] setBool:YES forKey:NewsAlertSwitch];
        [[NSUbiquitousKeyValueStore defaultStore] synchronize];

        [[UAPush shared] addTagToCurrentDevice:BreakingNewsTag];
        [[UAPush shared] updateRegistration];
    }
}

#pragma mark -
#pragma mark Push Handler

- (void)handleNewsstandPushInfo:(NSDictionary *)userInfo
{
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    if ([[apsInfo objectForKey:@"content-available"] intValue] == 1) {
        
        // You can download the content
        // Do the background download hear.
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions
    // (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to
    // restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously
    // in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [UAirship land];
}

@end
