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

@property (nonatomic, strong) UIImageView *imageViewForAnnotaion;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation PSMKPinAnnotationView




-(id)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
//        _tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
//        CGRect rect=CGRectMake(0, -35, 100, 100);
//        _imageViewForAnnotaion = [[UIImageView alloc] initWithFrame:rect];
//        [_imageViewForAnnotaion setUserInteractionEnabled:YES];
        _tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        CGRect rect=CGRectMake(0, -35, 150, 150);
        _imageViewForAnnotaion = [[UIImageView alloc] initWithFrame:rect];
        [self addSubview:_imageViewForAnnotaion];
        [self addGestureRecognizer:_tapRecognizer];
    }
    
    return self;
}


/*
- (void)layoutSubviews {
    [super layoutSubviews];
    [_imageViewForAnnotaion addGestureRecognizer:_tapRecognizer];
}
*/

-(void)tap:(UITapGestureRecognizer*)recognizer {
    NSLog(@"tap");
}

- (BOOL)validAnnotation
{
    return  [self.annotation isKindOfClass:[PSMapAnnonation class]];
}





- (void)setDetailViewHidden:(BOOL)detailViewHidden
{
    
    //draw image in custom view
    if (detailViewHidden==NO)
    {
        if ([self validAnnotation])
        {
            self.annotation=(PSMapAnnonation*)self.annotation;
            
            [_imageViewForAnnotaion setImageWithURL:[(PSMapAnnonation*)self.annotation imageURL]];
            
            [self setClipsToBounds:NO];
            [self addSubview:self.imageViewForAnnotaion];
            [self setBackgroundColor:[UIColor yellowColor]];
            NSLog(@"%@", NSStringFromCGRect(self.frame));
        
         }
    }
    
    else if (detailViewHidden==YES)
    {
        if ([self validAnnotation])
        {
            [self.imageViewForAnnotaion removeFromSuperview];
        }
    }
}


/*
 if (detailViewHidden==NO)
 {
 if ([self validAnnotation])
 {
 self.annotation=(PSMapAnnonation*)self.annotation;
 
 
 
 
 
 [self.imageViewForAnnotaion setImageWithURL:[(PSMapAnnonation*)self.annotation imageURL]];
 
 
 
 
 
 [self setClipsToBounds:NO];
 }
 
 }
 
 else if (detailViewHidden==YES)
 {
 if ([self validAnnotation])
 {
 [self.imageViewForAnnotaion removeFromSuperview];
 }
 }
 
 }
 
 
 - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 NSLog(@"touch");
 }
 
 
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
