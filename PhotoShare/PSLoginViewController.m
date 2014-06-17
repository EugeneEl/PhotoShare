//
//  LoginViewController.m
//  PhotoShare
//
//  Created by Евгений on 10.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//


//This class descibes a viewcontroller which will appear if user is not logged in.
//It displays textViewFields for entering neccessary data.
//If connection is failed an alert containing error description will appear


#import "PSLoginViewController.h"
#import "PSNetworkManager.h"
#import "PSSignUpViewController.h"
#import "PSUserStore.h"
#import "MBProgressHUD.h"
#import "PSUserModel.h"
#import "User.h"

//typedef void (^sumBlock)(NSInteger a,NSInteger b);

@class PSUserModel;

@interface PSLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *facebookIdTextField;

@property(nonatomic,assign) BOOL isRegistered;

@property (nonatomic,strong) PSUserModel* userModel;

- (IBAction)loginDidChanged:(id)sender;
- (IBAction)passwordDidChanged:(id)sender;
- (IBAction)getInfo;
- (IBAction)signUp:(id)sender;
- (IBAction)facebookIdDidChanged:(id)sender;
- (IBAction)login:(id)sender;

- (IBAction)dismissKeyboards:(id)sender;


@end

@implementation PSLoginViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    self.loginTextField.delegate=self;
    self.passwordTextField.delegate=self;
    self.facebookIdTextField.delegate=self;
    
    
    
    //^ return type (arguments list) {expression}
    
    /*
     void (^sumBlock1)(NSInteger, NSInteger)=^void(NSInteger a,NSInteger b)
     {
     NSInteger c=a+b;
     NSLog(@"c:%i",c);
     };
     
     sumBlock1(5,5);
     
     
     NSPredicate *pr = [NSPredicate predicateWithFormat:@"commentatorName == %@", @"Eric"];
     [User MR_findAllWithPredicate:pr];
     
     
     [[PSNetworkManager sharedManager] checkIfLoginedWith:self.userModel success:NULL error:NULL];

     
     //2nd
     NSInteger (^sumBlock2)(NSInteger, NSInteger)=^NSInteger(NSInteger a,NSInteger b)
     {
     return a+b;
     };
     
     NSInteger aa=sumBlock2(10,10);
     NSLog(@"aa:%i",aa);
     
     
     //3d
     void (^sumBlock3)(NSInteger, NSInteger)=^void(NSInteger a,NSInteger b)
     {
     NSInteger c=a+b;
     NSString *resultString =[NSString stringWithFormat:@"%i",c];
     UIAlertView* alert=[[UIAlertView alloc]
     initWithTitle:@"sumBlock3"
     message:resultString
     delegate:self
     cancelButtonTitle:@"Ok"
     otherButtonTitles:nil, nil];
     [alert show];
     };
     
     sumBlock3(15,15);
     */
    
    /*
     void (^sumBlock4)(NSError*)=^void(NSError* error) {
     UIAlertView *alertOnError=[[UIAlertView alloc]
     initWithTitle:@"Error on get request"
     message:
     
     [
     
     NSString  stringWithFormat:@"%i",[error code]]
     delegate:self
     cancelButtonTitle:@"Ok"
     otherButtonTitles:nil];
     [alertOnError show];
     
     };
     
     */
    
    //    [[PSNetworkManager sharedManager] someMethodThatTakesABlock:sumBlock4];
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.facebookIdTextField.inputAccessoryView = numberToolbar;
    
    
    
}


-(PSUserModel*)userModel {
    if (!_userModel)
    {
        _userModel=[PSUserModel new];
        _userModel.email=self.loginTextField.text;
        _userModel.password=self.passwordTextField.text;
        _userModel.facebookId=self.facebookIdTextField.text;
    }
    return _userModel;
    
}


#pragma mark - LoginAndSignUpMethods

