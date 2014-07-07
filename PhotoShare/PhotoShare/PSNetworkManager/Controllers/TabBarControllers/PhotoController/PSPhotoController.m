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

@interface PSPhotoController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>



@property (nonatomic,copy) NSArray*  arrayOfImages;
@property (strong, atomic) ALAssetsLibrary* library;

@property (weak, nonatomic) IBOutlet UIImageView *imageForPhoto;

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
            }
        }];
        
        NSLog(@"%@",chosenImage);
        
        
        
        
       // UIImageWriteToSavedPhotosAlbum (chosenImage, nil, nil , nil);
        
        /*
         
         UIImagePickerControllerEditedImage = "<UIImage: 0x14ebc300>";
         UIImagePickerControllerMediaMetadata =     {
         DPIHeight = 72;
         DPIWidth = 72;
         Orientation = 1;
         "{Exif}" =         {
         ApertureValue = "2.526068811667588";
         BrightnessValue = "3.070773979988958";
         ColorSpace = 1;
         DateTimeDigitized = "2014:07:03 11:52:44";
         DateTimeOriginal = "2014:07:03 11:52:44";
         ExposureMode = 0;
         ExposureProgram = 2;
         ExposureTime = "0.03333333333333333";
         FNumber = "2.4";
         Flash = 32;
         FocalLenIn35mmFilm = 35;
         FocalLength = "2.18";
         ISOSpeedRatings =             (
         100
         );
         LensMake = Apple;
         LensModel = "iPod touch front camera 2.18mm f/2.4";
         LensSpecification =             (
         "2.18",
         "2.18",
         "2.4",
         "2.4"
         );
         MeteringMode = 5;
         PixelXDimension = 1280;
         PixelYDimension = 960;
         SceneType = 1;
         SensingMethod = 2;
         ShutterSpeedValue = "4.906905022631062";
         SubsecTimeDigitized = 699;
         SubsecTimeOriginal = 699;
         WhiteBalance = 0;
         };
         "{MakerApple}" =         {
         1 = 0;
         3 =             {
         epoch = 0;
         flags = 1;
         timescale = 1000000000;
         value = 106751494228458;
         };
         4 = 1;
         5 = 201;
         6 = 201;
         7 = 1;
         };
         "{TIFF}" =         {
         DateTime = "2014:07:03 11:52:44";
         Make = Apple;
         Model = "iPod touch";
         Software = "7.1.1";
         XResolution = 72;
         YResolution = 72;
         };
         };
         UIImagePickerControllerMediaType = "public.image";
         UIImagePickerControllerOriginalImage = "<UIImage: 0x14ebe150>";
         */
        
        /*
         efore snapshotting or snapshot after screen updates.
         2014-07-03 12:02:45.527 PhotoShare[1188:60b] {
         UIImagePickerControllerCropRect = "NSRect: {{-1, 108}, {1937, 1937}}";
         UIImagePickerControllerEditedImage = "<UIImage: 0x16767490>";
         UIImagePickerControllerMediaMetadata =     {
         DPIHeight = 72;
         DPIWidth = 72;
         Orientation = 6;
         "{Exif}" =         {
         ApertureValue = "2.970853654340484";
         BrightnessValue = "0.1134617993171535";
         ColorSpace = 1;
         DateTimeDigitized = "2014:07:03 12:02:42";
         DateTimeOriginal = "2014:07:03 12:02:42";
         ExposureMode = 0;
         ExposureProgram = 2;
         ExposureTime = "0.06666666666666667";
         FNumber = "2.8";
         Flash = 24;
         FocalLenIn35mmFilm = 35;
         FocalLength = "3.85";
         ISOSpeedRatings =             (
         400
         );
         LensMake = Apple;
         LensModel = "iPhone 4 back camera 3.85mm f/2.8";
         LensSpecification =             (
         "3.85",
         "3.85",
         "2.8",
         "2.8"
         );
         MeteringMode = 5;
         PixelXDimension = 2592;
         PixelYDimension = 1936;
         SceneType = 1;
         SensingMethod = 2;
         ShutterSpeedValue = "3.911199862602335";
         SubjectArea =             (
         1295,
         967,
         699,
         696
         );
         SubsecTimeDigitized = 276;
         SubsecTimeOriginal = 276;
         WhiteBalance = 0;
         };
         "{MakerApple}" =         {
         1 = 0;
         2 = <34343034 32312c5b 312c3133 3c352b84 312e2d38 53372595 2a2c3426 2c461d31 2b2e2023 293e1f31 2d212125 2a43382f 2d222125 25403e2d 30262330 48392d2e>;
         3 =             {
         epoch = 0;
         flags = 1;
         timescale = 1000000000;
         value = 80463706512541;
         };
         4 = 1;
         6 = 190;
         7 = 1;
         };
         "{TIFF}" =         {
         DateTime = "2014:07:03 12:02:42";
         Make = Apple;
         Model = "iPhone 4";
         Software = "7.1";
         XResolution = 72;
         YResolution = 72;
         };
         };
         UIImagePickerControllerMediaType = "public.image";
         UIImagePickerControllerOriginalImage = "<UIImage: 0x16786ea0>";
         }
         */
        NSDictionary *dictionary=[info valueForKey:UIImagePickerControllerMediaMetadata];
        NSLog(@"metaData:%@",dictionary);
        
        self.imageForPhoto.image = chosenImage;
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
    
    else
    {
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        
        
        
        
        /*
        NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSLog(@"url %@",url);
        // We need to use blocks. This block will handle the ALAsset that's returned:
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            // Get the location property from the asset
            
            
            CLLocation *location = [myasset valueForProperty:ALAssetPropertyLocation];
            // I found that the easiest way is to send the location to another method
            
            float lat =location.coordinate.latitude; //[[gpsdata valueForKey:@"Latitude"]floatValue];
            float lng =location.coordinate.longitude;
            NSLog(@"\nLatitude: %f\nLongitude: %f",lat,lng);
            
            
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"Can not get asset - %@",[myerror localizedDescription]);
            // Do something to handle the error
        };
        
        
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:url
                       resultBlock:resultblock
                      failureBlock:failureblock];
        
        */
        
    

        
        self.imageForPhoto.image = chosenImage;
        self.imageForPhoto.contentMode = UIViewContentModeScaleAspectFill;
        NSLog(@"%@",chosenImage);
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
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


/*
 
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
 NSLog(@"url %@",info);
 
 
 if ([picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary) {
 
 // Get the asset url
 NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
 NSLog(@"url %@",url);
 // We need to use blocks. This block will handle the ALAsset that's returned:
 ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
 {
 // Get the location property from the asset
 
 
 CLLocation *location = [myasset valueForProperty:ALAssetPropertyLocation];
 // I found that the easiest way is to send the location to another method
 
 self.lat =location.coordinate.latitude; //[[gpsdata valueForKey:@"Latitude"]floatValue];
 self.lng =location.coordinate.longitude;
 NSLog(@"\nLatitude: %f\nLongitude: %f",self.lat,self.lng);
 
 strLocation=[NSString stringWithFormat:@"La:%f Lo%f",self.lat,self.lng];
 
 NSLog(@"Can not get asset - %@",strLocation);
 
 
 };
 // This block will handle errors:
 ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
 {
 NSLog(@"Can not get asset - %@",[myerror localizedDescription]);
 // Do something to handle the error
 };
 
 
 
 ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
 [assetslibrary assetForURL:url
 resultBlock:resultblock
 failureBlock:failureblock];
 
 
 
 }
 
 
 [self dismissViewControllerAnimated:YES completion:^{
 
 }];
 
 }
*/

@end


