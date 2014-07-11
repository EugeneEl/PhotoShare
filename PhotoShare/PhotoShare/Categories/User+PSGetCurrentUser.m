//
//  User+PSGetCurrentUser.m
//  PhotoShare
//
//  Created by Евгений on 11.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "User+PSGetCurrentUser.h"
#import "PSUserStore.h"

@implementation User (PSGetCurrentUser)

- (User *)getCurrentUser {
    PSUserStore *userStore = [PSUserStore userStoreManager];
    return userStore.activeUser;
}

@end
