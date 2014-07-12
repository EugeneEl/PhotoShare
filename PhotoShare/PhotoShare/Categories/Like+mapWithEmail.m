//
//  Like+mapWithEmail.m
//  PhotoShare
//
//  Created by Евгений on 08.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Like+mapWithEmail.h"
#import "Like.h"

@implementation Like (mapWithEmail)
- (Like *)mapWithEmail:(NSString *)email {
    self.email=email;
    return self;
}
@end
