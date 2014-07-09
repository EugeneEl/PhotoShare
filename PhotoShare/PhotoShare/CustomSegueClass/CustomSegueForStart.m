//
//  CustomSegueForStart.m
//  PhotoShare
//
//  Created by Евгений on 12.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "CustomSegueForStart.h"

@implementation CustomSegueForStart

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    [sourceViewController.view addSubview:destinationViewController.view];
    destinationViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
    CGPoint originalCenter = destinationViewController.view.center;
    destinationViewController.view.center = self.originatingPoint;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         destinationViewController.view.center = originalCenter;
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview];
                         [sourceViewController presentViewController:destinationViewController animated:NO completion:NULL];
                     }];
}

@end
