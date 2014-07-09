//
//  PSCommentTableViewCell.h
//  PhotoShare
//
//  Created by Евгений on 09.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Comment;

@interface PSCommentTableViewCell : UITableViewCell
- (void)configureCellWithComment:(Comment *)comment;
+ (CGFloat)cellHeightForObject:(id)object;
@end
