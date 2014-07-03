//
//  User.h
//  PhotoShare
//
//  Created by Евгений on 03.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * follower_count;
@property (nonatomic, retain) NSNumber * followed_count;
@property (nonatomic, retain) NSNumber * posts_count;
@property (nonatomic, retain) NSNumber * user_id;

@end
