//
//  PSCommentsParser.h
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Parser.h"

@interface PSCommentsParser : Parser
@property (nonatomic,strong) NSArray *arrayOfComments;

- (NSString *)getCommentText:(NSDictionary *)dictionary;
- (NSString *)getAuthorName:(NSDictionary *)dictionary;
- (NSInteger)getCommentID:(NSDictionary *)dictionary;
- (NSInteger)getAuthorID:(NSDictionary *)dictionary;
- (NSString *)getCommentTime:(NSDictionary *)dictionary;

@end
