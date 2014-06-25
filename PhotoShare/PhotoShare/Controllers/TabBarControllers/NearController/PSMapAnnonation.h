//
//  PSMapAnnonation.h
//  PhotoShare
//
//  Created by Евгений on 17.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PSMapAnnonation :NSObject <MKAnnotation>

@property (nonatomic, assign,readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSURL *imageURL;
@property (nonatomic, strong) NSNumber * postIdForAnnotation;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
