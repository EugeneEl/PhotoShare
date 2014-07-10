//
//  LoginViewController.m
//  PhotoShare
//
//  Created by Евгений on 10.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSLoginViewController.h"
#import "PSNetworkManager.h"
#import "PSSignUpViewController.h"
#import "PSUserStore.h"
#import "MBProgressHUD.h"
#import "PSUserModel.h"
#import "User.h"
#import "CustomSegueForStart.h"
#import "NSString+PSValidation.h"
#import "User+PSMapWithModel.h"
#import "Parser.h"
#import "PSUserParser.h"
#import "PSFollowersParser.h"

/*
@interface ParserID : NSObject
@property (nonatomic, strong) id objectToParse;

- (instancetype) initWithId:(id)identifier;

- (NSInteger) getUserID;
*/

//typedef void (^sumBlock)(NSInteger a,NSInteger b);

@class PSUserModel;

@interface PSLoginViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL  keyboardIsShown;
@property(nonatomic,assign) BOOL isRegistered;
@property (nonatomic,strong) PSUserModel* userModel;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guidingLoginConstraint;

- (IBAction)loginDidChange:(id)sender;
- (IBAction)passwordDidChange:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)dismissKeyboards:(id)sender;

@end

@implementation PSLoginViewController

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - init
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
 
    }
    return self;
}

#pragma mark - viewDidLoad
-(void)viewDidLoad {
    [super viewDidLoad];
    self.loginTextField.delegate=self;
    self.passwordTextField.delegate=self;
    self.scrollView.delegate=self;
    self.scrollView.scrollEnabled=YES;
    _keyboardIsShown = NO;
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height*1.5f)];
    [_scrollView setContentOffset:CGPointZero];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [ self.navigationController.navigationBar setHidden:NO];
    
    

}


#pragma mark - userModel
-(PSUserModel*)userModel {
    if (!_userModel)
    {
        _userModel=[PSUserModel new];
        _userModel.email=self.loginTextField.text;
        _userModel.password=self.passwordTextField.text;
    }
    return _userModel;
    
}

