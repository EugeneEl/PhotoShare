//
//  PSLikesParser.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSLikesParser.h"
static NSString *kPostСommentsLikesKey=@"likes";
static NSString *kLikesAuthorEmailKey=@"email";

@implementation PSLikesParser

#pragma mark - initWithId
- (instancetype) initWithId:(id)identifier {
    self = [super initWithId:identifier];
    if (self) {
        _arrayOfLikes=[self.objectToParse valueForKey:kPostСommentsLikesKey];
    }
    return self;
}

#pragma mark - likesParser
- (NSString *)getAuthorEmail:(NSDictionary *)dictionary {
    NSString* authorEmail=[dictionary valueForKey:kLikesAuthorEmailKey];
    NSLog(@"likesAuthorEmail:%@",authorEmail);
    return authorEmail;
}

@end
