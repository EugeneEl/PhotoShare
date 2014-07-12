//
//  PSFollowersParser.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSFollowersParser.h"



static NSString *kPostsFollowersKey=@"followers"; //
static NSString *kPostsFollowedKey=@"followed"; //
static NSString *kFollowerImageURLKey=@"img_url"; //
static NSString *kFollowerIDKey=@"id";            //
static NSString *kFollowerEmailKey=@"email";
static NSString *kFollowerNameKey=@"user_name";



@implementation PSFollowersParser

- (instancetype) initWithId:(id)identifier {
    self = [super initWithId:identifier];
    if (self) {
        if([NSNull null] == [self.objectToParse valueForKey:kPostsFollowersKey]) {
            _arrayOfFollowers=nil;
        }
        else {
              _arrayOfFollowers=[self.objectToParse valueForKey:kPostsFollowersKey];
        }
        
        if([NSNull null] == [self.objectToParse valueForKey:kPostsFollowedKey]) {
            _arrayOfFollowed=nil;
        }
        else {
      
        _arrayOfFollowed=[self.objectToParse valueForKey:kPostsFollowedKey];
        }
    }
    return self;
}



- (NSString *)getFollowerImageURL:(NSDictionary *)dictionary {
    
    if ([NSNull null]==[dictionary valueForKey:kFollowerImageURLKey]) {
        return nil;
    }
    
    NSString *followerImageURL=[dictionary valueForKey:kFollowerImageURLKey];
    NSLog(@"followerImageURL:%@",followerImageURL);
    return followerImageURL;
}

- (NSInteger)getFollowerID:(NSDictionary *)dictionary {
    NSInteger followerID=[NSNumber numberWithInt:[dictionary valueForKey:kFollowerIDKey]];
    NSLog(@"followerID:%d",followerID);
    return followerID;
}

- (NSString *)getFollowerName:(NSDictionary *)dictionary {
    NSString* followerName=[dictionary valueForKey:kFollowerNameKey];
    NSLog(@"followerName:%@",followerName);
    return followerName;
}

- (NSString *)getFollowerEmail:(NSDictionary *)dictionary {
    NSString* followerEmail=[dictionary valueForKey:kFollowerEmailKey];
    NSLog(@"followerEmail:%@",followerEmail);
    return followerEmail;
}

@end
