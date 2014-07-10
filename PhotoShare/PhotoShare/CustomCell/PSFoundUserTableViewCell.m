//
//  PSFoundUserTableViewCell.m
//  PhotoShare
//
//  Created by Евгений on 10.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSFoundUserTableViewCell.h"
#import "User.h"

@interface PSFoundUserTableViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *avaImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *followButton;
@property (nonatomic, weak) IBOutlet UIButton *actionFollow;
@property (nonatomic, weak) IBOutlet UILabel *followsMeLabel;
@property (nonatomic, assign) BOOL isFollowed;
@end


@implementation PSFoundUserTableViewCell

- (void)configureCellWithFollower:(User *)follower
{
    
}



@end
