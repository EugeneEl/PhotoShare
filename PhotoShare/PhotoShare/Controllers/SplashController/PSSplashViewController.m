//
//  splashViewController.m
//  PhotoShare
//
//  Created by Евгений on 10.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//


#import "PSSplashViewController.h"
#import "PSLoginViewController.h"
#import "PSUserStore.h"
#import "PSStreamViewController.h"
#import "CustomSegueForStart.h"


@interface PSSplashViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *startImage;
@property (nonatomic, weak) IBOutlet UILabel *statusLoginLabel;

@end

@implementation PSSplashViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.startImage.image=[UIImage imageNamed:@"camera_cute2_png.png"];
}

#pragma mark - viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PSUserStore *userStore = [PSUserStore userStoreManager];
    if (!(userStore.activeUser)) {
        [self.navigationController performSegueWithIdentifier:@"login" sender:nil];
        NSLog(@"no active user");
    } else {
    NSLog(@"user is active");
    [self performSegueWithIdentifier:@"goToUserBarScreen" sender:nil];
    }
}

#pragma mark - PrepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue isKindOfClass:[CustomSegueForStart class]]) {
        ((CustomSegueForStart *)segue).originatingPoint = self.view.center;
    }
}


@end
