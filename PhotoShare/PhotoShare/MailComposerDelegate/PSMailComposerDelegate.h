//
//  PSMailComposerDelegate.h
//  PhotoShare
//
//  Created by Евгений on 02.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface PSMailComposerDelegate : NSObject <MFMailComposeViewControllerDelegate>

typedef void (^MailComposeControllerCompletionHandler)(MFMailComposeViewController *controller);

@property (nonatomic,copy) MailComposeControllerCompletionHandler didSave;
@property (nonatomic,copy) MailComposeControllerCompletionHandler didCancel;
@property (nonatomic,copy) MailComposeControllerCompletionHandler didSend;


@end
