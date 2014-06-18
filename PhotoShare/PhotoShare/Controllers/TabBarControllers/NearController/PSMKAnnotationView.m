//
//  PSMKAnnotationView.m
//  PhotoShare
//
//  Created by Евгений on 18.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSMKAnnotationView.h"
#import "PSMapAnnonation.h"
#import "UIImageView+AFNetworking.h"

@interface PSMKAnnotationView ()

@property (nonatomic, strong) UIImageView *imageViewForAnnotaion;

@end

@implementation PSMKAnnotationView

- (BOOL)validAnnotation{
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
            CGRect rect=CGRectMake(0, -35, 30, 30);
            
            self.imageViewForAnnotaion = [[UIImageView alloc] initWithFrame:rect];
            
            [self.imageViewForAnnotaion setImageWithURL:[(PSMapAnnonation*)self.annotation imageURL]];
            
            [self setClipsToBounds:NO];
            [self addSubview:self.imageViewForAnnotaion];
        }
            
    }
    
    else if (detailViewHidden==YES)
    {
        if ([self validAnnotation])
        {
          [self.imageViewForAnnotaion setHidden:YES];
        }
    }

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
