//
//  User+updateFollowersAndFollowed.m
//  PhotoShare
//
//  Created by Евгений on 11.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "User+updateFollowersAndFollowed.h"
#import "User+PSGetCurrentUser.h"
#import "PSNetworkManager.h"
#import "PSUserParser.h"
#import "PSFollowersParser.h"

@implementation User (updateFollowersAndFollowed)

+ (void) updateFollowersAndFollowedForCurrentUser {
    int userID = [[self getCurrentUser].user_id intValue];
    User *currentUser = [self getCurrentUser];
    [[PSNetworkManager sharedManager] getInfoAboutUser:userID
    success:^(id responseObject)
    {
        NSMutableArray *arrayOfUserInfo = [NSMutableArray array];
        arrayOfUserInfo = [responseObject mutableCopy];
        PSFollowersParser *followersParser = [[PSFollowersParser alloc] initWithId:responseObject];
            //add followers
        if (followersParser.arrayOfFollowers!=nil)
        {
             for (NSDictionary *dictionary in followersParser.arrayOfFollowers)
                {
                    int followerToAddTestID = [followersParser getFollowerID:dictionary];
                    User *followerToAdd = nil;
                    if ([[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:followerToAddTestID] ]firstObject]) {
                        followerToAdd=[[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:followerToAddTestID] ]firstObject];
                    } else {
                        followerToAdd = [User MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
                    }
                    
                    followerToAdd.user_id=[NSNumber numberWithInt:[followersParser getFollowerID:dictionary]];
                    followerToAdd.email = [followersParser getFollowerEmail:dictionary];
                    followerToAdd.ava_imageURL = [followersParser getFollowerImageURL:dictionary];
                    followerToAdd.name = [followersParser getFollowerName:dictionary];
                    if (![[currentUser.followers allObjects] containsObject:followerToAdd])
                    {
                        [currentUser addFollowersObject:followerToAdd];
                        int a = [currentUser.follower_count intValue]+1;
                        currentUser.follower_count = [NSNumber numberWithInt:a];
                        NSLog(@"followerAdded");
                        for (User *user in [User MR_findAll]) {
                            NSLog(@"user_id:%d",[user.user_id intValue]);
                            
                        }
                        
                    }
                }
            }
            
            //add followings
            if (followersParser.arrayOfFollowed != nil) {
                for (NSDictionary *dictionary in followersParser.arrayOfFollowed)
                {
                    int followedToAddTestID = [followersParser getFollowerID:dictionary];
                    User *followedToAdd = nil;
                    if ([[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:followedToAddTestID] ]firstObject]) {
                        followedToAdd = [[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:followedToAddTestID] ]firstObject];
                    } else {
                        followedToAdd = [User MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
                    }
                    
                    followedToAdd.user_id = [NSNumber numberWithInt:[followersParser getFollowerID:dictionary]];
                    followedToAdd.email = [followersParser getFollowerEmail:dictionary];
                    followedToAdd.ava_imageURL = [followersParser getFollowerImageURL:dictionary];
                    followedToAdd.name = [followersParser getFollowerName:dictionary];
                    
                    
                    if (![[currentUser.followed allObjects]containsObject:followedToAdd]) {
                        [currentUser addFollowedObject:followedToAdd];
                        
                        int a = [currentUser.followed_count intValue]+1;
                        currentUser.followed_count = [NSNumber numberWithInt:a];
                        NSLog(@"followedAdded");
                        for (User *user in [User MR_findAll]) {
                            NSLog(@"user_id:%d",[user.user_id intValue]);
                            
                        }
                    }

                }
            }
        [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
    } error:^(NSError *error) {
        
    }];
}
@end
