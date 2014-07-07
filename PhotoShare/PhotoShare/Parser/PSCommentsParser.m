//
//  PSCommentsParser.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSCommentsParser.h"

//keys for Commets JSON
static NSString *postСommentsKey=@"comments";
static NSString *commentIDKey=@"id";              //
static NSString *commentAuthorIDKey=@"author_id"; //
static NSString *commentAuthorNameKey=@"author";  //
static NSString *commentTextKey=@"text";          //
static NSString *commentTimeKey=@"tstamp";        //


@implementation PSCommentsParser

- (instancetype) initWithId:(id)identifier
{
    self = [super initWithId:identifier];
    if (self)
    {
        if([NSNull null] == [self.objectToParse valueForKey:postСommentsKey]) {
            _arrayOfComments=nil;
        }
        else {
              _arrayOfComments=[self.objectToParse valueForKey:postСommentsKey];
        }
      
    }
    return self;
}

- (NSString *)getCommentText:(NSDictionary *)dictionary
{
    NSString* commentText=[dictionary valueForKey:commentTextKey];
    NSLog(@"commentText:%@",commentText);
    return commentText;
}

- (NSString *)getAuthorName:(NSDictionary *)dictionary
{
    NSString* authorName=[dictionary valueForKey:commentAuthorNameKey];
    NSLog(@"authorName:%@",authorName);
    return authorName;
}

- (NSInteger)getCommentID:(NSDictionary *)dictionary
{
    if([NSNull null] == [dictionary objectForKey:commentIDKey]) return 0;
    
    NSInteger commentID=[[dictionary valueForKey:commentIDKey] intValue];
    NSLog(@"commentID:%d",commentID);
    return commentID;
    
}

- (NSInteger)getAuthorID:(NSDictionary *)dictionary
{
    NSInteger authorID=[[dictionary valueForKey:commentAuthorIDKey]intValue];
    NSLog(@"authorID:%d",authorID);
    return authorID;
}

- (NSString *)getCommentTime:(NSDictionary *)dictionary
{
    NSString *commentTime=[dictionary valueForKey:commentTimeKey];
    NSLog(@"commentTime:%@",commentTime);
    return commentTime;
}

@end
