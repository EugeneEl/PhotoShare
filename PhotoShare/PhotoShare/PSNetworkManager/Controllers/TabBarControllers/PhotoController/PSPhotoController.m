//
//  PSPhotoController.m
//  PhotoShare
//
//  Created by Евгений on 12.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSPhotoController.h"


@interface PSPhotoController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imageForPhoto;

- (IBAction)actionMakePhoto:(id)sender;
- (IBAction)actionTakeFromAlbum:(id)sender;

@end

@implementation PSPhotoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    }

- (IBAction)actionMakePhoto:(id)sender
{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
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

- (IBAction)actionTakeFromAlbum:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}
    
#pragma mark - Image Picker Controller delegate methods
    
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
        
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        UIImageWriteToSavedPhotosAlbum (chosenImage, nil, nil , nil);
        self.imageForPhoto.image = chosenImage;
        self.imageForPhoto.contentMode = UIViewContentModeScaleAspectFill;
    
        [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
    
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
        
[picker dismissViewControllerAnimated:YES completion:NULL];
        
}
    
    
@end

 
