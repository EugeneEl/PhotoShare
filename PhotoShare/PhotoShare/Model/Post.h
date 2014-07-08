//
//  Post.h
//  PhotoShare
//
//  Created by Евгений on 08.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Like, User;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * authorMail;
@property (nonatomic, retain) NSNumber * likesCount;
@property (nonatomic, retain) NSDate * photoDate;
@property (nonatomic, retain) NSNumber * photoLocationLatitude;
@property (nonatomic, retain) NSNumber * photoLocationLongtitude;
@property (nonatomic, retain) NSString * photoName;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSNumber * postID;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *likes;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addLikesObject:(Like *)value;
- (void)removeLikesObject:(Like *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

@end
