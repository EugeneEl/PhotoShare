//
//  splashViewController.m
//  PhotoShare
//
//  Created by Евгений on 10.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//


//This class descibes a viewcontroller which appears after finishing launching of application.
//It displays a picture with a photocamera and contains a label which
//tells user if he/she has aleady logged in.

#import "PSSplashViewController.h"
#import "PSLoginViewController.h"
#import "PSUserStore.h"
#import "PSStreamViewController.h"
#import "CustomSegueForStart.h"
#import "AutoLocalize.h"

@interface PSSplashViewController ()


@end

@implementation PSSplashViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self icnh_autoLocalize];
    self.startImage.image=[UIImage imageNamed:@"camera_cute2_png.png"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [PSUserStore userStoreManager];
    
    if (!([PSUserStore userStoreManager].activeUser)) {
        [self.navigationController performSegueWithIdentifier:@"login" sender:nil];
        NSLog(@"no active user");
        
    }
    else
    {
    NSLog(@"user is active");
    [self performSegueWithIdentifier:@"goToUserBarScreen" sender:nil];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"login"])
    {
        PSLoginViewController *vc = (PSLoginViewController*)segue.destinationViewController;
        //vc.navigationController.delegate=vc;
    }
    if([segue isKindOfClass:[CustomSegueForStart class]]) {
        // Set the start point for the animation to center of the button for the animation
        ((CustomSegueForStart *)segue).originatingPoint = self.view.center;
    }
}


@end
