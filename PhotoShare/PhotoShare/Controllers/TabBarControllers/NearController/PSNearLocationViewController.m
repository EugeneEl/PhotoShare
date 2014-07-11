//
//  PSNearLocationViewController.m
//  PhotoShare
//
//  Created by Евгений on 17.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSNearLocationViewController.h"
#import <MapKit/MapKit.h>
#import "PSMapAnnotation.h"
#import "Post.h"
#import "PSMKAnnotationView.h"
#import "PSDetailedPhotoContollerViewController.h"

@interface PSNearLocationViewController () <MKMapViewDelegate, CLLocationManagerDelegate, PSMKAnnotationViewDelegate,UIScrollViewDelegate>


@property (nonatomic, assign) double latitudeFromPost;
@property (nonatomic, assign) double longtitudeFromPost;
@property (nonatomic, copy) NSMutableArray *arrayOfPosts;

//copy is illegal here because we need to add objects to arrayOfAnnotations,
//while copy returns an immutable Array
@property (nonatomic, strong) NSMutableArray *arrayOfAnnotations;

@property (nonatomic, strong) UIImageView *imageViewForAnnotaion;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) MKCircle *circle;


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;

- (IBAction)searchByRadius:(id)sender;
- (IBAction)showAll:(id)sender;

@end

@implementation PSNearLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayOfAnnotations=[NSMutableArray new];
    
    
    NSArray* tempArray=[Post MR_findAll];
    self.arrayOfPosts=[tempArray mutableCopy];
    
    
    for (Post *post in self.arrayOfPosts)
    {
        
        PSMapAnnotation *annonation=[[PSMapAnnotation alloc]init];
        annonation.title=post.photoName;
        
        
        self.latitudeFromPost=[post.photoLocationLatitude doubleValue];
        
        self.longtitudeFromPost=[post.photoLocationLongtitude doubleValue];
        NSLog(@"%f",_latitudeFromPost);
        NSLog(@"%f",_longtitudeFromPost);
        
        CLLocationCoordinate2D coordinate;
        
        coordinate.latitude=(CLLocationDegrees)self.latitudeFromPost;
        coordinate.longitude=(CLLocationDegrees)self.longtitudeFromPost;

        [annonation setCoordinate:coordinate];
        
        NSLog
        (@"latitude:%f", annonation.coordinate.latitude);
        
        NSLog(@"longtitude:%f", annonation.coordinate.longitude);
        [annonation setPostIdForAnnotation:post.postID];
        
        [self.arrayOfAnnotations addObject:annonation];
        
        NSString* stringForURL=post.photoURL;
        annonation.imageURL=[NSURL URLWithString:stringForURL];

    }
    
    
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

    [self.mapView addAnnotations:self.arrayOfAnnotations];

}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

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

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;

    static NSString *identifier=@"identifier";
    
    PSMKAnnotationView *pin = (PSMKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    PSMapAnnotation *customAnnotation=(PSMapAnnotation*)annotation;

    if (!pin) {
        pin = [[PSMKAnnotationView alloc]initWithAnnotation:customAnnotation reuseIdentifier:identifier];
        [pin setFrame:CGRectMake(0.f, 0.f, 32.f, 32.f)];
        [pin setDelegate:self];
    }

    pin.annotation=customAnnotation;

    return pin;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(PSMKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class ]]) return;
   
    view.detailViewHidden=NO;
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
if (![view isKindOfClass:[PSMKAnnotationView class]]) {
    return;
   }
    
    PSMKAnnotationView *customAnnotationView=(PSMKAnnotationView *)view;
    [customAnnotationView setDetailViewHidden:YES];
    
}


             
- (IBAction)searchByRadius:(id)sender
{
    
    UISlider *slider=(UISlider*)sender;
    
    NSInteger changedValue=lround(slider.value);
    self.radiusLabel.text=[[NSString stringWithFormat:@"%li ", (long)changedValue] stringByAppendingString:NSLocalizedString(@"DistanceMeasurementKey", @"")];
    NSLog(@"%f",changedValue/112.20f);
    [self.locationManager startUpdatingLocation];
    NSLog(@"currentPosition:latitude%f   longtitude:%f",(double)self.currentLocation.coordinate.latitude, (double)self.currentLocation.coordinate.longitude);
    
    if (self.circle) {
        [self.mapView removeOverlay:self.circle];
    }
    self.circle = [MKCircle circleWithCenterCoordinate:self.currentLocation.coordinate radius:changedValue*1000];
    NSLog(@"Circle:%f",(double)self.circle.radius);
    [self.mapView addOverlay:self.circle];
    
    MKCoordinateSpan spanForRect;
    spanForRect.latitudeDelta=(CLLocationDegrees)changedValue*2.9f/112.20f;  //2R+x 2.5 for 3.5
    spanForRect.longitudeDelta=(CLLocationDegrees)changedValue*2.9f/112.20f;
    
    MKCoordinateRegion  region=MKCoordinateRegionMake(self.currentLocation.coordinate,spanForRect);
    
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:TRUE];
}


#pragma mark - CLLocationManagerDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if (![overlay isKindOfClass:[MKCircle class]]) {
        return nil;
    }
    
    MKCircleRenderer *circleRender =[[MKCircleRenderer alloc]initWithCircle:self.circle];
    
    circleRender.strokeColor=[[UIColor blueColor] colorWithAlphaComponent:0.7f];
    circleRender.fillColor=[[UIColor blueColor] colorWithAlphaComponent:0.09f];
    
    return circleRender;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations objectAtIndex:0];
    NSLog(@"currentPosition:latitude%f   longtitude:%f",(double)self.currentLocation.coordinate.latitude, (double)self.currentLocation.coordinate.longitude);

    [self.locationManager stopUpdatingLocation];

 
}

#pragma mark - PSMKAnnotationViewDelegate

- (void)annotationView:(PSMKAnnotationView *)view didSelectAnnotation:(PSMapAnnotation *)annotation
{

   NSLog(@"%@", annotation);
  
    [self performSegueWithIdentifier:@"goToDetail" sender:annotation];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToDetail"]) {
        PSMapAnnotation *annotation=sender;
        PSDetailedPhotoContollerViewController *destinationController=segue.destinationViewController;
        Post *postToPass=[[Post MR_findByAttribute:@"postID" withValue:annotation.postIdForAnnotation]firstObject];
        
        destinationController.post=postToPass;
    }
}

@end
