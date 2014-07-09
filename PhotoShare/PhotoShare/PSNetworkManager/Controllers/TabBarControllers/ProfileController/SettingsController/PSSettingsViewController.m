//
//  PSSettingsViewController.m
//  PhotoShare
//
//  Created by Евгений on 13.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSSettingsViewController.h"
#import "PSUserStore.h"
#import "User.h"
#import "CustomUnwindSegue.h"
#import "PSNetworkManager.h"


static NSString *PSChaningUserInfoErrorDomain = @"PSChangingUserInfoErrorDomain";
static NSInteger PSNottingToShareErrorCode  = 101;

@interface PSSettingsViewController() <UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIButton *updateButton;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIImageView *avaImageView;

- (IBAction)actionUpdateInfo:(id)sender;
- (IBAction)logout:(id)sender;

@property (nonatomic, strong) UIImage *imageForAva;
@property (nonatomic, copy) NSMutableString *nameToUpdate;
@property (nonatomic, copy) NSMutableString *passwordToUpadte;
@property (nonatomic, assign) int userID;
@property (nonatomic, strong) User *currentUser;

@end


@implementation PSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_avaImageView setHidden:YES];
    _nameTextField.delegate=self;
    _passwordTextField.delegate=self;
    _nameToUpdate=[NSString new];
    _passwordToUpadte=[NSString new];
    PSUserStore *userStore= [PSUserStore userStoreManager];
    _currentUser=userStore.activeUser;
    _userID=[_currentUser.user_id integerValue];
}


- (IBAction)actionChangePhoto:(id)sender {
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString
                                  (@"actionSheetButtonCancelNameKey", "")
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil, nil];

    [actionSheet addButtonWithTitle:NSLocalizedString(@"actionSheetButtonFromCameraKey", "")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"actionSheetButtonFromLibraryKey", "")];
    
    //without next line action sheet does not appear on iphone 3.5 inch
    [actionSheet showFromTabBar:(UIView*)self.view];
}

- (IBAction)actionUpdateInfo:(id)sender
{
    if ((!_imageForAva) && (!_nameToUpdate) && (_passwordToUpadte)) {
        UIAlertView *alert=[[UIAlertView alloc]
            initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
            message:NSLocalizedString(@"alertViewErrorNothingToUpdateKey", "")
            delegate:nil
            cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
 
    
    
        
    
    [[PSNetworkManager sharedManager] updateUserInforWithuserAva:_imageForAva newPassword:_passwordToUpadte newUserName:_nameToUpdate
        fromUserID:_userID
        success:^(id responseObject) {
            UIAlertView *alert=[[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@ "alertViewOkKey", "")
                              message:NSLocalizedString(@"alertViewSuccessKey", "")
                                delegate:nil
                                cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                otherButtonTitles:nil, nil];
            [alert show];
            
            
            

        }
        error:^(NSError *error)
       {
           
            UIAlertView *alert=[[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                message:[error localizedDescription]
                                delegate:nil
                                cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
                                otherButtonTitles:nil, nil];
            [alert show];

        }];
    
    
}

- (IBAction)logout:(id)sender {
    
    
    //check for userWithEmptyEmail in database and add it if such object doesn't exist
    User *userWithEmptyEmail=[[User MR_findByAttribute:@"email" withValue:@""] firstObject];
    if (!userWithEmptyEmail)
    {
       // userWithEmptyEmail=[User MR_createEntity];
        userWithEmptyEmail.email=@"";
        [PSUserStore userStoreManager].activeUser=userWithEmptyEmail;
        [userWithEmptyEmail.managedObjectContext MR_saveToPersistentStoreAndWait];
        NSLog(@"logout. user with email:%@",[PSUserStore userStoreManager].activeUser.email);
    }
    
    else
        
    {
        [PSUserStore userStoreManager].activeUser=userWithEmptyEmail;
        NSLog(@"logout. user with email:%@",[PSUserStore userStoreManager].activeUser.email);
    }
    
    [self performSegueWithIdentifier:@"afterLoggedOutToSplash" sender:nil];
    

}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
       
        case 1:
        {
    
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                                                      message:NSLocalizedString(@"alertViewErrorNoCameraKey","" )
                                                                     delegate:nil
                                                            cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                                            otherButtonTitles: nil];
                
                [myAlertView show];
                return;
            }
            
            
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];

            break;
        }
            
        case 2:
        {
            
            UIImagePickerControllerSourceType type=UIImagePickerControllerSourceTypePhotoLibrary;
            
            BOOL ok=[UIImagePickerController isSourceTypeAvailable:type];
            if (!ok) {
                NSLog(@"error");
                return;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = type;
            NSLog(@"%@",picker.mediaTypes);
            picker.delegate = self;
            picker.editing=NO;
            
            
            
            [self presentViewController:picker animated:YES completion:NULL];
            
            break;
        }
        default:
            break;
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue isKindOfClass:[CustomUnwindSegue class]]) {
        // Set the start point for the animation to center of the button for the animation
        ((CustomUnwindSegue *)segue).targetPoint = self.view.center;
    }
}


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    
    
    
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
    {
        _imageForAva=info[UIImagePickerControllerEditedImage];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        [_avaImageView setHidden:NO];
        [_avaImageView setImage:_imageForAva];
        
    }
    
    else
    {
        _imageForAva = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        [_avaImageView setHidden:NO];
        [_avaImageView setImage:_imageForAva];
    };
}


#pragma mark - fieldsDidChanged

- (IBAction)nameDidChange:(id)sender {
    
    self.nameToUpdate=[self.nameTextField.text copy];
}

- (IBAction)passwordDidChange:(id)sender {
    self.passwordToUpadte=[self.passwordTextField.text copy];
}

#pragma mark - dismissKeyboard
- (IBAction)dismissKeyboards:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if ([textField isEqual:self.nameTextField]) {
        [self.passwordTextField becomeFirstResponder];
    }
    
    else {
        [textField resignFirstResponder];
    }
    return YES;
    
}



@end