/*
{
 
 - (void)keyboardWasShown:(NSNotification*)aNotification {
 NSDictionary* info = [aNotification userInfo];
 CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
 CGFloat keyboardHeight = kbSize.height;
 
 
 [UIView animateWithDuration:0.3 animations:^{
 
 
 self.guidingLoginConstraint.constant = keyboardHeight + 20.f;
 [self.view layoutIfNeeded];
 
 
 [_scrollView setContentSize:CGSizeMake(320.f, 186.f)];
 [_scrollView setContentOffset:CGPointZero animated:YES];
 
 [self.view layoutIfNeeded];
 }];
 
 
 }
 
 // Called when the UIKeyboardWillHideNotification is sent
 - (void)keyboardWillBeHidden:(NSNotification*)aNotification {
 [UIView animateWithDuration:0.3 animations:^{
 _guidingLoginConstraint.constant = 0.f;
 [self.view layoutIfNeeded];
 }];
 }
 
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 [self.view endEditing:YES];
 }
 

}
*/
#pragma mark - keyboardNotification
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat keyboardHeight = kbSize.height;
    
    
    [UIView animateWithDuration:0.3 animations:^
     
    {
        self.guidingLoginConstraint.constant = keyboardHeight + 25.f;
        [self.view layoutIfNeeded];
        
        [_scrollView setContentSize:CGSizeMake(320.f, 186.f)]; //186
        [_scrollView setContentOffset:CGPointZero animated:YES];
        
        [self.view layoutIfNeeded];
    }
     
    ];
    
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.3 animations:^{
        _guidingLoginConstraint.constant = 0.f;
        [self.view layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - LoginAndSignUpMethods


- (IBAction)signUp:(id)sender {
    
}

- (IBAction)login:(id)sender {
    
    if (![self.userModel isLoginValid]) {
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:@"Error"
                            message:@"Fields must not be empty"
                            delegate:nil
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [[PSNetworkManager sharedManager] loginWithModel:_userModel
    success:^(id responseObject)
    {
        NSLog(@"success");
        weakSelf.resultLabel.text=@"Logged in";
        User *existingUserForLogin=[[User MR_findByAttribute:@"email" withValue:weakSelf.userModel.email] firstObject];
        
        NSLog(@"%@",responseObject);
        
        
        PSUserParser *userParser=[[PSUserParser alloc]initWithId:responseObject];
        
        _userModel.userID=[userParser getUserID];
        
        if (!existingUserForLogin) {
            existingUserForLogin=[User MR_createEntity];
            existingUserForLogin=[existingUserForLogin mapWithModel:weakSelf.userModel];
        }
        
        existingUserForLogin.ava_imageURL=[userParser getAvaImageURL];
        existingUserForLogin.name=[userParser getUserName];
        existingUserForLogin.follower_count=[NSNumber numberWithInt:[userParser getCountOfFollowers]];
        existingUserForLogin.followed_count= [NSNumber numberWithInt:[[userParser getArrayOfFollowed]count]];
        
        //add followers
        PSFollowersParser *followersParser=[[PSFollowersParser alloc] initWithId:responseObject];
        if (followersParser.arrayOfFollowers!=nil)
        {
            for (NSDictionary *dictionary in followersParser.arrayOfFollowers)
            {
                User *followerToAdd=[User MR_createEntity];
                followerToAdd.user_id=[NSNumber numberWithInt:[followersParser getFollowerID:dictionary]];
                followerToAdd.email=[followersParser getFollowerEmail:dictionary];
                followerToAdd.ava_imageURL=[followersParser getFollowerImageURL:dictionary];
                followerToAdd.name=[followersParser getFollowerName:dictionary];
                
                [existingUserForLogin addFollowersObject:followerToAdd];
            }
        }
        
        //add followings
        if (followersParser.arrayOfFollowed!=nil)
        {
            
            
            for (NSDictionary *dictionary in followersParser.arrayOfFollowers)
            {
                User *followedToAdd=[User MR_createEntity];
                followedToAdd.user_id=[NSNumber numberWithInt:[followersParser getFollowerID:dictionary]];
                followedToAdd.email=[followersParser getFollowerEmail:dictionary];
                followedToAdd.ava_imageURL=[followersParser getFollowerImageURL:dictionary];
                followedToAdd.name=[followersParser getFollowerName:dictionary];
                
                [existingUserForLogin addFollowersObject:followedToAdd];
            }
        }
        
        
       [existingUserForLogin.managedObjectContext MR_saveToPersistentStoreAndWait];
        
        
        NSArray *users=[User MR_findAll];
        for (User* user in users)
        {
            NSLog(@"%@id",user.user_id);
        }
        
        
        
        [PSUserStore userStoreManager].activeUser=existingUserForLogin;
        NSLog(@"active user logged in:%@",[PSUserStore userStoreManager].activeUser.email);
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [self performSegueWithIdentifier:@"goToUserBarFromLog" sender:nil];
    }
     
    error:^(NSError *error)
    {
        
    }];
    
    
    
    
}

#pragma mark - fieldsDidChanged

- (IBAction)loginDidChange:(id)sender {
    self.userModel.email=self.loginTextField.text;
    NSLog(@"login:%@",self.userModel.email);
}

- (IBAction)passwordDidChange:(id)sender {
    self.userModel.password=self.passwordTextField.text;
    NSLog(@"password:%@",self.userModel.password);
}


- (IBAction)dismissKeyboards:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - PrepareForSegueTranstion
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue isKindOfClass:[CustomSegueForStart class]])
    {
        ((CustomSegueForStart *)segue).originatingPoint = self.view.center;
    }
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if ([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];
    }
   
    else {
        [textField resignFirstResponder];
    }
    return YES;
  
}

@end
