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
- (void)tableViewCell:(PSFoundUserTableViewCell *)cell didSelectUser:(User *)_userToDisplay;
@end

@interface PSFoundUserTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *followButton;
@property (nonatomic, strong) User *foundUser;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, weak)id <FoundUserTableViewCell> delegate;
- (void)configureCellWithFollower:(User *)follower;

@end
