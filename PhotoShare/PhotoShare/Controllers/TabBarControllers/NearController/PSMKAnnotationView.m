//
//  PSMKAnnotationView.m
//  PhotoShare
//
//  Created by Евгений on 18.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PSMKAnnotationView.h"
#import "PSMapAnnonation.h"
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
        _imageViewForAnnotation = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, 0.f, 70.f, 70.f)];
        [self addSubview:_imageViewForAnnotation];
        [_imageViewForAnnotation addGestureRecognizer:_tapRecognizer];
        [_imageViewForAnnotation setUserInteractionEnabled:YES];
        [self setClipsToBounds:NO];

        _pinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
        [self addSubview:_pinImageView];
        [_pinImageView setFrame:CGRectMake(-16.f, 34.f, 32.f, 32.f)];
    }
    
    return self;
}

-(void)tap:(UITapGestureRecognizer*)recognizer {
    [_delegate annotationView:self didSelectAnnotation:(PSMapAnnonation *)self.annotation];
}

- (BOOL)validAnnotation {
    return  [self.annotation isKindOfClass:[PSMapAnnonation class]];
}

- (void)setDetailViewHidden:(BOOL)detailViewHidden {
    if (![self validAnnotation]) return;

    if (!detailViewHidden) {
        self.annotation = self.annotation;
        [_imageViewForAnnotation setHidden:NO];
        [_imageViewForAnnotation setImageWithURL:[(PSMapAnnonation *) self.annotation imageURL]];
    } else {
        [_imageViewForAnnotation setHidden:YES];
    }
}

@end
