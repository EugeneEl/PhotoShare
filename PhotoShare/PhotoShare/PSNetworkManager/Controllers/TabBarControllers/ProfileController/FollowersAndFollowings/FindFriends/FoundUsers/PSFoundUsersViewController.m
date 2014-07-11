//
//  PSFoundUsers.m
//  PhotoShare
//
//  Created by Евгений on 10.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSFoundUsersViewController.h"
#import "PSFoundUserTableViewCell.h"
#import "PSNetworkManager.h"
#import "User.h"
#import "PSUserStore.h"
#import "User+updateFollowersAndFollowed.h"
#import "AFHTTPRequestOperation.h"
#import "User+PSGetCurrentUser.h"
#import "PSProfileViewController.h"

@interface PSFoundUsersViewController () <UITableViewDataSource, UITableViewDelegate, FoundUserTableViewCell>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, assign) int userID;

@end

@implementation PSFoundUsersViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super init];
    if (self) {
        _arrayOfUsersToDisplay=[NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView reloadData];
    _currentUser = [User getCurrentUser];
    _userID=[_currentUser.user_id integerValue];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayOfUsersToDisplay count];
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"userCell";
    PSFoundUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    User *user = [_arrayOfUsersToDisplay objectAtIndex:indexPath.row];
    [cell configureCellWithFollower:user];
    cell.delegate=self;
    return cell;
}


#pragma mark - FoundUserTableViewCell

- (void) tableViewCell:(PSFoundUserTableViewCell *)cell didSelectUser:(User *)_userToDisplay {
    //goToProfileController
    [self performSegueWithIdentifier:@"goToDetail" sender:cell];
}


- (void)foundUserTableCellFollowButtonPressed:(PSFoundUserTableViewCell *)tableCell {
    if (!tableCell.isFollowed) {
        
        [[PSNetworkManager sharedManager]
         PSFollowToUserWithID:[tableCell.foundUser.user_id intValue]
         fromUserWithID:[_currentUser.user_id intValue]
         
         
         
         
         success:^(id responseObject) {
             UIAlertView *alert=[[UIAlertView alloc ] initWithTitle:@"Ok"
                                                            message:@"follow success"
                                                           delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
             [alert show];
             [User updateFollowersAndFollowedForCurrentUser];
             NSLog(@"currentUserAfterUpdate:%@",_currentUser);
             [tableCell.followButton setBackgroundColor:[UIColor yellowColor]];
             [tableCell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
             tableCell.isFollowed=YES;
         }
         error:^(NSError *error) {
             
             /*
              [(NSHTTPURLResponse *)error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode]
              */
             
             if ([(NSHTTPURLResponse *)error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode]==401) {
                 [tableCell.followButton setBackgroundColor:[UIColor blueColor]];
                 [tableCell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
             }
             
             else
             {
                 UIAlertView *alert=[[UIAlertView alloc ] initWithTitle:@"Error"
                                                                message:[error description]
                                                               delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];

    }
    else {
        
        
        
        [[PSNetworkManager sharedManager]
         PSUnfollowUserWithID:[tableCell.foundUser.user_id intValue]
         fromUserWithID:[_currentUser.user_id intValue]
         success:^(id responseObject) {
             UIAlertView *alert=[[UIAlertView alloc ] initWithTitle:@"Ok"
                                                            message:@"unfollow success"
                                                           delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
             [alert show];
             [User updateFollowersAndFollowedForCurrentUser];
             NSLog(@"currentUserAfterUpdate:%@",_currentUser);
             [tableCell.followButton setBackgroundColor:[UIColor blueColor]];
             [tableCell.followButton setTitle:@"Follow" forState:UIControlStateNormal];
             tableCell.isFollowed=NO;
         }
         error:^(NSError *error) {
             
             /*
              [(NSHTTPURLResponse *)error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode]
              */
             
             if ([(NSHTTPURLResponse *)error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode]==401) {
                 [tableCell.followButton setBackgroundColor:[UIColor yellowColor]];
                 [tableCell.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
             }
             
             else
             {
                 UIAlertView *alert=[[UIAlertView alloc ] initWithTitle:@"Error"
                                                                message:[error description]
                                                               delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];
    }
    
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToProfileController"]) {
        
        if ([sender isKindOfClass:[PSFoundUserTableViewCell class]]) {
            PSFoundUserTableViewCell *cell = (PSFoundUserTableViewCell *) sender;
            PSProfileViewController *destinationController = segue.destinationViewController;
            destinationController.userToDisplay = cell.foundUser;
        }
    }
}



@end
