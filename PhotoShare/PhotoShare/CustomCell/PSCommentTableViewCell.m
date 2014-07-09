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
@property (weak, nonatomic) IBOutlet UIView *userAvaImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;

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
    //[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *stringFromDate = [dateFormat stringFromDate:comment.commentDate];
    self.commentDateLabel.text=stringFromDate;
}




@end
