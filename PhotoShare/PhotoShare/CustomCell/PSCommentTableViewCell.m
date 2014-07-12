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


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface PSCommentTableViewCell ()
@property (nonatomic, weak) IBOutlet UIView *userAvaImageView;
@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentDateLabel;
@property (nonatomic, weak) IBOutlet UITextView *commentTextView;

@end

@implementation PSCommentTableViewCell

#pragma mark - cellHeightForObject
+ (CGFloat)cellHeightForObject:(id)object{
    if (![object isKindOfClass:[Comment class]]) return 70.f;
    else
    {
        Comment *commentToDisplay = (Comment *)object;
        CGFloat heightOfTextView = [PSCommentTableViewCell textViewHeightForAttributedText:commentToDisplay.commentText andWidth:(215.f)];
        return 50.f + heightOfTextView;
    }
}

#pragma mark - configureCellWithComment
- (void)configureCellWithComment:(Comment *)comment {
    self.userNameLabel.text = comment.commentatorName;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss.SSSSSS'+'00:00"];
    NSString *stringFromDate = [dateFormat stringFromDate:comment.commentDate];
    self.commentDateLabel.text = stringFromDate;
    [self.textLabel sizeToFit];
}

#pragma mark - TextViewSizeDependingOnText

+ (CGFloat)textViewHeightForAttributedText:(NSString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

@end
