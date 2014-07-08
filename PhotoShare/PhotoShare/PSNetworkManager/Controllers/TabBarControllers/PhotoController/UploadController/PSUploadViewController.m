//
//  PSUploadViewController.m
//  PhotoShare
//
//  Created by Евгений on 07.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSUploadViewController.h"
#import "PSNetworkManager.h"
#import <CoreLocation/CoreLocation.h>

@interface PSUploadViewController () <CLLocationManagerDelegate, UITextViewDelegate>

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSString *text;
- (IBAction)dismissKeyboardOnTap:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *photoNameTextView;
- (IBAction)sendPhoto:(id)sender;

@end

@implementation PSUploadViewController

- (instancetype)initWithImage:(UIImage *)image andUserID:(int)userID
{
    if (self = [super init]) {
        _image = image;
        _userID=userID;
}
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

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

    
    
        self.text=@"text";
    

}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations objectAtIndex:0];
//    NSLog(@"currentPosition:latitude%f   longtitude:%f",(double)self.currentLocation.coordinate.latitude, (double)self.currentLocation.coordinate.longitude);
 

    [self.locationManager stopUpdatingLocation];
    self.lng=self.currentLocation.coordinate.longitude;
    self.lat=self.currentLocation.coordinate.latitude;
    NSLog(@"lat:%f",_lat);
    NSLog(@"lng:%f",_lng);

}



- (IBAction)sendPhoto:(id)sender
{
    
    if ((_image) && (_userID) && (self.lat) && (self.lng) && (_text))
    {
        
        [[PSNetworkManager sharedManager] sendImage:self.image withLatitude:self.lat
                                      andLongtitude:self.lng
                                           withText:_text fromUserID:_userID
        success:^(id responseObject)
        {
          NSLog(@"image send successfully");
        }
        error:^(NSError *error)
        {
            
        }];

    }
    else if ((!_lat) || (!_lng))
    {
        NSLog(@"problem with location");
    }
    else
    {
         NSLog(@"an error has occurred");
    }
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



#pragma mark - UITextFieldDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    _text=textView.text;
    
}



- (IBAction)dismissKeyboardOnTap:(id)sender
{
       [[self view] endEditing:YES];
}


@end
