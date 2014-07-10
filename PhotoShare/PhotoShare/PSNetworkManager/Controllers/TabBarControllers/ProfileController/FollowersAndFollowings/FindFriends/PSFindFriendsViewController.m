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

@interface PSFindFriendsViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
- (IBAction)actionSearch:(id)sender;
@property (nonatomic, weak) NSString *searchText;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)textForSearch:(id)sender;
@property (nonatomic, assign) int userID;
@property (nonatomic, strong) User *currentUser;

@end

@implementation PSFindFriendsViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [_searchButton setEnabled:NO];
    [_searchTextField setDelegate:self];
}


- (IBAction)actionSearch:(id)sender {
    [[PSNetworkManager sharedManager] findFriendsByName:_searchText
                                                success:^(id responseObject)
     {
         NSLog(@"success");
         NSLog(@"%@",responseObject);
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

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if ([textField isEqual:_searchTextField]) {
        [textField resignFirstResponder];
    }
    return YES;
    
}

@end
