//
//  PSCollectionCellForPhoto.m
//  PhotoShare
//
//  Created by Евгений on 16.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSCollectionCellForPhoto.h"

@implementation PSCollectionCellForPhoto

- (instancetype)init
{
    self = [super init];
    if (self) {
         [self setBounds:CGRectMake(0.f, 0.f, 200.f, 200.f)];
         [self.layer setBorderWidth:2.0f];
         [self.layer setBackgroundColor:[UIColor whiteColor].CGColor];
        // [self.layer setCornerRadius:100.0f]; consume too much
         
    }
    return self;
}


-(void)prepareForReuse {
    self.imageForPhoto.image=nil;
}

@end
