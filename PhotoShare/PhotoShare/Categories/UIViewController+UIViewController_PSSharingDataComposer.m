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
#import "Post.h"


@interface UIVideoEditorController ()

@end

@implementation UIViewController (PSSharingDataComposer) 
static NSString *PSSharingErrorDomain = @"PSSharingErrorDomain";
static NSInteger PSTwitterSharingErrorCode  = 101;
static NSInteger PSFacebookSharingErrorCode = 102;
static NSInteger PSMailBookSharingErrorCode=103;


static NSInteger PSSharingErrorNoPhotoData = 100;

#pragma mark - ShareToTwiiter
- (void)shareToTwitterWithData:(NSData *)photoData
                               photoName:(NSString *)photoTitle
                               success:(void(^)(void))success
                               failure:(void(^)(NSError *error))failure {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSTwitterSharingErrorCode userInfo:nil] );
        return;
    }
    
    if (!photoData) {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSSharingErrorNoPhotoData userInfo:nil] );
        return;
    }
    
    SLComposeViewController *slsCompositeViewController = [SLComposeViewController
    composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    slsCompositeViewController.completionHandler = ^(SLComposeViewControllerResult result)
    {
        switch(result)
        {

            case SLComposeViewControllerResultCancelled:
                break;

            case SLComposeViewControllerResultDone:
                success();
                break;
        }
    };
    
    [slsCompositeViewController setInitialText:photoTitle];
    [slsCompositeViewController addImage:[UIImage imageWithData:photoData]];
    [self presentViewController:slsCompositeViewController animated:YES completion:nil];
    
    
}

#pragma mark - shareToFaceBook
- (void)shareToFacebookWithData:(NSData *)photoData
                      photoName:(NSString *)photoTitle
                        success:(void(^)(void))success
                        failure:(void(^)(NSError *error))failure {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSFacebookSharingErrorCode userInfo:nil] );
        return;
    }
    
    if (!photoData) {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSSharingErrorNoPhotoData userInfo:nil] );
        return;
    }
    
    SLComposeViewController *slsCompositeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    slsCompositeViewController.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result)
        {
 
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                success();
                break;
        }
    };

    
    [slsCompositeViewController setInitialText:photoTitle];
    [slsCompositeViewController addImage:[UIImage imageWithData:photoData]];
    [self presentViewController:slsCompositeViewController animated:YES completion:nil];
    
}

#pragma mark - saveToAlbum
- (void)SaveToAlbumWithData:(NSData *)photoData
                        success:(void(^)(void))success
                        failure:(void(^)(NSError *error))failure
{
    if (!photoData) {
        failure([[NSError alloc] initWithDomain:PSSharingErrorDomain code:PSSharingErrorNoPhotoData userInfo:nil] );
        return;
    }
    
     UIImage *imageTemp = [UIImage imageWithData:photoData];
    ALAssetsLibrary  *library = [ALAssetsLibrary new];
    
    [library saveImage:imageTemp toAlbum:@"PhotoShare" withCompletionBlock:^(NSError *error)
    {
        if (error)
        {
            failure(error);
            return;
        }
        else
            success();

    }];
    
}


@end
