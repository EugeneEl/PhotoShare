//
//  PSMKAnnotationView.m
//  PhotoShare
//
//  Created by Евгений on 18.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSMKPinAnnotationView.h"
#import "PSMapAnnonation.h"
#import "UIImageView+AFNetworking.h"

@interface PSMKPinAnnotationView ()

@property (nonatomic, strong) UIImageView *imageViewForAnnotation;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation PSMKPinAnnotationView

-(id)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        _tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        _imageViewForAnnotation = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, -35.f, 150.f, 150.f)];
        [self addSubview:_imageViewForAnnotation];
        [_imageViewForAnnotation addGestureRecognizer:_tapRecognizer];
        [_imageViewForAnnotation setUserInteractionEnabled:YES];
        [self setClipsToBounds:NO];
        [self setBackgroundColor:[UIColor yellowColor]];
    }
    
    return self;
}

-(void)tap:(UITapGestureRecognizer*)recognizer {
    NSLog(@"tap");
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
