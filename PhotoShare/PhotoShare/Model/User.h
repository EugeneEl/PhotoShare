//
//  User.h
//  PhotoShare
//
//  Created by Евгений on 08.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post, User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * ava_imageURL;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * followed_count;
@property (nonatomic, retain) NSNumber * follower_count;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * posts_count;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSSet *followed;
@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *posts;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFollowedObject:(User *)value;
- (void)removeFollowedObject:(User *)value;
- (void)addFollowed:(NSSet *)values;
- (void)removeFollowed:(NSSet *)values;

- (void)addFollowersObject:(User *)value;
- (void)removeFollowersObject:(User *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
