//
//  photoFromStreamTableViewCell.h
//  PhotoShare
//
//  Created by Евгений on 16.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSPhotoFromStreamTableViewCell;

@protocol PhotoFromStreamTableViewCell;

@protocol  PhotoFromStreamTableViewCell<NSObject>

@required

- (void)photoStreamCellLikeButtonPressed:(PSPhotoFromStreamTableViewCell  *)tableCell;
- (void)photoStreamCellCommentButtonPressed:(PSPhotoFromStreamTableViewCell *)
tableCell;
- (void)photoStreamCellShareButtonPressed:(PSPhotoFromStreamTableViewCell  *)
tableCell;

@end

@interface PSPhotoFromStreamTableViewCell : UITableViewCell

@property(weak,nonatomic) id <PhotoFromStreamTableViewCell> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageForPost;
@property (weak, nonatomic) IBOutlet UILabel *photoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsNumberLabel;


- (IBAction)likeAction:(id)sender;
- (IBAction)commentAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@end
