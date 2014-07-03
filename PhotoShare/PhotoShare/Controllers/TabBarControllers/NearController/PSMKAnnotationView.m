//
//  PSMKAnnotationView.m
//  PhotoShare
//
//  Created by Евгений on 18.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PSMKAnnotationView.h"
#import "PSMapAnnotation.h"
#import "UIImageView+AFNetworking.h"

@interface PSMKAnnotationView ()

@property (nonatomic, strong) UIImageView *imageViewForAnnotation;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIView *pinImageView;

@end

@implementation PSMKAnnotationView

-(id)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        _tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        _imageViewForAnnotation = [[UIImageView alloc] initWithFrame:CGRectMake(6.f, 0.f, 32.f, 32.f)];
        [self addSubview:_imageViewForAnnotation];
        [_imageViewForAnnotation addGestureRecognizer:_tapRecognizer];
        [_imageViewForAnnotation setUserInteractionEnabled:YES];
        [self setClipsToBounds:NO];

        _pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
        [self addSubview:_pinImageView];
        [_pinImageView setFrame:CGRectMake(-8.f, 8.f, 16.f, 16.f)];
        //[self setBackgroundColor:[UIColor yellowColor]];
    }
    
    return self;
}

-(void)tap:(UITapGestureRecognizer*)recognizer {
    [_delegate annotationView:self didSelectAnnotation:(PSMapAnnotation *)self.annotation];
}

- (BOOL)validAnnotation {
    return  [self.annotation isKindOfClass:[PSMapAnnotation class]];
}

- (void)setDetailViewHidden:(BOOL)detailViewHidden {
    if (![self validAnnotation]) return;

    if (!detailViewHidden) {
        self.annotation = self.annotation;
        [_imageViewForAnnotation setHidden:NO];
        [_imageViewForAnnotation setImageWithURL:[(PSMapAnnotation *) self.annotation imageURL]];
        [self setBounds:CGRectMake(0.f,0.f,32.f,32.f)];
    
    } else {
        [_imageViewForAnnotation setHidden:YES];
        [self setBounds:CGRectMake(0.f,0.f,16.f, 16.f)];
    }
    
}

@end
