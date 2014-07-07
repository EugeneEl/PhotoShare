//
//  PSUserParser.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSUserParser.h"

static NSString *userIdKey=@"id";
static NSString *userCountOfFollowersKey=@"cnt_followers";
static NSString *userCountOfFollowedKey=@"cnt_followed";
static NSString *userArrayOfFollowersKey=@"followers";
static NSString *userArrayOfFollowedKey=@"followed";
static NSString *userAvaImageURLKey=@"img_url";


@implementation PSUserParser


- (NSInteger)getUserID
{
    NSInteger userID=[[self.objectToParse valueForKey:userIdKey] intValue];
    NSLog(@"userID:%d",userID);
    return userID;
}

- (NSInteger)getCountOfFollowers
{
    if([NSNull null] == [self.objectToParse valueForKey:userCountOfFollowersKey]) return 0;
    NSInteger countOfFollowers=[[self.objectToParse valueForKey:userCountOfFollowersKey] intValue];
    return countOfFollowers;
}

- (NSInteger)getCountOfFollowed
{
     if([NSNull null] == [self.objectToParse valueForKey:userCountOfFollowedKey]) return 0;
    NSInteger countOfFollowed=[[self.objectToParse valueForKey:userCountOfFollowedKey] intValue];
    return countOfFollowed;
}



- (NSArray *)getArrayOfFollowers
{
    if([NSNull null] == [self.objectToParse valueForKey:userArrayOfFollowersKey]) return nil;
    NSArray *arrayOfFollowers=[self.objectToParse valueForKey:userArrayOfFollowersKey];
    return arrayOfFollowers;
}



- (NSArray *)getArrayOfFollowed
{
    if([NSNull null] == [self.objectToParse valueForKey:userArrayOfFollowedKey]) return nil;
    NSArray *arrayOfFollowed=[self.objectToParse valueForKey:userArrayOfFollowedKey];
    return arrayOfFollowed;
}


- (NSString *)getAvaImageURL
{
    if([NSNull null] == [self.objectToParse valueForKey:userAvaImageURLKey]) return nil;
    NSString *avaImageURL=[self.objectToParse valueForKey:userAvaImageURLKey];
    return avaImageURL;
}

@end
