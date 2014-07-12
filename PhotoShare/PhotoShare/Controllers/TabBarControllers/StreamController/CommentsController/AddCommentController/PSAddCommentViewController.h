//
//  PSAddCommentViewController.h
//  PhotoShare
//
//  Created by Евгений on 09.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;

@interface PSAddCommentViewController : UIViewController
@property (nonatomic, strong) Post *postToComment;
@end
