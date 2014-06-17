//
//  Post.h
//  PhotoShare
//
//  Created by Евгений on 17.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * authorMail;
@property (nonatomic, retain) NSNumber * likes;
@property (nonatomic, retain) NSDate * photoDate;
@property (nonatomic, retain) NSString * photoName;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSNumber * postID;
@property (nonatomic, retain) NSNumber * photoLocationLatitude;
@property (nonatomic, retain) NSNumber * photoLocationLongtitude;
@property (nonatomic, retain) NSSet *comments;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
