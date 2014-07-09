//
//  PSPostsParser.h
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Parser.h"

@interface PSPostsParser : Parser

@property (nonatomic, strong) NSArray *arrayOfPosts;


- (NSInteger)getPostID:(NSDictionary *)dictionary;
- (NSString *)getPostImageURL:(NSDictionary *)dictionary;
- (double)getPostImageLat:(NSDictionary *)dictionary;
- (double)getPostImageLng:(NSDictionary *)dictionary;
- (NSString *)getPostImageName:(NSDictionary *)dictionary;
- (NSArray *)getPostArrayOfComments:(NSDictionary *)dictionary;;
- (NSString *)getPostTime:(NSDictionary *)dictionary;
- (NSArray *)getPostLikesArray:(NSDictionary *)dictionary;

@end
