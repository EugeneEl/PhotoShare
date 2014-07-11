//
//  PSFoundUserTableViewCell.h
//  PhotoShare
//
//  Created by Евгений on 10.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSFoundUserTableViewCell;
@class User;

@protocol FoundUserTableViewCell;
@protocol FoundUserTableViewCell <NSObject>
@optional

- (void)foundUserTableCellFollowButtonPressed:(PSFoundUserTableViewCell *)tableCell;
@end

@interface PSFoundUserTableViewCell : UITableViewCell
@property(nonatomic, weak)id <FoundUserTableViewCell> delegate;
- (void)configureCellWithFollower:(User *)follower;
@property (nonatomic, strong) User *foundUser;

@end
