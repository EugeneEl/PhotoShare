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

@interface PSPhotoController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic,copy) NSArray*  arrayOfImages;
@property (strong, atomic) ALAssetsLibrary* library;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) double lat;

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
    [self checkLocationServicesTurnedOn];
    [self checkApplicationHasLocationServicesPermission];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        NSLog(@"Location is not enabled");
    }
    
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
                self.lng=self.currentLocation.coordinate.longitude;
                self.lat=self.currentLocation.coordinate.latitude;
                NSLog(@"lat:%f",_lat);
                NSLog(@"lng:%f",_lng);
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
        NSURL *urlPath = [info valueForKey:UIImagePickerControllerReferenceURL];
        
        
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:urlPath resultBlock:^(ALAsset *asset)
         {
             NSMutableDictionary *assetMetadata = [[[asset defaultRepresentation] metadata] mutableCopy];
             CLLocation *assetLocation = [asset valueForProperty:ALAssetPropertyLocation];
             NSDictionary *gpsData = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:[assetLocation coordinate].longitude], @"Longitude", [NSNumber numberWithDouble:[assetLocation coordinate].latitude], @"Latitude", nil];
             
             [assetMetadata setObject:gpsData forKey:@"Location Information"];
                    NSLog(@"%@",gpsData);
             
             self.lng=[[gpsData valueForKey:@"Longtitude"] doubleValue];
             self.lat=[[gpsData valueForKey:@"Latitude"] doubleValue];
             NSLog(@"lat:%f",_lat);
             NSLog(@"lng:%f",_lng);

         }
                failureBlock:^(NSError *error)
         {
             // error handling
             NSLog(@"failure-----");
         }];
        
       
        if (_lat && _lng) {
            
            
            self.imageForPhoto.image = chosenImage;
            self.imageForPhoto.contentMode = UIViewContentModeScaleAspectFill;
            
            self.imageForUpload=chosenImage;
            [_postButton setHidden:NO];
            [picker dismissViewControllerAnimated:YES completion:NULL];
            
        }
        
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"== Opps! =="
                                                            message:@"Photo doesn't have coordinates.Try another photo"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:nil];
            [alert show];
            [picker dismissViewControllerAnimated:YES completion:NULL];
        }
        
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
        destinationController.lat=_lat;
        destinationController.lng=_lng;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations objectAtIndex:0];
    //    NSLog(@"currentPosition:latitude%f   longtitude:%f",(double)self.currentLocation.coordinate.latitude, (double)self.currentLocation.coordinate.longitude);
    [self.locationManager stopUpdatingLocation];

}




- (void) checkLocationServicesTurnedOn {
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"== Opps! =="
                                                        message:@"'Location Services' need to be on."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


-(void) checkApplicationHasLocationServicesPermission {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"== Opps! =="
                                                        message:@"This application needs 'Location Services' to be turned on."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


@end


