//
//  PSUserStore.h
//  PhotoShare
//
//  Created by Евгений on 11.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@class PSUserModel;

@interface PSUserStore : NSObject
@property (nonatomic,strong) User *activeUser;

+ (PSUserStore *)userStoreManager;
- (void)addActiveUserToCoreDataWithModel:(PSUserModel *) model;

@end
