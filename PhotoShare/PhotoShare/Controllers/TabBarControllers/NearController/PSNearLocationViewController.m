//
//  PSNearLocationViewController.m
//  PhotoShare
//
//  Created by Евгений on 17.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSNearLocationViewController.h"
#import <MapKit/MapKit.h>
#import "PSMapAnnonation.h"


@interface PSNearLocationViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)actionAdd:(id)sender;
- (IBAction)showAll:(id)sender;

@end

@implementation PSNearLocationViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (IBAction)actionAdd:(id)sender {
    
    PSMapAnnonation *annonation=[[PSMapAnnonation alloc]init];
    annonation.title=@"test";
    annonation.subtitle=@"testSubtitle";
    annonation.coordinate=self.mapView.centerCoordinate;
    
    [self.mapView addAnnotation:annonation];
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

/*
 - (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
 NSLog(@"regionWillChangeAnimated");
 }
 - (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
 NSLog(@"egionDidChangeAnimated:");
 }
 
 - (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
 NSLog(@"mapViewWillStartLoadingMap");
 }
 - (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
 NSLog(@"mapViewDidFinishLoadingMap");
 }
 - (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
 NSLog(@"");
 }
 
 - (void)mapViewWillStartRenderingMap:(MKMapView *)mapView NS_AVAILABLE(10_9, 7_0) {
 NSLog(@"mapViewWillStartRenderingMap");
 }
 - (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
 NSLog(@"mapViewDidFinishRenderingMap");
 }
 
 */


-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifier=@"identifier";
    
    MKPinAnnotationView *pin=(MKPinAnnotationView*) [ self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    
    if (!pin)
    {
        pin=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
             pin.pinColor=MKPinAnnotationColorPurple;
             pin.animatesDrop=YES;
        pin.canShowCallout=YES;
        pin.draggable=YES;
        
        UIButton *desciptionButton=
        [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [desciptionButton addTarget:self action:@selector(actionDescription:) forControlEvents:UIControlEventTouchUpInside];
        
        pin.rightCalloutAccessoryView=desciptionButton;
        
    }
    
    else {
        pin.annotation=annotation;
    }
    return pin;
    
             
             
             
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState==MKAnnotationViewDragStateEnding) {
        CLLocationCoordinate2D location=view.annotation.coordinate;
        
        MKMapPoint mapPoint=MKMapPointForCoordinate(location);
        NSLog(@"location: {%f, %f}\npoint=%@",location.latitude,location.longitude, MKStringFromMapPoint(mapPoint));
        
        
        
    }
    
}

#pragma mark - actiondescription
-(void)actionDescription:(UIButton*) sender
{
    NSLog(@"actionDescription");
}
             
             @end
