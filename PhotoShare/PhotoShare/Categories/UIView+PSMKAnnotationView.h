//
//  UIView+PSMKAnnotationView.h
//  PhotoShare
//
//  Created by Евгений on 17.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKAnnotationView;

@interface UIView (PSMKAnnotationView)
- (MKAnnotationView*)superAnnotationView;
@end
