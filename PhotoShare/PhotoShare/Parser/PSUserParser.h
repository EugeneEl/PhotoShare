//
//  PSUserParser.h
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Parser.h"

@interface PSUserParser : Parser

- (NSInteger)getUserID;
- (NSString *)getAvaImageURL;
- (NSInteger)getCountOfFollowers;
- (NSArray *)getArrayOfFollowed;
- (NSInteger)getCountOfFollowed;
- (NSArray *)getArrayOfFollowers;

@end
