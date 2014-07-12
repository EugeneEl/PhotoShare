//
//  User+PSMapWithModel.m
//  PhotoShare
//
//  Created by Евгений on 01.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "User+PSMapWithModel.h"
#import "PSUserModel.h"

@implementation User (PSMapWithModel)
- (User *)mapWithModel:(PSUserModel*)userModel {
    NSLog(@"(User *)mapWithModel:(PSUserModel*) userModel");
    self.email = userModel.email;
    self.password = userModel.password;
    self.name = userModel.name;
    self.user_id = [NSNumber numberWithInt:userModel.userID];
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
    return self;
}

@end
