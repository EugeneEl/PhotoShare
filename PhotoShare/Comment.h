//
//  Comment.h
//  PhotoShare
//
//  Created by Евгений on 17.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * commentatorName;
@property (nonatomic, retain) NSDate * commentDate;
@property (nonatomic, retain) NSNumber * commentID;
@property (nonatomic, retain) NSString * commentText;
@property (nonatomic, retain) Post *post;

@end
