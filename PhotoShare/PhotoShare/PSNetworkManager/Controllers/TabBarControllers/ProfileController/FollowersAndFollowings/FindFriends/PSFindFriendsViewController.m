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

@property (nonatomic, copy) NSMutableArray *arrayOfFoundUsers;
@property (nonatomic, strong) NSMutableArray *arrayToPath;
@property (nonatomic, strong) User *currentUser;

@end

@implementation PSFindFriendsViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [_searchButton setEnabled:NO];
    [_searchTextField setDelegate:self];
    _arrayToPath=[NSMutableArray array];
    PSUserStore *userStore= [PSUserStore userStoreManager];
    _currentUser=userStore.activeUser;
    
}


- (IBAction)actionSearch:(id)sender {
    [[PSNetworkManager sharedManager] findFriendsByName:_searchText
                                                success:^(id responseObject)
     {
         _arrayToPath=[NSMutableArray array];
         _arrayOfFoundID=[NSMutableArray array];
         NSLog(@"success");
         NSLog(@"%@",responseObject);
        _arrayOfFoundUsers=[responseObject mutableCopy];
         
         for (NSDictionary *dictionary in _arrayOfFoundUsers) {
             PSUserParser *userParser=[[PSUserParser alloc]initWithId:dictionary];
             int userID=[userParser getUserID];
             
             User *userToAdd;
             if ([[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:userID] ]firstObject]) {
                 userToAdd=[[User MR_findByAttribute:@"user_id" withValue:[NSNumber numberWithInt:userID] ]firstObject];
             } else {
                 userToAdd = [User MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
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
                     
//                     if ([_currentUser.user_id intValue]==[followersParser getFollowerID:dictionary]) {
//                         //working with currentUser
//                         if ([_currentUser.followed containsObject:userToAdd]) {
//                             break;
//                         }
//                     }
                     
                     //tempory solution (array nested in another extra array)
                     User *followerToAdd=[User MR_createEntityInContext:userToAdd.managedObjectContext];
                     followerToAdd.user_id=[NSNumber numberWithInt:[followersParser getFollowerID:dictionary]];
                     followerToAdd.email=[followersParser getFollowerEmail:dictionary];
                     followerToAdd.ava_imageURL=[followersParser getFollowerImageURL:dictionary];
                     followerToAdd.name=[followersParser getFollowerName:dictionary];
                     
//                     NSMutableArray *array=[NSMutableArray arrayWithArray: [userToAdd.followers allObjects]];
//                     [array addObject:followerToAdd];
//                     userToAdd.followers = [NSSet setWithArray:array];
                     
                     if (![userToAdd.followers containsObject:followerToAdd]) {
                         [userToAdd addFollowersObject:followerToAdd];
                     }
                     
                     
//                     NSMutableArray *array1 = [NSMutableArray arrayWithArray:[followerToAdd.followers allObjects]];
//                     [array1 addObject:userToAdd];
//                     followerToAdd.followers=[NSSet setWithArray:array1];
            
                    
                     
                 }
             }
             
             //add followings
             if (followersParser.arrayOfFollowed!=nil) {
                 for (NSDictionary *dictionary in [followersParser.arrayOfFollowed firstObject])
                 {
                     
//                     
//                     if ([_currentUser.user_id intValue]==[followersParser getFollowerID:dictionary]) {
//                         //working with currentUser
//                         if ([_currentUser.followers containsObject:userToAdd]) {
//                             break;
//                         }
//                     }
                     User *followedToAdd=[User MR_createEntityInContext:userToAdd.managedObjectContext];
                     followedToAdd.user_id=[NSNumber numberWithInt:[followersParser getFollowerID:dictionary]];
                     followedToAdd.email=[followersParser getFollowerEmail:dictionary];
                     followedToAdd.ava_imageURL=[followersParser getFollowerImageURL:dictionary];
                     followedToAdd.name=[followersParser getFollowerName:dictionary];
                     
                     
                     if (![userToAdd.followed containsObject:followedToAdd]) {
                         [userToAdd addFollowedObject:followedToAdd];
                     }
                     
                    // [userToAdd addFollowersObject:followedToAdd];
//                     [followedToAdd addFollowedObject:userToAdd];
                 }
             }
         
             [userToAdd.managedObjectContext MR_saveToPersistentStoreAndWait];
            // [_currentUser.managedObjectContext MR_saveToPersistentStoreAndWait];
             
             [_arrayToPath addObject:userToAdd];
             [_arrayOfFoundID addObject:userToAdd.user_id];
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
        destinationController.arrayOfUsersToDisplay=_arrayOfFoundID;
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
