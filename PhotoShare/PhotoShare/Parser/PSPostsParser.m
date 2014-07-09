//
//  PSPostsParser.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSPostsParser.h"

//keys for Post JSON
static NSString *kPostIdKey=@"id";
static NSString *kPostImageURLKey=@"img_url";
static NSString *kPostImageLatKey=@"lat";
static NSString *kPostImageLngKey=@"lng";
static NSString *kPostTimeKey=@"tstamp";
static NSString *kPostImageNameKey=@"text";
static NSString *kPostСommentsKey=@"comments";
static NSString *kPostAuthorDictionaryKey=@"author";
static NSString *kPostLikesArrayKey=@"likes";


@implementation PSPostsParser

- (instancetype) initWithId:(id)identifier {
    self = [super initWithId:identifier];
    if (self)
    {
        _arrayOfPosts=(NSArray*)[identifier allObjects];
    }
    return self;
}

#pragma mark - Post Parsing
- (NSInteger)getPostID:(NSDictionary*)dictionary {
    NSInteger postID=[[dictionary valueForKey:kPostIdKey] intValue];
    NSLog(@"postID:%d",postID);
    return postID;
}

- (NSString *)getPostImageURL:(NSDictionary*)dictionary {
    NSString *postImageURL=[dictionary valueForKey:kPostImageURLKey];
    NSLog(@"postIMGURL:%@",postImageURL);
    return postImageURL;
}

- (double) getPostImageLat:(NSDictionary*)dictionary {
    double postImageLat=[[dictionary valueForKey:kPostImageLatKey] doubleValue];
    NSLog(@"postLat:%f",postImageLat);
    return postImageLat;
}

- (double) getPostImageLng:(NSDictionary*)dictionary {
    double postImageLng=[[dictionary valueForKey:kPostImageLngKey] doubleValue];
    NSLog(@"postLng:%f",postImageLng);
    return postImageLng;
}

- (NSString *) getPostImageName:(NSDictionary*)dictionary {
    NSString *postImageName=[dictionary valueForKey:kPostImageNameKey];
    NSLog(@"postImageName:%@",postImageName);
    return postImageName;
}

- (NSArray *) getPostArrayOfComments:(NSDictionary*)dictionary {
    NSArray *comments=[dictionary valueForKey:kPostСommentsKey];
    NSLog(@"postComments:%@",comments);
    return comments;
}

- (NSString *) getPostTime:(NSDictionary*)dictionary {
    NSString* postTime=[dictionary valueForKey:kPostTimeKey];
    NSLog(@"postTime:%@",postTime);
    return postTime;
}

- (NSArray *) getPostLikesArray:(NSDictionary *)dictionary {
    if([NSNull null] == [dictionary valueForKey:kPostLikesArrayKey]) return nil;
    NSArray *postLikesArray=[dictionary valueForKey:kPostLikesArrayKey];
    return postLikesArray;
}

@end
