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


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
