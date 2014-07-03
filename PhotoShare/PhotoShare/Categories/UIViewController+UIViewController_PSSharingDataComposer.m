//
//  UIViewController+UIViewController_PSSharingDataComposer.m
//  PhotoShare
//
//  Created by Евгений on 27.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "UIViewController+UIViewController_PSSharingDataComposer.h"
#import <Social/Social.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <MessageUI/MessageUI.h>
#import "Post.h"


@interface UIVideoEditorController ()

@end

@implementation UIViewController (PSSharingDataComposer) 
static NSString *PSSharingErrorDomain = @"PSSharingErrorDomain";
static NSInteger PSTwitterSharingErrorCode  = 101;
static NSInteger PSFacebookSharingErrorCode = 102;
static NSInteger PSMailBookSharingErrorCode=103;


static NSInteger PSSharingErrorNoPhotoData = 100;

- (void)shareToTwitterWithData:(NSData*)photoData
                     photoName:(NSString*)photoTitle
                       success:(void(^)(void))success
                       failure:(void(^)(NSError *error))failure
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSTwitterSharingErrorCode userInfo:nil] );
        return;
    }
    
    if (!photoData) {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSSharingErrorNoPhotoData userInfo:nil] );
        return;
    }
    
    SLComposeViewController* slsCompositeViewController=[SLComposeViewController
    composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    
    slsCompositeViewController.completionHandler = ^(SLComposeViewControllerResult result)
    {
        switch(result)
        {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                success();
                break;
        }
    };
    
    [slsCompositeViewController setInitialText:photoTitle];
    [slsCompositeViewController addImage:[UIImage imageWithData:photoData]];
    [self presentViewController:slsCompositeViewController animated:YES completion:nil];
    
    //success();
    
}


- (void)shareToFacebookWithData:(NSData*)photoData
                      photoName:(NSString*)photoTitle
                        success:(void(^)(void))success
                        failure:(void(^)(NSError *error))failure
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSFacebookSharingErrorCode userInfo:nil] );
        return;
    }
    
    if (!photoData) {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSSharingErrorNoPhotoData userInfo:nil] );
        return;
    }
    
    SLComposeViewController* slsCompositeViewController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    slsCompositeViewController.completionHandler = ^(SLComposeViewControllerResult result)
    {
        switch(result)
        {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                success();
                break;
        }
    };

    
    [slsCompositeViewController setInitialText:photoTitle];
    [slsCompositeViewController addImage:[UIImage imageWithData:photoData]];
    [self presentViewController:slsCompositeViewController animated:YES completion:nil];
    

        //success();
    
}


- (void)SaveToAlbumWithData:(NSData*)photoData
                        success:(void(^)(void))success
                        failure:(void(^)(NSError *error))failure
{
    if (!photoData) {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSSharingErrorNoPhotoData userInfo:nil] );
        return;
    }
    
     UIImage *imageTemp=[UIImage imageWithData:photoData];
    ALAssetsLibrary  *library=[ALAssetsLibrary new];
    
    [library saveImage:imageTemp toAlbum:@"PhotoShare" withCompletionBlock:^(NSError *error)
    {
        if (error!=nil)
        {
            failure(error);
            return;
        }
        else
            success();

    }];
    
}




- (void)shareByEmail:(NSData *)photoData
           photoName:(NSString*)photoTitle
             success:(void(^)(void))success
             failure:(void(^)(NSError *error))failure
{
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    
    
    
   // PSMailComposerDelegate *delegateForMC=[PSMailComposerDelegate new];
    
    if (![MFMailComposeViewController canSendMail])
    {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSMailBookSharingErrorCode userInfo:nil] );
        return;
    }
    
    else
    {
        [composer setSubject:NSLocalizedString(@"subjectForMailTitleKey", "")  ];
        [composer setMessageBody:photoTitle isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [composer setDelegate:self];
        
        [composer addAttachmentData:photoData  mimeType:@"image/jpeg" fileName:@"Photograph.jpg"];
        
        [self presentViewController:composer animated:YES completion:success];
        
        //success();
 
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    NSLog(@"in didFinishWithResult:");
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"sent");
            break;
        case MFMailComposeResultFailed: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                        cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                                  otherButtonTitles:nil];
            [alert show];

            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
