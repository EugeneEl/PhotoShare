//
//  PSFollowersParser.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSFollowersParser.h"



static NSString *postsFollowersKey=@"followers"; //
static NSString *postsFollowedKey=@"followed"; //
static NSString *followerImageURLKey=@"img_url"; //
static NSString *followerIDKey=@"id";            //
static NSString *followerEmailKey=@"email";
static NSString *followerNameKey=@"user_name";



//"followers": [
//              {
//                  "img_url": "http://test.intern.yalantis.com/api/img/3",
//                  "user_name": "J",
//                  "id": 1,
//                  "email": "black@man.com"
//              }
//              ],

@implementation PSFollowersParser

- (instancetype) initWithId:(id)identifier
{
    self = [super initWithId:identifier];
    if (self)
    {
        if([NSNull null] == [self.objectToParse valueForKey:postsFollowersKey]) {
            _arrayOfFollowers=nil;
        }
        else {
              _arrayOfFollowers=[self.objectToParse valueForKey:postsFollowersKey];
        }
        
        if([NSNull null] == [self.objectToParse valueForKey:postsFollowedKey]) {
            _arrayOfFollowed=nil;
        }
        else {
      
        _arrayOfFollowed=[self.objectToParse valueForKey:postsFollowedKey];
        }
    }
    return self;
}

- (NSString *)getFollowerImageURL:(NSDictionary*)dictionary
{
    NSString *followerImageURL=[dictionary valueForKey:followerImageURLKey];
    NSLog(@"followerImageURL:%@",followerImageURL);
    return followerImageURL;
}

- (NSInteger)getFollowerID:(NSDictionary *)dictionary
{
    NSInteger followerID=[[dictionary valueForKey:followerIDKey] intValue];
    NSLog(@"followerID:%d",followerID);
    return followerID;
}

- (NSString *)getFollowerName:(NSDictionary *)dictionary
{
    NSString* followerName=[dictionary valueForKey:followerNameKey];
    NSLog(@"followerName:%@",followerName);
    return followerName;
}

- (NSString *)getFollowerEmail:(NSDictionary *)dictionary
{
    NSString* followerEmail=[dictionary valueForKey:followerEmailKey];
    NSLog(@"followerEmail:%@",followerEmail);
    return followerEmail;
}

@end
