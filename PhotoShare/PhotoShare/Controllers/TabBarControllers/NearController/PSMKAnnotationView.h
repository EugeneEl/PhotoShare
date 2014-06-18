//
//  PSMKAnnotationView.h
//  PhotoShare
//
//  Created by Евгений on 18.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface PSMKAnnotationView : MKPinAnnotationView

@property (nonatomic, getter = isDetailViewHidden) BOOL detailViewHidden;

- (BOOL)validAnnotation;

@end
