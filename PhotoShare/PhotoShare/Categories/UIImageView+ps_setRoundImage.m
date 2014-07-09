//
//  UIImageView+ps_setRoundImage.m
//  PhotoShare
//
//  Created by Евгений on 01.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

//delete
#import "UIImageView+ps_setRoundImage.h"

@implementation UIImageView (ps_setRoundImage)

- (void)ps_setRoundImage:(UIImage *)image animated:(BOOL)animated
{
 
    CGRect rect = self.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, UIScreen.mainScreen.scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:rect.size.width/2.0f] addClip];
    [image drawInRect:rect];
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [[UIColor whiteColor] setStroke];
    path.lineWidth = 2.f;
    
    [path stroke];
    
    self.alpha = 0.f;
    
    [UIView animateWithDuration:animated ? .3f : 0.f animations:^
    {
        self.image = UIGraphicsGetImageFromCurrentImageContext();
        self.alpha = 1.f;
    }];
    
    
    
    UIGraphicsEndImageContext();
}


@end
