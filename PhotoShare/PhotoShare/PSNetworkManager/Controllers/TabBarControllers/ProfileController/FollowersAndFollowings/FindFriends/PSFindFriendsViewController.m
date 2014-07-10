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

@interface PSFindFriendsViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
- (IBAction)actionSearch:(id)sender;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)textForSearch:(id)sender;
@property (nonatomic, assign) int userID;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, copy) NSMutableArray *arrayOfFoundUsers;
@property (nonatomic, copy) NSMutableArray *arrayToPath;

@end

@implementation PSFindFriendsViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [_searchButton setEnabled:NO];
    [_searchTextField setDelegate:self];
    _arrayToPath=[NSMutableArray array];
    
}


- (IBAction)actionSearch:(id)sender {
    [[PSNetworkManager sharedManager] findFriendsByName:_searchText
                                                success:^(id responseObject)
     {
         NSLog(@"success");
         NSLog(@"%@",responseObject);
        _arrayOfFoundUsers=[responseObject mutableCopy];
         
         for (NSDictionary *dictionary in _arrayOfFoundUsers) {
         PSUserParser *userParser=[[PSUserParser alloc]initWithId:dictionary];
         int userID=[userParser getUserID];
         User *userToAdd=[User MR_createEntity];
         if ([[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:userID] ]firstObject]) {
             userToAdd=[[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:userID] ]firstObject];
         }
             userToAdd.ava_imageURL=[userParser getAvaImageURL];
             userToAdd.name=[userParser getUserName];
             userToAdd.followed_count=[NSNumber numberWithInt:[userParser getCountOfFollowed]];
             userToAdd.follower_count=[NSNumber numberWithInt:[userParser getCountOfFollowers]];
             
             //add followers
             PSFollowersParser *followersParser=[[PSFollowersParser alloc] initWithId:responseObject];
             if (followersParser.arrayOfFollowers!=nil) {
                 for (NSDictionary *dictionary in [followersParser.arrayOfFollowers firstObject])
                 {
                    //tempory solution (array nested in another extra array)
                     User *followerToAdd=[User MR_createEntity];
                     followerToAdd.user_id=[NSNumber numberWithInt:[followersParser getFollowerID:dictionary]];
                     followerToAdd.email=[followersParser getFollowerEmail:dictionary];
                     followerToAdd.ava_imageURL=[followersParser getFollowerImageURL:dictionary];
                     followerToAdd.name=[followersParser getFollowerName:dictionary];
                     
                     [userToAdd addFollowersObject:followerToAdd];
                 }
             }
             
             //add followings
             if (followersParser.arrayOfFollowed!=nil) {
                 for (NSDictionary *dictionary in [followersParser.arrayOfFollowers firstObject])
                 {
                     User *followedToAdd=[User MR_createEntity];
                     followedToAdd.user_id=[NSNumber numberWithInt:[followersParser getFollowerID:dictionary]];
                     followedToAdd.email=[followersParser getFollowerEmail:dictionary];
                     followedToAdd.ava_imageURL=[followersParser getFollowerImageURL:dictionary];
                     followedToAdd.name=[followersParser getFollowerName:dictionary];
                     
                     [userToAdd addFollowersObject:followedToAdd];
                 }
             }
             
                [userToAdd.managedObjectContext MR_saveToPersistentStoreAndWait];
             
             [_arrayToPath addObject:userToAdd];
             [self performSegueWithIdentifier:@"goToFollow" sender:self];
         }
     }
    error:^(NSError *error) {
                                                      
                                                      UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                                                                                    message:[error localizedDescription]
                                                                                                   delegate:nil
                                                                                          cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
                                                                                          otherButtonTitles:nil, nil];
                                                      [alert show];
                                                      
                                                  }];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)textForSearch:(id)sender {
    _searchText=self.searchTextField.text;
    if ([_searchText isEqualToString:@""]) {
        [_searchButton setEnabled:NO];
    }
    else [_searchButton setEnabled:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToFollow"]) {
        
        PSFoundUsersViewController *destinationController=segue.destinationViewController;
        destinationController.arrayOfUsersToDisplay=_arrayToPath;
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
