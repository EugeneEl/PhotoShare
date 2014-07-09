//
//  PSCommentTableViewCell.m
//  PhotoShare
//
//  Created by Евгений on 09.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSCommentTableViewCell.h"
#import "Comment.h"
#import "User.h"
#import "PSUserParser.h"
#import "PSNetworkManager.h"

@interface PSCommentTableViewCell ()
@property (nonatomic, weak)IBOutlet UIView *userAvaImageView;
@property (nonatomic, weak)IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak)IBOutlet UILabel *commentDateLabel;
@property (nonatomic, weak)IBOutlet UILabel *commentTextLabel;

@end

@implementation PSCommentTableViewCell

+ (CGFloat)cellHeightForObject:(id)object {
    return 50.f;
}

- (void)configureCellWithComment:(Comment *)comment {
    self.userNameLabel.text=comment.commentatorName;
    self.commentTextLabel.text=comment.commentText;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss.SSSSSS'+'00:00"];
    NSString *stringFromDate = [dateFormat stringFromDate:comment.commentDate];
    self.commentDateLabel.text=stringFromDate;
}

@end
