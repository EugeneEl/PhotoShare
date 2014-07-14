//
//  PSDetailedPhotoContollerViewController.m
//  PhotoShare
//
//  Created by Евгений on 20.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSDetailedPhotoContollerViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Social/Social.h>
#import "UIImageView+AFNetworking.h"
#import "UIViewController+UIViewController_PSSharingDataComposer.h"
#import "Post.h"
#import "Like.h"
#import "PSUserStore.h"
#import "PSNetworkManager.h"
#import "Like+mapWithEmail.h"
#import <MessageUI/MessageUI.h>

static NSString *PSSharingErrorDomain = @"PSSharingErrorDomain";
static NSInteger PSMailBookSharingErrorCode=103;

@interface PSDetailedPhotoContollerViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *useravaImageView;
@property (nonatomic, weak) IBOutlet UILabel *timeOfPhotoLabel;
@property (nonatomic, weak) IBOutlet UIImageView *photoImageView;
@property (nonatomic, weak) IBOutlet UILabel *likesNumLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentsNumLabel;
@property (nonatomic, weak) IBOutlet UILabel *photoNameLabel;
@property (nonatomic, copy) NSData *photoData;
@property (nonatomic, strong) NSArray *arrayOfImages;
@property (atomic, strong)   ALAssetsLibrary *library;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) SLComposeViewController *slsCompositeViewController;
@property (nonatomic, copy) NSData *imageDataToShare;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, assign) int userID;
@property (nonatomic, strong) NSString *authorMailParsed;
@property (nonatomic, assign) BOOL isWaitingForLikeResponse;

@property (nonatomic, assign)BOOL likesStatus;

- (IBAction)actionCommentPhoto:(id)sender;
- (IBAction)actionSharePhoto:(id)sender;
- (IBAction)actionLikePhoto:(id)sender;

@end

@implementation PSDetailedPhotoContollerViewController

#pragma mark - initWithPost
- (instancetype)initWithPost:(Post *)post {
    if (self = [super init]) {
        _post = post;
    }
    
    return self;
}

- (id)init {
    NSAssert(NO, @"No default initialization available");
    return nil;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _library = [[ALAssetsLibrary alloc] init];
    [self.usernameLabel setText:_post.authorMail];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    [self.timeOfPhotoLabel setText:[dateFormatter stringFromDate:_post.photoDate]];
    [self.photoNameLabel setText:_post.photoName];
    [self.commentsNumLabel setText:[NSString stringWithFormat:@"%i", [_post.comments count]]];
    NSURL *urlForImage = [NSURL URLWithString:_post.photoURL];
    NSData *data = [NSData dataWithContentsOfURL:urlForImage];
    _photoData = [NSData dataWithContentsOfURL:urlForImage];
    _image = [UIImage imageWithData:data];
    [self.photoImageView setImage:self.image];
    _imageDataToShare = UIImageJPEGRepresentation(self.image, 1.0);
    [self.photoImageView setContentMode:UIViewContentModeScaleAspectFit];
    PSUserStore *userStore = [PSUserStore userStoreManager];
    _currentUser = userStore.activeUser;
    _userID = [_currentUser.user_id integerValue];
    _authorMailParsed = _currentUser.email;
    _likesStatus=NO;
    for (Like *like in [_post.likes allObjects]) {
        if (_authorMailParsed == like.email) {
            _likesStatus = YES;
            break;
        }
    }
    
    if (_likesStatus) {
        [_likeButton setImage:[UIImage imageNamed:@"grey_heart"] forState:UIControlStateNormal];
    }
    else {
        [_likeButton setImage:[UIImage imageNamed:@"heart-icon.png"] forState:UIControlStateNormal];
    }
}


#pragma marl - viewWillApear
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}


#pragma mark - commentPhoto
- (IBAction)actionCommentPhoto:(id)sender {
    
}


#pragma mark - sharePhoto
- (IBAction)actionSharePhoto:(id)sender {
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Share"
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString
                                  (@"actionSheetButtonCancelNameKey", "")
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil, nil];
    
    
    [actionSheet setTitle:NSLocalizedString(@"actionSheetTitleNameKey", "")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"actionSheetButtonEmailNameKey", "")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"actionSheetButtonTwitterNameKey", "")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"actionSheetButtonFacebookNameKey", "")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"actionSheetButtonSaveNameKey", "")];
    
    //without next line action sheet does not appear on iphone 3.5 inch
    [actionSheet showFromTabBar:(UIView*)self.view];
}


