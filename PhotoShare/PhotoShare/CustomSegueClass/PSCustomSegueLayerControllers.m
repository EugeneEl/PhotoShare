//
//  PSCustomSegueLayerControllers.m
//  PhotoShare
//
//  Created by Евгений on 25.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSCustomSegueLayerControllers.h"
#import "UIControl+BlocksKit.h"

@implementation PSCustomSegueLayerControllers
- (void)perform {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    UIViewController *destinationViewController = self.destinationViewController;
    
    UIButton *button = [[UIButton alloc] initWithFrame:window.bounds];
    button.backgroundColor = UIColor.clearColor;
    [window addSubview:button];
    
    [button bk_addEventHandler:^(UIButton *sender) {
        [sender bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:.3f
                         animations:^{
                             sender.backgroundColor = [UIColor clearColor];
                             destinationViewController.view.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             [destinationViewController.view removeFromSuperview];
                             [sender removeFromSuperview];
                             
                         }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [window addSubview:destinationViewController.view];
    destinationViewController.view.alpha = 0.f;
    
    CGFloat width = 300.f;
    CGFloat height = 380.f;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - width) / 2;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height - height) / 2;
    
    destinationViewController.view.frame = CGRectMake(x, y, width, height);
    
    [UIView animateWithDuration:.3f
                     animations:^{
                         destinationViewController.view.alpha = 1.f;
                         button.backgroundColor = [UIColor colorWithWhite:0.f alpha:.7f];
                     } completion:nil];
}


@end
