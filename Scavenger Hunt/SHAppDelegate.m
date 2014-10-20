//
//  SHAppDelegate.m
//  Scavenger Hunt
//
//  Created by Raymond Qiu on 8/22/14.
//  Copyright (c) 2014 Ruiqing Qiu. All rights reserved.
//

#import "SHAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SHMapViewController.h"
#import "MapViewController.h"
#define UPDATE_LOCATION_INTERVAL 60

NSTimer* t;
@implementation SHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyD2GLdXS-BZVWmXFtrtHDm2aMhcHlNCaQw"];
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



//starts when application switchs into backghround
- (void)applicationDidEnterBackground:(UIApplication *)application
{
        __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task, preferably in chunks.
       t = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(callSend) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    });
}
                      
-(void)callSend{
    NSLog(@"in call send");
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *mapViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    NSLog(@"%@", mapViewController);
    [mapViewController sendBackground:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ([t isValid]){
        // the timer is valid and running, how about invalidating it
        [t invalidate];
        t = nil;
        //self.navigationController.navigationBar.hidden = NO;
    }

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

@end