#pragma mark - likePhoto
- (IBAction)actionLikePhoto:(id)sender {
    __weak typeof(self) weakSelf = self;
    if (!_likesStatus)
    {
        if (_isWaitingForLikeResponse) return;
        _isWaitingForLikeResponse = YES;
        
        [[PSNetworkManager sharedManager]
         likePostWithID:[_post.postID intValue]
         byUser:_userID
         success:^(id responseObject)
         {
             NSLog(@"liked successfully");
             Like *likeToAdd = [Like MR_createEntity];
             [likeToAdd mapWithEmail:_authorMailParsed];
             [weakSelf.post addLikesObject:likeToAdd];
             weakSelf.likesStatus = YES;
             [weakSelf.likeButton setImage:[UIImage imageNamed:@"heart-icon.png"] forState:UIControlStateNormal];
             [weakSelf.post.managedObjectContext MR_saveToPersistentStoreAndWait];
             weakSelf.isWaitingForLikeResponse = NO;
             
         }
         error:^(NSError *error)
         {
             weakSelf.isWaitingForLikeResponse = NO;
             NSLog(@"error");
         }];
    }
    
    
    if (_likesStatus) {
        if (_isWaitingForLikeResponse) return;
        _isWaitingForLikeResponse = YES;
        [[PSNetworkManager sharedManager] unlikePostWithID:[_post.postID intValue]
                                                    byUser:_userID
                                                   success:^(id responseObject)
         {
             
             NSLog(@"unlikes success ");
             weakSelf.likesStatus = NO;
             [weakSelf.likeButton setImage:[UIImage imageNamed:@"grey_heart.png"] forState:UIControlStateNormal];
             weakSelf.isWaitingForLikeResponse = NO;
             for (Like *like in _post.likes)
             {
                 if ([like.email isEqualToString:weakSelf.authorMailParsed])
                 {
                     [weakSelf.post removeLikesObject:like];
                     break;
                 }
             }
             [weakSelf.post.managedObjectContext MR_saveToPersistentStoreAndWait];
             weakSelf.isWaitingForLikeResponse = NO;
         }
         error:^(NSError *error)
         {
             weakSelf.isWaitingForLikeResponse = NO;
             NSLog(@"error");
         }];
    }
}




#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        {case 1: //Email photo
            
            [self shareByEmail:_imageDataToShare photoName:_post.photoName
                       success:^
             {
                 
                 //NSLog(@"Photo was posted to facebook successfully");
                 UIAlertView *alert = [[UIAlertView alloc]
                                     initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                                     message:NSLocalizedString(@"alertViewOnMailSuccesstKey","")
                                     delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
             
             
                       failure:^(NSError *error)
             {
                 if (error.code == 100)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"alertViewOnTwitterErrorNoPhotoKey", "") delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")  otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }
                 
                 else if (error.code == 103)
                 {
                     UIAlertView *alert=[[UIAlertView alloc]
                                         initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                         message:NSLocalizedString(@"alertViewOnMailConfigerAccountKey","")
                                         delegate:nil
                                         cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
                                         otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 
             }];
            
            
            break;}
            
        {
        case 2:
            [self shareToTwitterWithData:_imageDataToShare
                               photoName:_post.photoName
                                 success:^
             {
                 NSLog(@"Photo was tweeted successfully");
                 UIAlertView *alert = [[UIAlertView alloc]
                                     initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                                     message:NSLocalizedString(@   "alertViewOnTwitterSuccesstKey","")
                                     delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                     otherButtonTitles:nil, nil];
                 [alert show];
                 
             }
             
                                 failure:^(NSError *error)
             {
                 
                 if (error.code == 100)
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"alertViewOnTwitterErrorNoPhotoKey", "") delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")  otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }
                 
                 else if (error.code == 101)
                 {
                     UIAlertView *alert = [[UIAlertView alloc]
                                         initWithTitle:NSLocalizedString(@"alertViewOnTwitterConfigerAccountKey", "")
                                         message:NSLocalizedString(@"alertViewOnMailConfigerAccountKey","")
                                         delegate:nil
                                         cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
                                         otherButtonTitles:nil, nil];
                     [alert show];
                 }
             }
             ];
            
            
            break;}
            
        {case 3:
            
            [self shareToFacebookWithData:_imageDataToShare photoName:_post.photoName
                                  success:^
             {
                 NSLog(@"Photo was successfully posted to facebook");
                 UIAlertView *alert = [[UIAlertView alloc]
                                     initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                                     message:NSLocalizedString(@ "alertViewOnFacebookSuccesstKey","")
                                     delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
                                  failure:^(NSError *error) {
                                      
                                      if (error.code == 100)
                                      {
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"alertViewOnTwitterErrorNoPhotoKey", "") delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")  otherButtonTitles:nil, nil];
                                          [alert show];
                                          
                                      }
                                      
                                      else if (error.code == 102)
                                      {
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                                                                        message:NSLocalizedString(@"alertViewOnFacebookConfigerAccountKey", "")
                                                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "") otherButtonTitles:nil, nil];
                                          [alert show];
                                          
                                      }
                                      
                                  }];
            
            
            
            break;
        }
            
        {case 4:
            [self SaveToAlbumWithData:_imageDataToShare
                              success:^{
                                  UIAlertView *alert = [[UIAlertView alloc]
                                                      initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                                                      message:NSLocalizedString(@ "alertViewOnSaveSuccessKey", "")
                                                      delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                                      otherButtonTitles:nil, nil];
                                  [alert show];
                              }
                              failure:^(NSError *error) {
                                  
                                  UIAlertView *alert = [[UIAlertView alloc]
                                                      initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                                                      message:NSLocalizedString(@ "alertViewOnSaveSuccessKey", "")
                                                      delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                                      otherButtonTitles:nil, nil];
                                  [alert show];
                                  
                              }];
            
            break;
        }
        default:
            break;
    }
}



#pragma mark - ShareByMail

- (void)shareByEmail:(NSData *)photoData
           photoName:(NSString*)photoTitle
             success:(void(^)(void))success
             failure:(void(^)(NSError *error))failure
{
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    
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
