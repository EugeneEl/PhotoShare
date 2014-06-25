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
#import "Post.h"

@interface PSDetailedPhotoContollerViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *useravaImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeOfPhotoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *likesNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoNameLabel;



@property (nonatomic,strong) NSArray*  arrayOfImages;
@property (strong, atomic)   ALAssetsLibrary* library;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) SLComposeViewController *slsCompositeViewController;
@property (nonatomic, strong) NSData *imageDataToShare;


- (IBAction)actionCommentPhoto:(id)sender;
- (IBAction)actionSharePhoto:(id)sender;

- (void)shareByEmail:(NSData *) photoData;
- (void)sharePhotoToFaceBook;
- (void)sharePhotoToTwitter:(NSData *)photoData;

@end

@implementation PSDetailedPhotoContollerViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.library = [[ALAssetsLibrary alloc] init];
    
    
    [self.usernameLabel setText:_post.authorMail];
    
    //"2015-01-01 06:35:40:622 GMT"
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    
    [self.timeOfPhotoLabel setText:[dateFormatter stringFromDate:_post.photoDate]];
    [self.photoNameLabel setText:_post.photoName];
    [self.likesNumLabel setText:[NSString stringWithFormat:@"%i", [_post.likes intValue]]];
    
    [self.commentsNumLabel setText:[NSString stringWithFormat:@"%i", [_post.comments count]]];
    
    [self.likeImageView setImage:[UIImage imageNamed:@"heart-icon.png"]];
    [self.commentImageView setImage:[UIImage imageNamed:@"comment.png"]];
    
    NSURL *urlForImage=[NSURL URLWithString:_post.photoURL];
    
    
    NSData *data=[NSData new];
    data=[NSData dataWithContentsOfURL:urlForImage];
    self.image=[UIImage imageWithData:data];
    [self.photoImageView setImage:self.image];
    self.imageDataToShare=UIImageJPEGRepresentation(self.image, 1.0);
    //  self.imageToShare=
    [self.photoImageView setContentMode:UIViewContentModeScaleAspectFit];
    //[self.photoImageView setImageWithURL:urlForImage];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    
}

- (IBAction)actionCommentPhoto:(id)sender {
}

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




#pragma mark - MethodsForSharing

- (void)sharePhotoToTwitter:(NSData *)photoData
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        self.slsCompositeViewController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [self.slsCompositeViewController setInitialText:self.post.photoName];
        if (!photoData)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"alertViewOnTwitterErrorNoPhotoKey", "") delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        [self.slsCompositeViewController addImage:[UIImage imageWithData:photoData]];
        [self presentViewController:self.slsCompositeViewController animated:YES completion:nil];
    }
    
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                                      message:NSLocalizedString(@"alertViewOnTwitterConfigerAccountKey", "")
                                                     delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "") otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)sharePhotoToFaceBook
{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        self.slsCompositeViewController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [self.slsCompositeViewController setInitialText:self.post.photoName];
        if (!self.image) {
            UIAlertView *alert=[[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                message:NSLocalizedString(@"alertViewOnTwitterErrorNoPhotoKey", "") delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "") otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        self.imageDataToShare=UIImageJPEGRepresentation(self.image, 1.0);
        [self.slsCompositeViewController addImage:[UIImage imageWithData:self.imageDataToShare]];
        [self presentViewController:self.slsCompositeViewController animated:YES completion:nil];
        
        
    }
    
    else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                message:NSLocalizedString(@"alertViewOnFacebookConfigerAccountKey", "")
                                                     delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "") otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)shareByEmail:(NSData *)photoData {
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    
    if([MFMailComposeViewController canSendMail]) {
      //  [composer setToRecipients:[nil;
        [composer setSubject:NSLocalizedString(@"subjectForMailTitleKey", "")  ];
        [composer setMessageBody:self.post.photoName isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        
        
        [composer addAttachmentData:photoData  mimeType:@"image/jpeg" fileName:@"Photograph.jpg"];
        
       [self presentViewController:composer animated:YES completion:NULL];
    }
    else
    {
     
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                            message:NSLocalizedString(@"alertViewOnMailConfigerAccountKey","")
                            delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
                            otherButtonTitles:nil, nil];
        [alert show];
   
    }
    
   
}


- (void)savePhotoFromPost:(Post *)post {
    
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_post.photoURL ]];
    
    UIImage *imageTemp=[UIImage imageWithData:imageData];
    
    
    [self.library saveImage:imageTemp toAlbum:@"PhotoShare" withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            UIAlertView *alert=[[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                message:@"Failed to save photo"
                                delegate:nil
                                cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
                                otherButtonTitles:nil, nil];
            NSLog(@"Error: %@", [error description]);
            [alert show];
        }
        
        
        UIAlertView *alert=[[UIAlertView alloc]
                            initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                            message:NSLocalizedString(@ "alertViewOnSaveSuccessKey", "")
                            delegate:nil
                            cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                            otherButtonTitles:nil, nil];
        [alert show];
        
    }];
    
    NSLog(@"image:%@",imageTemp);
    
}

#pragma mark - UIActionSheetDelegate 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // NSLog(@"Была нажата кнопка с номером - %d",buttonIndex);
    //Cancel   0
    //Email    1
    //Twitter  2
    //FaceBook 3
    //Save     4

    
    switch (buttonIndex) {
        case 1: //Email photo
            
            [self shareByEmail:self.imageDataToShare];
            break;
            
        case 2:
            [self sharePhotoToTwitter:self.imageDataToShare];
            break;
            
        case 3:
            [self sharePhotoToFaceBook];
            break;
            
        case 4:
            [self savePhotoFromPost:_post];
            break;
            
        default:
            break;
    }
}

#pragma mark Mail Compose Delegate Methods
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
