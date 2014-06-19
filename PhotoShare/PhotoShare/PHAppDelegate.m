//
//  PHAppDelegate.m
//  PhotoShare
//
//  Created by Евгений on 10.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PHAppDelegate.h"
#import "PSLoginViewController.h"
#import "PSSplashViewController.h"
#import "User.h"
#import "Post.h"

const int numberOfUsersForTest=5;

@implementation PHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStack];
    
    
   //[User MR_truncateAll];
   //[Post MR_truncateAll];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

@end
