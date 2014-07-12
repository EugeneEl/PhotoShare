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

@property (nonatomic, strong) PSUserModel *userModel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *guidingConstraint;
@property (nonatomic, weak) IBOutlet UITextField *nameForSignUpTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailForSignUpTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordForSignUpTextField;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

- (IBAction)nameFieldDidChanged:(id)sender;
- (IBAction)emailFieldDidChanged:(id)sender;
- (IBAction)passwordFieldDidChanged:(id)sender;
- (IBAction)dismissAllKeyboards:(id)sender;


@end

@implementation PSSignUpViewController

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
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
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height*1.5f)];
    [_scrollView setContentOffset:CGPointZero];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

#pragma mark - getUserModekl
-(PSUserModel*)userModel {
    if (!_userModel) {
        _userModel = [PSUserModel new];
        _userModel.name = _nameForSignUpTextField.text;
        _userModel.email = _emailForSignUpTextField.text;
        _userModel.password = _passwordForSignUpTextField.text;
    }
    return _userModel;
}


#pragma mark - fieldsDidChanged
- (IBAction)nameFieldDidChanged:(id)sender {
    _userModel.name = _nameForSignUpTextField.text;
}

- (IBAction)emailFieldDidChanged:(id)sender {
    _userModel.email = _emailForSignUpTextField.text;
}

- (IBAction)passwordFieldDidChanged:(id)sender {
    _userModel.password = _passwordForSignUpTextField.text;
}

#pragma mark - dismissKeyboards
- (IBAction)dismissAllKeyboards:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - signUp
- (IBAction)doneSignUp:(id)sender
{
    
    if (![self.userModel isSignUpValid]) {
        UIAlertView *alert = [[UIAlertView alloc]
                            initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                            message: NSLocalizedString(@"alertViewOnWrongFieldsErrorKey", "")
                            delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
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
         NSString *errorDescription = [error description];
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

#pragma mark - KeyBoard
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat keyboardHeight = kbSize.height;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        _guidingConstraint.constant = keyboardHeight + 20.f;
        [self.view layoutIfNeeded];
        
        
        [_scrollView setContentSize:CGSizeMake(320.f, 186.f)];
        [_scrollView setContentOffset:CGPointZero animated:YES];
    
        [self.view layoutIfNeeded];
    }];

    }


- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.3 animations:
     ^{
         _guidingConstraint.constant = 0.f;
         [self.view layoutIfNeeded];
     }];
}

#pragma mark - hideKeyBoard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
