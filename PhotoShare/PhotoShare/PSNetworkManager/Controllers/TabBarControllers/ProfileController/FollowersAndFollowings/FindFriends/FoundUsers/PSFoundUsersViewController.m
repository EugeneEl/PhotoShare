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
    PSUserStore *userStore= [PSUserStore userStoreManager];
    _currentUser=userStore.activeUser;
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
- (void)foundUserTableCellFollowButtonPressed:(PSFoundUserTableViewCell *)tableCell {
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
    }
    error:^(NSError *error) {
        
        /*
         [(NSHTTPURLResponse *)error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode]
         */
        
        if ([(NSHTTPURLResponse *)error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode]==401) {
            
        }
        
        
        
        
        
//        NSLog(@"error:%@",error);
//        if (error.code == 401) {
//            UIAlertView *alert=[[UIAlertView alloc ] initWithTitle:@"Error"
//                                                           message:@"You already follow this user"
//                                                          delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
//            [alert show];
//        }
        else
        {
        UIAlertView *alert=[[UIAlertView alloc ] initWithTitle:@"Error"
        message:[error description]
                                                      delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        }
    }];
    
    
}

#pragma mark - NSFetchedResultsControllerDelegate



#pragma mark - UITableViewDelegate







@end
