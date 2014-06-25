//
//  MKMapView+MKMapView_PSZoomLevel.h
//  PhotoShare
//
//  Created by Евгений on 23.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (MKMapView_PSZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
