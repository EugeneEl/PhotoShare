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

@interface PSSignUpViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (strong,nonatomic) PSUserModel *userModel;
@property (weak, nonatomic) UITextField *activeTextField;
@property (nonatomic, assign) BOOL  keyboardIsShown;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guidingConstraint;
@property (weak, nonatomic) IBOutlet UITextField *nameForSignUpTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailForSignUpTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordForSignUpTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)nameFieldDidChanged:(id)sender;
- (IBAction)emailFieldDidChanged:(id)sender;
- (IBAction)passwordFieldDidChanged:(id)sender;
- (IBAction)dismissAllKeyboards:(id)sender;

@end

@implementation PSSignUpViewController


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate=self;
    self.scrollView.scrollEnabled=YES;
    _keyboardIsShown = NO;
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height*1.5f)];
    [_scrollView setContentOffset:CGPointZero];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    NSLog(@"scrollView.Size:%@",NSStringFromCGRect(self.scrollView.bounds));
}


-(PSUserModel*)userModel {
    if (!_userModel)
    {
        _userModel=[PSUserModel new];
        _userModel.name=self.nameForSignUpTextField.text;
        _userModel.email=self.emailForSignUpTextField.text;
        _userModel.password=self.passwordForSignUpTextField.text;
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
    
     __weak typeof(self) weakSelf = self;
    
    [[PSNetworkManager sharedManager]signUpModel:self.userModel
     
    success:^
    {
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                            message:NSLocalizedString(@"SignedUpSuccessfullyKey", "")
                            delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                            otherButtonTitles:nil, nil];
        [alert show];


        NSLog(@"success");
       [ [PSUserStore userStoreManager] addActiveUserToCoreDataWithModel:weakSelf.userModel];
                                             
       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
    }
     
    error:^(NSError *error)
     {
         NSString *errorDescription=[error description];
         NSLog(@"error:%@",errorDescription);
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    
         UIAlertView *alert=[[UIAlertView alloc]
                             initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                             message:errorDescription
                             delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
                             otherButtonTitles:nil, nil];
         [alert show];
     }];
}


- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat keyboardHeight = kbSize.height;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        self.guidingConstraint.constant = keyboardHeight + 20.f;
        [self.view layoutIfNeeded];
        
        
        [_scrollView setContentSize:CGSizeMake(320.f, 186.f)];
        [_scrollView setContentOffset:CGPointZero animated:YES];
    
        [self.view layoutIfNeeded];
    }];

    
    }

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.3 animations:
     ^{
         _guidingConstraint.constant = 0.f;
         [self.view layoutIfNeeded];
     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
    NSLog(@"(void)textFieldDidBeginEditing:(UITextField *)textField");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
    NSLog(@"(void)textFieldDidEndEditing:(UITextField *)textField");

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
    else {
        [textField resignFirstResponder];
    }
    return YES;
    
}

@end
