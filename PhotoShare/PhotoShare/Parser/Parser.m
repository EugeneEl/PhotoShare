//
//  ParserID.m
//  PhotoShare
//
//  Created by Евгений on 03.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Parser.h"


static NSString *kUserIdKey=@"id";

@implementation Parser


- (instancetype) initWithId:(id)identifier {
    self = [super init];
    if (self) {
      _objectToParse =identifier;
    }
    return self;
}


- (NSInteger)getUserID {
    NSInteger userID=[[self.objectToParse valueForKey:kUserIdKey] intValue];
    NSLog(@"userID:%d",userID);
    return userID;
}


@end
