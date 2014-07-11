//
//  User+PSGetCurrentUser.h
//  PhotoShare
//
//  Created by Евгений on 11.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "User.h"

@interface User (PSGetCurrentUser)
+ (User *)getCurrentUser;
@end
