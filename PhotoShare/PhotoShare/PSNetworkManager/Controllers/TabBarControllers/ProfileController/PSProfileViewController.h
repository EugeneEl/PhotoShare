//
//  PSProfileViewController.h
//  PhotoShare
//
//  Created by Евгений on 13.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface PSProfileViewController : UIViewController
@property (nonatomic, strong) User *userToDisplay;
@end
