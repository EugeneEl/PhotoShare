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

@interface PSPhotoController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageForPhoto;
@property (nonatomic,strong) NSArray*  arrayOfImages;
@property (strong, atomic) ALAssetsLibrary* library;

- (IBAction)actionMakePhoto:(id)sender;
- (IBAction)actionTakePhotoFromAlbum:(id)sender;

@end

@implementation PSPhotoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.library = [[ALAssetsLibrary alloc] init];
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

- (IBAction)actionTakeFromAlbum:(id)sender {
    
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

#pragma mark - Image Picker Controller delegate methods
    
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
        NSLog(@"%@",info);
    
    
    
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
    {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
        [self.library saveImage:chosenImage toAlbum:@"PhotoShare" withCompletionBlock:^(NSError *error) {
            if (error!=nil) {
                NSLog(@"Error: %@", [error description]);
                UIAlertView *alert=[[UIAlertView alloc]
                                    initWithTitle:NSLocalizedString(@ "ErrorStringKey","")
                                    message:NSLocalizedString(@"alertViewOnSaveErrorKey","") delegate:nil
                                    cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey","")otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                UIAlertView *alert=[[UIAlertView alloc]
                                    initWithTitle:NSLocalizedString(@"alertViewSuccessKey","")
                                    message:NSLocalizedString(@"alertViewOnSaveSuccessKey","")
                                    delegate:nil
                                    cancelButtonTitle:NSLocalizedString(@"alertViewOkKey","") otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
        
       // UIImageWriteToSavedPhotosAlbum (chosenImage, nil, nil , nil);
        self.imageForPhoto.image = chosenImage;
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    
    else
    {
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        self.imageForPhoto.image = chosenImage;
        self.imageForPhoto.contentMode = UIViewContentModeScaleAspectFill;
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    
    
}
    
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
        
[picker dismissViewControllerAnimated:YES completion:NULL];
        
}

//
//2014-06-19 18:04:06.702 PhotoShare[12447:3e03] ADDRESPONSE - ADDING TO MEMORY ONLY: http://cs532300v4.vk.me/u1722475/video/l_c5183fae.jpg
//2014-06-19 18:04:41.397 PhotoShare[12447:907] {
//    UIImagePickerControllerCropRect = "NSRect: {{0, 0}, {640, 640}}";
//    UIImagePickerControllerEditedImage = "<UIImage: 0x1e124840>";
//    UIImagePickerControllerMediaType = "public.image";
//    UIImagePickerControllerOriginalImage = "<UIImage: 0x1e124870>";
//    UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=3907EF33-B4F9-4B0B-A376-0E3D61AABE0B&ext=JPG";

@end

 
