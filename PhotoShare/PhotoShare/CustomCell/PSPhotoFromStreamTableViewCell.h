//
//  photoFromStreamTableViewCell.h
//  PhotoShare
//
//  Created by Евгений on 16.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@class PSPhotoFromStreamTableViewCell;
@protocol PhotoFromStreamTableViewCell;

@protocol  PhotoFromStreamTableViewCell<NSObject>
@optional
- (void)photoStreamCellLikeButtonPressed:(PSPhotoFromStreamTableViewCell  *)tableCell;
- (void)photoStreamCellCommentButtonPressed:(PSPhotoFromStreamTableViewCell *)tableCell;
- (void)photoStreamCellShareButtonPressed:(PSPhotoFromStreamTableViewCell  *)tableCell;
@end

@interface PSPhotoFromStreamTableViewCell : UITableViewCell

@property (nonatomic, weak) id <PhotoFromStreamTableViewCell> delegate;
@property (nonatomic, weak) IBOutlet UIImageView *imageForPost;
@property (nonatomic, weak) IBOutlet UILabel *photoNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *likesNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentsNumberLabel;
@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UILabel *timeintervalLabel;

@property (nonatomic, assign) BOOL likesStatus;
@property (nonatomic, getter = isWaitingForLikeResponse)BOOL waitingForLikeResponse;
@property (nonatomic, strong) Post *postForCell;


- (IBAction)likeAction:(id)sender;
- (IBAction)commentAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (void)configureWithPost:(Post *)post;

@end
