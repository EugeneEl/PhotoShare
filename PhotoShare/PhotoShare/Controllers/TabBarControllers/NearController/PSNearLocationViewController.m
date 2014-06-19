//
//  PSNearLocationViewController.m
//  PhotoShare
//
//  Created by Евгений on 17.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSNearLocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PSMapAnnonation.h"
#import "Post.h"
#import "UIView+PSMKAnnotationView.h"
#import "UIKit+AFNetworking.h"
#import "AFNetworking.h"
#import "PSMKPinAnnotationView.h"

@interface PSNearLocationViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, assign) double latitudeFromPost;
@property (nonatomic, assign) double longtitudeFromPost;
@property (nonatomic, strong) NSMutableArray *arrayOfPosts;
@property (nonatomic, strong) NSMutableArray *arrayOfAnnotations;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSMutableArray *arrayOfImagesURL;
@property (nonatomic, strong) UIImageView *imageViewForAnnotaion;


- (IBAction)searchByRadius:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;


- (IBAction)actionAdd:(id)sender;
- (IBAction)showAll:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *testButton;

@end

@implementation PSNearLocationViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.testButton.alpha=0.0;
    
    self.arrayOfImagesURL=[NSMutableArray new];
    
    self.locationManager=[[CLLocationManager alloc]init];
    
    self.locationManager.delegate = self;
    
    
    
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    
    [self.locationManager startUpdatingLocation];
    
     //self.mapView.showsUserLocation=YES;
    
     NSArray* tempArray=[Post MR_findAll];
     self.arrayOfPosts=[tempArray mutableCopy];
    
     self.arrayOfAnnotations=[NSMutableArray new];
    
    
     for (Post *post in self.arrayOfPosts) {
        
        PSMapAnnonation *annonation=[[PSMapAnnonation alloc]init];
        annonation.title=post.photoName;
      //  annonation.subtitle=post.authorMail;
        
      // annonation
        
        self.latitudeFromPost=[post.photoLocationLatitude doubleValue];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude=(CLLocationDegrees)[post.photoLocationLatitude    doubleValue];
        coordinate.longitude=(CLLocationDegrees)[post.photoLocationLongtitude doubleValue];
        
        [annonation setCoordinate:coordinate];
        
        //annonation.coordinate=self.mapView.centerCoordinate;
        
        [self.arrayOfAnnotations addObject:annonation];
        
        NSString* stringForURL=post.photoURL;
        annonation.imageURL=[NSURL URLWithString:stringForURL];
 
    }
    
    [self.mapView addAnnotations:self.arrayOfAnnotations];
    
    
    /*
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.5;     // 0.0 is min value u van provide for zooming
    span.longitudeDelta= 0.5;
    
    CLLocationCoordinate2D location = self.currentLocation.coordinate;
    region.span=span;
    region.center =location;
    
    
    [self.mapView setRegion:region animated:TRUE];
    [self.mapView regionThatFits:region];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    
    */
    
}

/*
- (IBAction)actionAdd:(id)sender {
    
    PSMapAnnonation *annonation=[[PSMapAnnonation alloc]init];
    annonation.title=@"test";
    annonation.subtitle=@"testSubtitle";
    annonation.coordinate=self.mapView.centerCoordinate;
    
    [self.mapView addAnnotation:annonation];
}
*/


- (IBAction)showAll:(id)sender {
    
    MKMapRect zoomRect=MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location=annotation.coordinate;
        

        MKMapPoint center=MKMapPointForCoordinate(location);
        
        static double delta=20000;
        
        
        MKMapRect rect=MKMapRectMake(center.x-delta, center.y-delta, delta*2, delta*2);
        
        //unite zoom rect and rect with annotations through array
        zoomRect=MKMapRectUnion(zoomRect, rect);
    }
    //Adjusts the aspect ratio of the specified map rectangle to ensure that it fits in the map view’s frame.
    [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
    
    
    
}



#pragma mark- MKMapViewDelegate

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString *identifier=@"identifier";
    
    MKPinAnnotationView *pin=(MKPinAnnotationView*) [ self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    PSMapAnnonation *customAnnotation=(PSMapAnnonation*)annotation;
    
    if (!pin)
    {
        pin=[[PSMKPinAnnotationView alloc]initWithAnnotation:customAnnotation reuseIdentifier:identifier];
        pin.pinColor=MKPinAnnotationColorRed;
        pin.animatesDrop=NO;
        pin.draggable=NO;
        [pin setFrame:CGRectMake(pin.frame.origin.x, pin.frame.origin.y, 100.f, 100.f)];
        
    }
    
    else
    {
        pin.annotation=customAnnotation;
    }
    
    return pin;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog (@"Callout accessory control tapped");
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(PSMKPinAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class ]]) return;
    
    view.detailViewHidden=NO;
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
if (![view isKindOfClass:[PSMKPinAnnotationView class]]) {
    return;
   }
    
    PSMKPinAnnotationView *customAnnotationView=(PSMKPinAnnotationView*)view;
    [customAnnotationView setDetailViewHidden:YES];
    
}


             
- (IBAction)searchByRadius:(id)sender
{
    
    UISlider *slider=(UISlider*)sender;
    
    NSInteger changedValue=lround(slider.value);
    self.radiusLabel.text=[NSString stringWithFormat:@"%li", changedValue];
    
    MKCoordinateSpan spanForRect;
    spanForRect.latitudeDelta=(CLLocationDegrees)changedValue/112.20f;
    spanForRect.longitudeDelta=(CLLocationDegrees)changedValue/112.20f;
    
    NSLog(@"%f",changedValue/112.20f);
    
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"currentPosition:latitude%d   longtitude:%d",(double)self.currentLocation.coordinate.latitude, (double)self.currentLocation.coordinate.longitude);
    
    
    MKCoordinateRegion  region=MKCoordinateRegionMake(self.currentLocation.coordinate,spanForRect);
    
    
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:TRUE];
    

}


#pragma mark - CLLocationManagerDelegate



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    

    
    self.currentLocation = [locations objectAtIndex:0];
    NSLog(@"currentPosition:latitude%d   longtitude:%d",(double)self.currentLocation.coordinate.latitude, (double)self.currentLocation.coordinate.longitude);

    [self.locationManager stopUpdatingLocation];
   
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
             //CountryArea = NULL;
         }
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
 
}


/*
-(void)show
{
    
    MKMapRect zoomRect=MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location=annotation.coordinate;
        
        
        MKMapPoint center=MKMapPointForCoordinate(location);
        
        static double delta=20000;
        
        
        MKMapRect rect=MKMapRectMake(center.x-delta, center.y-delta, delta*2, delta*2);
        
        //unite zoom rect and rect with annotations through array
        zoomRect=MKMapRectUnion(zoomRect, rect);
    }
    //Adjusts the aspect ratio of the specified map rectangle to ensure that it fits in the map view’s frame.
    [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
}
*/



#pragma mark - Touches
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touch");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.mapView];
    
    for (UIView *view in self.mapView.subviews)
    {
//        if ([view isKindOfClass:[PSMKPinAnnotationView class]] &&
//            CGRectContainsPoint(view.frame, touchLocation))
//        {
//            NSLog(@"%@",[view class]);
//        }
        
        
        NSLog(@"%@",[view class]);
    }
}



@end
