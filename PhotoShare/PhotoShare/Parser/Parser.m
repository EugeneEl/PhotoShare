//
//  ParserID.m
//  PhotoShare
//
//  Created by Евгений on 03.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Parser.h"

//keys for User JSON
static NSString *userIdKey=@"id";




//keys for Comments
static NSString *commentIdKey=@"id";
static NSString *commentTimeKey=@"tstamp";
static NSString *commentAuthorNameKey=@"author";
static NSString *commentAuthorIDKey=@"author_id";
static NSString *commentTextKey=@"text";

//keys for Likes
static NSString *likesAuthorMailKey=@"email";

@implementation Parser


- (NSInteger) getUserID
{
    NSInteger userID=[[self.objectToParse valueForKey:userIdKey] intValue];
    NSLog(@"userID:%d",userID);
    return userID;
}




#pragma mark Comments Parsing
- (NSString *) getCommentAuthorEmailKey
{
    NSString *authorEmail=[self.objectToParse valueForKey:commentAuthorNameKey];
    NSLog(@"commentAuthorEmail:%@",authorEmail);
    return authorEmail;
}





//keys for Comments

- (instancetype) initWithId:(id)identifier
{
    self = [super init];
    if (self)
    {
        _objectToParse =identifier;
    }
    return self;
}




@end
