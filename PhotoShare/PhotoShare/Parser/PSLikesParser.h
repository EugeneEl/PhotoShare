//
//  PSLikesParser.h
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Parser.h"

@interface PSLikesParser : Parser
@property (nonatomic,strong) NSArray *arrayOfLikes;

- (NSString *)getAuthorEmail:(NSDictionary *)dictionary;
@end
