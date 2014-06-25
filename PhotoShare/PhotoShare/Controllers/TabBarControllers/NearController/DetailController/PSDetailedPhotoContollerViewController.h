//
//  PSDetailedPhotoContollerViewController.h
//  PhotoShare
//
//  Created by Евгений on 20.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;

@interface PSDetailedPhotoContollerViewController : UIViewController

@property (nonatomic, strong) Post *post;
- (instancetype)initWithPost:(Post *)post;

@end
