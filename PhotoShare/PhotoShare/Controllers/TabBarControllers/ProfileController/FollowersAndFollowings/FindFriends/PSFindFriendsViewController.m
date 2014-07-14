//
//  PSFindFriendsViewController.m
//  PhotoShare
//
//  Created by Евгений on 10.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSFindFriendsViewController.h"
#import "PSNetworkManager.h"
#import "User.h"
#import "PSUserParser.h"
#import "PSFollowersParser.h"
#import "User+PSMapWithModel.h"
#import "PSUserModel.h"
#import "PSFoundUsersViewController.h"
#import "PSUserStore.h"

@interface PSFindFriendsViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
- (IBAction)actionSearch:(id)sender;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)textForSearch:(id)sender;
@property (nonatomic, assign) int userID;
@property (nonatomic, strong) NSMutableArray *arrayOfFoundID;
@property (nonatomic, strong) NSMutableArray *arrayOfFoundUsers;
@property (nonatomic, strong) NSMutableArray *arrayToPass;
@property (nonatomic, strong) User *currentUser;

@end

@implementation PSFindFriendsViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    [_searchButton setEnabled:NO];
    [_searchTextField setDelegate:self];
    _arrayToPass = [NSMutableArray array];
    PSUserStore *userStore = [PSUserStore userStoreManager];
    _currentUser = userStore.activeUser;
    
}

#pragma mark - searchForFriends
- (IBAction)actionSearch:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [[PSNetworkManager sharedManager] findFriendsByName:_searchText
    success:^(id responseObject)
     {
         weakSelf.arrayToPass = [NSMutableArray array];
         weakSelf.arrayOfFoundID = [NSMutableArray array];
         NSLog(@"success");
         NSLog(@"%@",responseObject);
        weakSelf.arrayOfFoundUsers = [responseObject mutableCopy];
         
         for (NSDictionary *dictionary in _arrayOfFoundUsers) {
             PSUserParser *userParser = [[PSUserParser alloc]initWithId:dictionary];
             
             
             NSLog(@"newLOOP\n");
             for (User *user in [User MR_findAll]) {
                 NSLog(@"user_id:%d",[user.user_id intValue]);
                 
             }
             
             
             int userID=[userParser getUserID];
             User *userToAdd = nil;
             if ([[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:userID] ]firstObject]) {
                 userToAdd = [[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:userID] ]firstObject];
             } else {
                 userToAdd = [User MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
             }
             userToAdd.ava_imageURL=[userParser getAvaImageURL];
             userToAdd.name = [userParser getUserName];
             userToAdd.followed_count = [NSNumber numberWithInt:[userParser getCountOfFollowed]];
             userToAdd.follower_count = [NSNumber numberWithInt:[userParser getCountOfFollowers]];
             userToAdd.user_id = [NSNumber numberWithInt:[userParser getUserID]];
             
             //add followers
             PSFollowersParser *followersParser = [[PSFollowersParser alloc] initWithId:responseObject];
             if (followersParser.arrayOfFollowers) {
                 for (NSDictionary *dictionary in [followersParser.arrayOfFollowers firstObject])
                 {
                    
                     int followerToAddTestID = [followersParser getFollowerID:dictionary];
                     User *followerToAdd = nil;
                     if ([[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:followerToAddTestID] ]firstObject]) {
                         followerToAdd = [[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:followerToAddTestID] ]firstObject];
                     } else {
                         followerToAdd = [User MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
                     }

                     followerToAdd.user_id = [NSNumber numberWithInt:[followersParser getFollowerID:dictionary]];
                     followerToAdd.email = [followersParser getFollowerEmail:dictionary];
                     followerToAdd.ava_imageURL = [followersParser getFollowerImageURL:dictionary];
                     followerToAdd.name = [followersParser getFollowerName:dictionary];
                     
                     if (![[userToAdd.followers allObjects] containsObject:followerToAdd]) {
                         [userToAdd addFollowersObject:followerToAdd];
                         
                         NSLog(@"followerAdded");
                         for (User *user in [User MR_findAll]) {
                             NSLog(@"user_id:%d",[user.user_id intValue]);
                             
                         }
                               
                     }
                 }
             }
             
             //add followings
             if (followersParser.arrayOfFollowed) {
                 for (NSDictionary *dictionary in [followersParser.arrayOfFollowed firstObject])
                 {
                     int followedToAddTestID = [followersParser getFollowerID:dictionary];
                     User *followedToAdd = nil;
                     if ([[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:followedToAddTestID] ]firstObject]) {
                         followedToAdd = [[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:followedToAddTestID] ]firstObject];
                     } else {
                         followedToAdd = [User MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
                     }

                     followedToAdd.user_id = [NSNumber numberWithInt:[followersParser getFollowerID:dictionary]];
                     followedToAdd.email = [followersParser getFollowerEmail:dictionary];
                     followedToAdd.ava_imageURL = [followersParser getFollowerImageURL:dictionary];
                     followedToAdd.name = [followersParser getFollowerName:dictionary];
                     
                     
                     if (![[userToAdd.followed allObjects]containsObject:followedToAdd]) {
                         [userToAdd addFollowedObject:followedToAdd];
                         NSLog(@"followedAdded");
                         for (User *user in [User MR_findAll]) {
                             NSLog(@"user_id:%d",[user.user_id intValue]);
                             
                         }
                     }
                     
                    // [userToAdd addFollowersObject:followedToAdd];
//                     [followedToAdd addFollowedObject:userToAdd];
                 }
             }
             
             NSLog(@"Before save");
             for (User *user in [User MR_findAll]) {
                 NSLog(@"user_id:%d",[user.user_id intValue]);
                 
             }
             
             [userToAdd.managedObjectContext MR_saveToPersistentStoreAndWait];
             
             NSLog(@"after save");
             for (User *user in [User MR_findAll]) {
                 NSLog(@"user_id:%d",[user.user_id intValue]);
                 
             }
             
             [weakSelf.arrayToPass addObject:userToAdd];
             [weakSelf.arrayOfFoundID addObject:userToAdd.user_id];
             [weakSelf performSegueWithIdentifier:@"goToFollow" sender:self];
         }
     }
    error:^(NSError *error)
    {
                                                      
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                           message:[error localizedDescription]
                           delegate:nil
                           cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
                            otherButtonTitles:nil, nil];
                            [alert show];
                                                      
   }];
}

#pragma mark - DismissLKeyboard
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)textForSearch:(id)sender {
    _searchText = self.searchTextField.text;
    if ([_searchText isEqualToString:@""]) {
        [_searchButton setEnabled:NO];
    }
    else [_searchButton setEnabled:YES];
}


#pragma mark - prepareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToFollow"]) {
        
        PSFoundUsersViewController *destinationController = segue.destinationViewController;
        destinationController.arrayOfUsersToDisplay = _arrayToPass;
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField; {
    if ([textField isEqual:_searchTextField]) {
        [textField resignFirstResponder];
    }
    return YES;
    
}

@end
