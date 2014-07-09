//
//  PSAddCommentViewController.m
//  PhotoShare
//
//  Created by Евгений on 09.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSAddCommentViewController.h"
#import "PSNetworkManager.h"

@interface PSAddCommentViewController() <UITextViewDelegate>
- (IBAction)actionSendComment:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (nonatomic, strong)
NSString *textForComment;
@end

@implementation PSAddCommentViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
  
}

- (IBAction)dismissKeyboard:(id)sender {
    [[self view] endEditing:YES];
}


- (IBAction)actionSendComment:(id)sender {
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    _textForComment=textView.text;
    
}

@end


