//
//  PSFoundUserTableViewCell.m
//  PhotoShare
//
//  Created by Евгений on 10.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSFoundUserTableViewCell.h"
#import "User.h"
#import "PSUserStore.h"

@interface PSFoundUserTableViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *avaImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *followButton;
@property (nonatomic, weak) IBOutlet UIButton *actionFollow;
@property (nonatomic, weak) IBOutlet UILabel *followsMeLabel;
@property (nonatomic, assign) BOOL isFollowed;
@property (nonatomic, assign) int userID;
@property (nonatomic, strong) User *currentUser;

@end


@implementation PSFoundUserTableViewCell

- (void)configureCellWithFollower:(User *)follower {

    PSUserStore *userStore= [PSUserStore userStoreManager];
    _currentUser=userStore.activeUser;
    _userID=[_currentUser.user_id integerValue];
    
    [_userNameLabel setText:follower.name];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void)
                   {
                       
                       NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:follower.ava_imageURL]];
                       
                       UIImage* image = [[UIImage alloc] initWithData:imageData];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [_avaImageView setImage:image];
                                          [_avaImageView setNeedsLayout]; //test here
                                      });
                   });
    //if he/she follows me
    if ([_currentUser.followed containsObject:follower]) {
        [_followButton setBackgroundColor:[UIColor redColor]];
        [_followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        _isFollowed=YES;
        
       
    }
    else {
        [_followButton setBackgroundColor:[UIColor blueColor]];
        [_followButton setTitle:@"follow" forState:UIControlStateNormal];
        _isFollowed=NO;
        
        
      
    }
    
    //if I follow she/he
    if ([follower.followers containsObject:_currentUser]) {
        [_followsMeLabel setHidden:NO];
    }
    else {
        [_followsMeLabel setHidden:YES];
    }
    
}

- (IBAction)actionFollow:(id)sender {
       [self.delegate foundUserTableCellFollowButtonPressed:self];
}


@end
