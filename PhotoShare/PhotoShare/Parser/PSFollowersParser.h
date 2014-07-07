//
//  PSFollowersParser.h
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Parser.h"

@interface PSFollowersParser : Parser
@property (nonatomic,strong) NSArray *arrayOfFollowers;
@property (nonatomic,strong) NSArray *arrayOfFollowed;


- (NSString *)getFollowerImageURL:(NSDictionary*)dictionary;
- (NSInteger)getFollowerID:(NSDictionary *)dictionary;
- (NSString *)getFollowerName:(NSDictionary *)dictionary;
- (NSString *)getFollowerEmail:(NSDictionary *)dictionary;

@end
