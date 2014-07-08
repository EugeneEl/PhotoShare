//
//  Like.h
//  PhotoShare
//
//  Created by Евгений on 08.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Like : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) Post *post;

@end
