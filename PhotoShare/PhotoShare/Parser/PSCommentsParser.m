//
//  PSCommentsParser.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSCommentsParser.h"

//keys for Commets JSON
static NSString *kPostСommentsKey=@"comments";
static NSString *kCommentIDKey=@"id";              //
static NSString *kCommentAuthorIDKey=@"author_id"; //
static NSString *kCommentAuthorNameKey=@"author";  //
static NSString *kCommentTextKey=@"text";          //
static NSString *kCommentTimeKey=@"tstamp";        //


@implementation PSCommentsParser

- (instancetype) initWithId:(id)identifier {
    self = [super initWithId:identifier];
    if (self)
    {
        if([NSNull null] == [self.objectToParse valueForKey:kPostСommentsKey]) {
            _arrayOfComments=nil;
        }
         else {
             _arrayOfComments=[self.objectToParse valueForKey:kPostСommentsKey];
         }
      
    }
    return self;
}

- (NSString *)getCommentText:(NSDictionary *)dictionary {
    NSString* commentText=[dictionary valueForKey:kCommentTextKey];
    NSLog(@"commentText:%@",commentText);
    return commentText;
}

- (NSString *)getAuthorName:(NSDictionary *)dictionary {
    NSString* authorName=[dictionary valueForKey:kCommentAuthorNameKey];
    NSLog(@"authorName:%@",authorName);
    return authorName;
}

- (NSInteger)getCommentID:(NSDictionary *)dictionary {
    if([NSNull null] == [dictionary objectForKey:kCommentIDKey]) return 0;
    
    NSInteger commentID=[[dictionary valueForKey:kCommentIDKey] intValue];
    NSLog(@"commentID:%d",commentID);
    return commentID;
}

- (NSInteger)getAuthorID:(NSDictionary *)dictionary {
    NSInteger authorID=[[dictionary valueForKey:kCommentAuthorIDKey]intValue];
    NSLog(@"authorID:%d",authorID);
    return authorID;
}

- (NSString *)getCommentTime:(NSDictionary *)dictionary {
    NSString *commentTime=[dictionary valueForKey:kCommentTimeKey];
    NSLog(@"commentTime:%@",commentTime);
    return commentTime;
}

@end
