//
//  AppDelegate.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 2/25/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "AppDelegate.h"
#import "OrthodoxDay.h"
#import "OrthodoxJSONDataProvider.h"
#import "MainViewController.h"

#import "CalendarViewController.h"
#import "OrthodoxFavoritesManagerUserDefaults.h"
#import "ColorsAndFonts.h"
#import <Reachability.h>

@interface AppDelegate ()

@property (nonatomic, strong) UIView *noInternetConnectionView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2015" ofType:@"json"];
    
    OrthodoxJSONDataProvider *dataProvider = [[OrthodoxJSONDataProvider alloc] initWithPathToJSON:filePath];
    OrthodoxFavoritesManagerUserDefaults *favoritesManager = [[OrthodoxFavoritesManagerUserDefaults alloc] init];
    
    MainViewController *rootController = [[MainViewController alloc] initWithOrthodoxDataProvider:dataProvider];
    rootController.favoritesManager = favoritesManager;
    
    self.window.rootViewController = rootController;
    [self.window makeKeyAndVisible];
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];

    __weak AppDelegate *weakSelf = self;
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setNoConnectionViewHidden:YES];
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setNoConnectionViewHidden:NO];
        });
    };
    
    [self setupNoInternetConnectionView];
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - No internet connection

- (void)setNoConnectionViewHidden:(BOOL)hidden
{
    if(hidden)
    {
        [self.noInternetConnectionView removeFromSuperview];
    }
    else
    {
        [self.window.rootViewController.view addSubview:self.noInternetConnectionView];
    }
}

- (void)setupNoInternetConnectionView
{
    self.noInternetConnectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.rootViewController.view.frame.size.width, 40)];
    self.noInternetConnectionView.backgroundColor = [ColorsAndFonts primary];
    self.noInternetConnectionView.alpha = 0.7;
    UILabel *noInternetConnectionLabel = [[UILabel alloc]  initWithFrame:CGRectMake(0, 20, self.window.rootViewController.view.frame.size.width, 20)];
    noInternetConnectionLabel.text = @"No Internet Connection";
    noInternetConnectionLabel.textAlignment = NSTextAlignmentCenter;
    noInternetConnectionLabel.textColor = [UIColor blackColor];
    noInternetConnectionLabel.font = [UIFont systemFontOfSize:14.0];
    
    [self.noInternetConnectionView addSubview:noInternetConnectionLabel];
}

@end
