//
//  PSSignUpViewController.m
//  PhotoShare
//
//  Created by Евгений on 11.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSSignUpViewController.h"
#import "PSNetworkManager.h"
#import "PSUserStore.h"
#import "MBProgressHUD.h"
#import "PSUserModel.h"

@interface PSSignUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameForSignUpTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailForSignUpTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordForSignUpTextField;
@property (weak, nonatomic) IBOutlet UITextField *facebookIDTextField;

@property (strong,nonatomic) PSUserModel *userModel;

- (IBAction)nameFieldDidChanged:(id)sender;
- (IBAction)emailFieldDidChanged:(id)sender;
- (IBAction)passwordFieldDidChanged:(id)sender;
- (IBAction)facebookIDFieldDidChanged:(id)sender;
- (IBAction)dismissAllKeyboards:(id)sender;
- (IBAction)doneSignUp:(id)sender;

- (BOOL) validateUserModel:(PSUserModel*) userModel;

@end

@implementation PSSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
    [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.facebookIDTextField.inputAccessoryView = numberToolbar;
    
    [self.nameForSignUpTextField becomeFirstResponder];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


-(PSUserModel*)userModel {
    if (!_userModel)
    {
        _userModel=[PSUserModel new];
        _userModel.name=self.nameForSignUpTextField.text;
        _userModel.email=self.emailForSignUpTextField.text;
        _userModel.password=self.passwordForSignUpTextField.text;
        _userModel.facebookId=self.facebookIDTextField.text;
    }
    return _userModel;
    
}


#pragma mark - fieldsDidChanged
- (IBAction)nameFieldDidChanged:(id)sender {
    _userModel.name=self.nameForSignUpTextField.text;
}

- (IBAction)emailFieldDidChanged:(id)sender {
    _userModel.email=self.emailForSignUpTextField.text;
}

- (IBAction)passwordFieldDidChanged:(id)sender {
    _userModel.password=self.passwordForSignUpTextField.text;
}

- (IBAction)facebookIDFieldDidChanged:(id)sender {
    _userModel.facebookId=_facebookIDTextField.text;
}


#pragma mark - dismissKeyboards
- (IBAction)dismissAllKeyboards:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - signUp
- (IBAction)doneSignUp:(id)sender
{
    
    if (![self.userModel isSignUpValid]) {
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:@"Error"
                            message:@"Fields must not be empty"
                            delegate:nil
                            cancelButtonTitle:@"Ok"
                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [[PSNetworkManager sharedManager]signUpModel:self.userModel
     
     
    success:^{
    NSLog(@"success");
    __weak typeof(self) weakSelf = self;
    [[PSUserStore userStoreManager] addActiveUserToCoreDataWithModel:weakSelf.userModel];
                                                 
   [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
     
    error:^(NSError *error)
     {
         NSString *errorDescription=[error description];
         NSLog(@"error:%@",errorDescription);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         UIAlertView *alertOnError=[[UIAlertView alloc]
                                    initWithTitle:@"Error!"
                                    message:errorDescription
                                    delegate:self
                                    cancelButtonTitle:@"Ok"
                                    otherButtonTitles:nil];
         [alertOnError show];
     }];
}

#pragma mark - MethodsForTextFieldKeyboard
-(void)cancelNumberPad{
    [self.facebookIDTextField resignFirstResponder];
}

-(void)doneWithNumberPad{
    NSString *numberFromTheKeyboard = self.facebookIDTextField.text;
    [self.facebookIDTextField resignFirstResponder];
    
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    
    if ([textField isEqual:self.nameForSignUpTextField]) {
        [self.emailForSignUpTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.emailForSignUpTextField]) {
        [self.passwordForSignUpTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.passwordForSignUpTextField]) {
        [self.facebookIDTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
    
}

@end
