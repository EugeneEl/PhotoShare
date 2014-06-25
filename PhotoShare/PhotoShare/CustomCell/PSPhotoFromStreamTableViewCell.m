//
//  photoFromStreamTableViewCell.m
//  PhotoShare
//
//  Created by Евгений on 16.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSPhotoFromStreamTableViewCell.h"

@interface PSPhotoFromStreamTableViewCell ()

@end


@implementation PSPhotoFromStreamTableViewCell

- (IBAction)likeAction:(id)sender {
    
    [self.delegate photoStreamCellLikeButtonPressed:self];
    
}

- (IBAction)commentAction:(id)sender {
    
    [self.delegate photoStreamCellCommentButtonPressed:self];
     
}

- (IBAction)shareAction:(id)sender {
    
    [self.delegate photoStreamCellShareButtonPressed:self];
     
}

@end
