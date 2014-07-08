//
//  PSUploadViewController.h
//  PhotoShare
//
//  Created by Евгений on 07.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSUploadViewController : UIViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) int userID;
- (instancetype)initWithImage:(UIImage *)image andUserID:(int)userID;
@end
