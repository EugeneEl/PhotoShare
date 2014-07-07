//
//  PSPostsParser.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSPostsParser.h"

//keys for Post JSON
static NSString *postIdKey=@"id";
static NSString *postImageURLKey=@"img_url";
static NSString *postImageLatKey=@"lat";
static NSString *postImageLngKey=@"lng";
static NSString *postTimeKey=@"tstamp";
static NSString *postImageNameKey=@"text";
static NSString *postСommentsKey=@"comments";
static NSString *postAuthorDictionaryKey=@"author";
static NSString *postLikesArrayKey=@"likes";


@implementation PSPostsParser


//{
//    "author": {
//        "user_name": "J",
//        "id": 1,
//        "email": "black@man.com"
//    },
//    "text": "Rammmmmm!",
//    "comments": [
//                 {
//                     "text": "efdasdjhasjkdhas",
//                     "author_id": 1,
//                     "author": "J",
//                     "id": 1,
//                     "tstamp": "2014-07-03T09:36:41.445442"
//                 }
//                 ],
//    "tstamp": "2014-07-03T09:36:41.441578",
//    "likes": [
//              {
//                  "email": "skiv@mail.com"
//              }
//              ],
//    "lat": "51.586723",
//    "lng": "56.366000",
//    "img_url": "http://test.intern.yalantis.com/api/img/2",
//    "id": 1
//}

- (instancetype) initWithId:(id)identifier
{
    self = [super initWithId:identifier];
    if (self)
    {
        _arrayOfPosts=(NSArray*)[identifier allObjects];
    }
    return self;
}

#pragma mark - Post Parsing
- (NSInteger)getPostID:(NSDictionary*)dictionary
{
    NSInteger postID=[[dictionary valueForKey:postIdKey] intValue];
    NSLog(@"postID:%d",postID);
    return postID;
}

- (NSString *)getPostImageURL:(NSDictionary*)dictionary
{
    NSString *postImageURL=[dictionary valueForKey:postImageURLKey];
    NSLog(@"postIMGURL:%@",postImageURL);
    return postImageURL;
}

- (double) getPostImageLat:(NSDictionary*)dictionary
{
    double postImageLat=[[dictionary valueForKey:postImageLatKey] doubleValue];
    NSLog(@"postLat:%f",postImageLat);
    return postImageLat;
}

- (double) getPostImageLng:(NSDictionary*)dictionary
{
    double postImageLng=[[dictionary valueForKey:postImageLngKey] doubleValue];
    NSLog(@"postLng:%d",postImageLng);
    return postImageLng;
}

- (NSString *) getPostImageName:(NSDictionary*)dictionary
{
    NSString *postImageName=[dictionary valueForKey:postImageNameKey];
    NSLog(@"postImageName:%@",postImageName);
    return postImageName;
}

- (NSArray *) getPostArrayOfComments:(NSDictionary*)dictionary
{
    NSArray *comments=[dictionary valueForKey:postСommentsKey];
    NSLog(@"postComments:%@",comments);
    return comments;
}

- (NSString *) getPostTime:(NSDictionary*)dictionary
{
    NSString* postTime=[dictionary valueForKey:postTimeKey];
    NSLog(@"postTime:%@",postTime);
    return postTime;
}

- (NSArray *) getPostLikesArray:(NSDictionary *)dictionary
{
    if([NSNull null] == [dictionary valueForKey:postLikesArrayKey]) return nil;
    NSArray *postLikesArray=[dictionary valueForKey:postLikesArrayKey];
    return postLikesArray;
}

@end
