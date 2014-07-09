//
//  User+PSMapWithModel.h
//  PhotoShare
//
//  Created by Евгений on 01.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "User.h"
@class PSUserModel;

@interface User (PSMapWithModel)
- (User *)mapWithModel:(PSUserModel*)userModel;
@end
