//
//  PSLikesParser.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSLikesParser.h"
static NSString *postСommentsLikesKey=@"likes";
static NSString *likesAuthorEmailKey=@"email";

@implementation PSLikesParser


- (instancetype) initWithId:(id)identifier
{
    self = [super initWithId:identifier];
    if (self)
    {
        _arrayOfLikes=[self.objectToParse valueForKey:postСommentsLikesKey];
    }
    return self;
}

- (NSString *)getAuthorEmail:(NSDictionary *)dictionary
{
    NSString* authorEmail=[dictionary valueForKey:likesAuthorEmailKey];
    NSLog(@"likesAuthorEmail:%@",authorEmail);
    return authorEmail;
}

@end
