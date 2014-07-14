//
//  PSUserStore.m
//  PhotoShare
//
//  Created by Евгений on 11.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSUserStore.h"
#import "PSUserModel.h"

@implementation PSUserStore


+ (PSUserStore *) userStoreManager {
    static PSUserStore *userStoreManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userStoreManager = [[self alloc] init];
    });
    
    return userStoreManager;
}


-(User *)activeUser {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString  *activeUserName = [defaults stringForKey:@"activeUserEmail"];
    if (![activeUserName length]) {
        NSLog(@"No active user is available");
        return nil;
    }
    else {
        return[User MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"email == %@", activeUserName]];
    }
    
}

- (void) setActiveUser:(User *)activeUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:activeUser.email forKey:@"activeUserEmail"];
    [defaults synchronize];
}

- (void)addActiveUserToCoreDataWithModel:(PSUserModel*)userModel {
    User *existingUser = [[User MR_findByAttribute:@"email" withValue:userModel.email] firstObject];
    if (!existingUser) {
        //existingUser=[User MR_createEntity];
        existingUser.email = userModel.email;
        [PSUserStore userStoreManager].activeUser = existingUser;
        NSLog(@"added active user with email:%@",[PSUserStore userStoreManager].activeUser.email);
        [existingUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    }
    else {
        NSLog(@"active user already exists");
    }
}

@end
