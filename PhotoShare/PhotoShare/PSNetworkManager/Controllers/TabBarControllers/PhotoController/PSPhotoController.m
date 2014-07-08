//
//  PSPhotoController.m
//  PhotoShare
//
//  Created by Евгений on 12.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSPhotoController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "PSUploadViewController.h"
#import "PSUserStore.h"

@interface PSPhotoController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,copy) NSArray*  arrayOfImages;
@property (strong, atomic) ALAssetsLibrary* library;
@property (weak, nonatomic) IBOutlet UIButton *postButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageForPhoto;
@property (nonatomic,strong) UIImage *imageForUpload;

- (IBAction)actionMakePhoto:(id)sender;
- (IBAction)actionTakePhotoFromAlbum:(id)sender;

@end

@implementation PSPhotoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.library = [[ALAssetsLibrary alloc] init];
    [_postButton setHidden:YES];
}


- (IBAction)actionMakePhoto:(id)sender
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
}

- (IBAction)actionTakePhotoFromAlbum:(id)sender {
    
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
}
//
//- (IBAction)actionTakeFromAlbum:(id)sender {
//    
//    UIImagePickerControllerSourceType type=UIImagePickerControllerSourceTypePhotoLibrary;
//    
//    BOOL ok=[UIImagePickerController isSourceTypeAvailable:type];
//    if (!ok) {
//        NSLog(@"error");
//        return;
//    }
//    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.sourceType = type;
//    NSLog(@"%@",picker.mediaTypes);
//    picker.delegate = self;
//    picker.editing=NO;
//
//    [self presentViewController:picker animated:YES completion:NULL];
//    
//}

#pragma mark - Image Picker Controller delegate methods
    
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
    
- (IBAction)actionGoToUpload:(id)sender
{
     [self performSegueWithIdentifier:@"goToUpload" sender:self];
}

    
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
        
[picker dismissViewControllerAnimated:YES completion:NULL];
        
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToUpload"])
    {
        PSUploadViewController *destinationController=segue.destinationViewController;
   
        PSUserStore *userStore= [PSUserStore userStoreManager];
        User *currentUser=userStore.activeUser;
        int _userID=[currentUser.user_id integerValue];
        NSLog(@"user_id:%d",_userID);
        destinationController.userID=_userID;
        destinationController.image=_imageForUpload;
    }
}



@end


