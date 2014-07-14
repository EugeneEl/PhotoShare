//
//  PSUserParser.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSUserParser.h"

static NSString *kUserIdKey=@"id";
static NSString *kUserCountOfFollowersKey=@"cnt_followers";
static NSString *kUserCountOfFollowedKey=@"cnt_followed";
static NSString *kUserArrayOfFollowersKey=@"followers";
static NSString *kUserArrayOfFollowedKey=@"followed";
static NSString *kUserAvaImageURLKey=@"img_url";
static NSString *kUserNameKey=@"user_name";
static NSString *kUserPasswordKey=@"password";

@implementation PSUserParser

#pragma mark - userParser
- (NSInteger)getUserID {
    NSInteger userID = [[self.objectToParse valueForKey:kUserIdKey] intValue];
    NSLog(@"userID:%d",userID);
    return userID;
}

- (NSInteger)getCountOfFollowers {
    if([NSNull null] == [self.objectToParse valueForKey:kUserCountOfFollowersKey]) return 0;
    NSInteger countOfFollowers=[[self.objectToParse valueForKey:kUserCountOfFollowersKey] intValue];
    return countOfFollowers;
}

- (NSInteger)getCountOfFollowed {
     if([NSNull null] == [self.objectToParse valueForKey:kUserCountOfFollowedKey]) return 0;
    NSInteger countOfFollowed=[[self.objectToParse valueForKey:kUserCountOfFollowedKey] intValue];
    return countOfFollowed;
}


- (NSArray *)getArrayOfFollowers {
    if([NSNull null] == [self.objectToParse valueForKey:kUserArrayOfFollowersKey]) return nil;
    NSArray *arrayOfFollowers=[self.objectToParse valueForKey:kUserArrayOfFollowersKey];
    return arrayOfFollowers;
}


- (NSArray *)getArrayOfFollowed {
    if([NSNull null] == [self.objectToParse valueForKey:kUserArrayOfFollowedKey]) return nil;
    NSArray *arrayOfFollowed=[self.objectToParse valueForKey:kUserArrayOfFollowedKey];
    return arrayOfFollowed;
}


- (NSString *)getAvaImageURL {
    if([NSNull null] == [self.objectToParse valueForKey:kUserAvaImageURLKey]) return nil;
    NSString *avaImageURL=[self.objectToParse valueForKey:kUserAvaImageURLKey];
    return avaImageURL;
}


- (NSString *)getUserName {
    if([NSNull null] == [self.objectToParse valueForKey:kUserNameKey]) return nil;
    NSString *userName=[self.objectToParse valueForKey:kUserNameKey];
    return userName;
}

- (NSString *)getUserPassword {
    if([NSNull null] == [self.objectToParse valueForKey:kUserPasswordKey]) return nil;
    NSString *userPassword=[self.objectToParse valueForKey:kUserPasswordKey];
    return userPassword;
}

@end
