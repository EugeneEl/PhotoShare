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

@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvaImageView;
@property (nonatomic, weak) IBOutlet UILabel *commentLabel;


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
    _commentLabel.text = comment.commentText;
       
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void)
                   {
                       NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:comment.commentatorAvaURL]];
                       
                       UIImage* image = [[UIImage alloc] initWithData:imageData];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [_userAvaImageView setImage:image];
                                         // [_userAvaImageView setNeedsLayout]; //test here
                                      });
                   });
    
    
}

#pragma mark - PrepareForReuse 
- (void)prepareForReuse {
    //need some fix here to call cellHeightForObject: every time before reuse
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
