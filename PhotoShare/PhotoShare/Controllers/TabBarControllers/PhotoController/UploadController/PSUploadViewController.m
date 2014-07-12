//
//  PSUploadViewController.m
//  PhotoShare
//
//  Created by Евгений on 07.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSUploadViewController.h"
#import "PSNetworkManager.h"
#import <CoreLocation/CoreLocation.h>


@interface PSUploadViewController () <CLLocationManagerDelegate, UITextViewDelegate>


@property (nonatomic, strong) NSString *text;
- (IBAction)dismissKeyboardOnTap:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *photoNameTextView;
- (IBAction)sendPhoto:(id)sender;

@end


@implementation PSUploadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    



    
    
        self.text=@"text";
    

}




- (IBAction)sendPhoto:(id)sender
{
    
    if ((_image) && (_userID) && (self.lat) && (self.lng) && (_text))
    {
        
        [[PSNetworkManager sharedManager] sendImage:self.image withLatitude:self.lat
                                      andLongtitude:self.lng
                                           withText:_text fromUserID:_userID
        success:^(id responseObject)
        {
          NSLog(@"image send successfully");
            UIAlertView *alert=[[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@ "alertViewOkKey", "")
                                message:NSLocalizedString(@"alertViewSuccessKey", "")
                                delegate:nil
                                cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                otherButtonTitles:nil, nil];
            [alert show];
        }
        error:^(NSError *error)
        {
            
        }];

    }
    else if ((!_lat) || (!_lng))
    {
        NSLog(@"problem with location");
    }
    else
    {
         NSLog(@"an error has occurred");
    }
}





#pragma mark - UITextFieldDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    _text=textView.text;
    
}



- (IBAction)dismissKeyboardOnTap:(id)sender
{
       [[self view] endEditing:YES];
}


@end
