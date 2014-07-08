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

@interface PSSettingsViewController()




- (IBAction)logout:(id)sender;

@end


@implementation PSSettingsViewController
- (IBAction)actionChangePhoto:(id)sender
{
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






/*
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
 {
 NSLog(@"%@",info);
 
 
 
 if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
 {
 UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
 
 [self.library saveImage:chosenImage toAlbum:@"PhotoShare" withCompletionBlock:^(NSError *error) {
 if (error)
 {
 NSLog(@"Error: %@", [error description]);
 UIAlertView *alert=[[UIAlertView alloc]
 initWithTitle:NSLocalizedString(@ "ErrorStringKey","")
 message:NSLocalizedString(@"alertViewOnSaveErrorKey","") delegate:nil
 cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey","")otherButtonTitles:nil, nil];
 [alert show];
 }
 else
 {
 UIAlertView *alert=[[UIAlertView alloc]
 initWithTitle:NSLocalizedString(@"alertViewSuccessKey","")
 message:NSLocalizedString(@"alertViewOnSaveSuccessKey","")
 delegate:nil
 cancelButtonTitle:NSLocalizedString(@"alertViewOkKey","") otherButtonTitles:nil, nil];
 [alert show];
 [_postButton setHidden:NO];
 }
 }];
 
 NSLog(@"%@",chosenImage);
 
 
 
 NSDictionary *dictionary=[info valueForKey:UIImagePickerControllerMediaMetadata];
 NSLog(@"metaData:%@",dictionary);
 
 self.imageForPhoto.image = chosenImage;
 self.imageForUpload=chosenImage;
 [picker dismissViewControllerAnimated:YES completion:NULL];
 }
 
 else
 {
 UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
 
 
 self.imageForPhoto.image = chosenImage;
 self.imageForPhoto.contentMode = UIViewContentModeScaleAspectFill;
 NSLog(@"%@",chosenImage);
 
 self.imageForUpload=chosenImage;
 [_postButton setHidden:NO];
 [picker dismissViewControllerAnimated:YES completion:NULL];
 };
 }
 */



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue isKindOfClass:[CustomUnwindSegue class]])
    {
        // Set the start point for the animation to center of the button for the animation
        ((CustomUnwindSegue *)segue).targetPoint = self.view.center;
    }
}


@end
