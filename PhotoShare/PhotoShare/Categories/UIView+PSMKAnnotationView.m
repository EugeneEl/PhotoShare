//
//  UIView+PSMKAnnotationView.m
//  PhotoShare
//
//  Created by Евгений on 17.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "UIView+PSMKAnnotationView.h"
#import <MapKit/MKAnnotationView.h>

@implementation UIView (PSMKAnnotationView)

- (MKAnnotationView*)superAnnotationView {
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView*)self;
    }
    if (!self.superview) {
        return nil;
    }
    
   return  [self superAnnotationView];
}

@end