- (IBAction)getInfo {
    
    
    
    
    [[PSNetworkManager sharedManager] signUpModel:self.userModel success:^{
        NSLog(@"success");
        self.resultLabel.text=@"Successed";
    } error:^(NSError *error) {
        NSString *errorDescription=[error description];
        NSLog(@"error:%@",errorDescription);
        
        UIAlertView *alertOnError=[[UIAlertView alloc]
                                   initWithTitle:@"Error!"
                                   message:errorDescription
                                   delegate:self
                                   cancelButtonTitle:@"Ok"
                                   otherButtonTitles:nil];
        [alertOnError show];
    }];
    /*
     [[PSNetworkManager sharedManager] signInModel:(_userModel)
     
     success:^{
     NSLog(@"success");
     self.getResultLabel.text=@"Successed";
     }
     
     error:^{
     } (NSError)];
     
     /*
     
     [[PSNetworkManager sharedManager] signInSuccess:^(PSUserModel* userData) {
     NSLog(@"success");
     self.getResultLabel.text=@"Successed";
     
     } failure:^{
     self.getResultLabel.text=@"Success";
     
     
     NSLog(@"login:%@, password:%@",self.userModel.login,self.userModel.password);
     
     }];
     
     
     */
}

- (IBAction)signUp:(id)sender {
    
}


- (IBAction)login:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    [[PSNetworkManager sharedManager]loginWithModel:self.userModel
                                            success:^
     {
         NSLog(@"success");
         weakSelf.resultLabel.text=@"Logged in";
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         
         
         
         
         User *existingUserForLogin=[[User MR_findByAttribute:@"email" withValue:self.userModel.email] firstObject];
         
         if (!existingUserForLogin) {
             existingUserForLogin=[User MR_createEntity];
             existingUserForLogin.email=self.userModel.email;
             existingUserForLogin.password=self.userModel.password;
             existingUserForLogin.name=self.userModel.name;
             existingUserForLogin.facebookID=self.userModel.facebookId;
            [existingUserForLogin.managedObjectContext MR_saveToPersistentStoreAndWait];
         }
         
         [PSUserStore userStoreManager].activeUser=existingUserForLogin;
         NSLog(@"active user logged in:%@",[PSUserStore userStoreManager].activeUser.email);
         
         
     }
     
                                              error:^(NSError *error)
     {
         NSString *errorDescription=[error description];
         NSLog(@"error:%@",errorDescription);
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         
         UIAlertView *alertOnError=[[UIAlertView alloc]
                                    initWithTitle:@"Error!"
                                    message:errorDescription
                                    delegate:nil
                                    cancelButtonTitle:@"Ok"
                                    otherButtonTitles:nil];
         [alertOnError show];
     }];
    
    
}

#pragma mark - fieldsDidChanged

- (IBAction)facebookIdDidChanged:(id)sender {
    _userModel.facebookId=self.passwordTextField.text;
}


- (IBAction)loginDidChanged:(id)sender {
    self.userModel.email=self.loginTextField.text;
    NSLog(@"login:%@",self.userModel.email);
}

- (IBAction)passwordDidChanged:(id)sender {
    self.userModel.password=self.passwordTextField.text;
    NSLog(@"password:%@",self.userModel.password);
}



#pragma mark - PrepareForSegueTranstion
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"signUp"])
    {
        PSSignUpViewController *signUpViewController=(PSSignUpViewController*)segue.destinationViewController;
    }
}


#pragma mark - MethodsForTextFieldKeyboard
-(void)cancelNumberPad{
    [self.facebookIdTextField resignFirstResponder];
    //self.facebookIdTextField.text = @"";
}

-(void)doneWithNumberPad{
    NSString *numberFromTheKeyboard = self.facebookIdTextField.text;
    [self.facebookIdTextField resignFirstResponder];
    
}

- (IBAction)dismissKeyboards:(id)sender
{
    [self.view endEditing:YES];
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if ([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if ([textField isEqual:self.passwordTextField]) {
        [self.facebookIdTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
  
}




@end
