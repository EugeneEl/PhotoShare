//
//  ParserID.h
//  PhotoShare
//
//  Created by Евгений on 03.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject
@property (nonatomic, strong) id objectToParse;

- (instancetype)initWithId:(id)identifier;

@end
