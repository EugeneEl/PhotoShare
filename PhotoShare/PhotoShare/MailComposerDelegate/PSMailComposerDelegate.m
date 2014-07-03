//
//  PSMailComposerDelegate.m
//  PhotoShare
//
//  Created by Евгений on 02.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//
#import "PSMailComposerDelegate.h"

@implementation PSMailComposerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    NSLog(@"in didFinishWithResult:");
    switch (result) {
        case MFMailComposeResultCancelled:
            _didCancel(controller);
                        break;
        case MFMailComposeResultSaved:
            _didSave(controller);
            break;
        case MFMailComposeResultSent:
            _didSend(controller);
            break;
        case MFMailComposeResultFailed: {
                 break;
        }
        default:
            break;
    }
}

@end
