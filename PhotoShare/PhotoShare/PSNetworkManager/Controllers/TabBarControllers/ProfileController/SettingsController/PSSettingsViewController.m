//
//  PSSettingsViewController.m
//  PhotoShare
//
//  Created by Евгений on 13.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSSettingsViewController.h"
#import "PSUserStore.h"
#import "User.h"
#import "CustomUnwindSegue.h"

@interface PSSettingsViewController()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

- (IBAction)logout:(id)sender;

@end


@implementation PSSettingsViewController

- (IBAction)logout:(id)sender {
    
    
    //check for userWithEmptyEmail in database and add it if such object doesn't exist
    User *userWithEmptyEmail=[[User MR_findByAttribute:@"email" withValue:@""] firstObject];
    if (!userWithEmptyEmail)
    {
       // userWithEmptyEmail=[User MR_createEntity];
        userWithEmptyEmail.email=@"";
        [PSUserStore userStoreManager].activeUser=userWithEmptyEmail;
        [userWithEmptyEmail.managedObjectContext MR_saveToPersistentStoreAndWait];
        NSLog(@"logout. user with email:%@",[PSUserStore userStoreManager].activeUser.email);
    }
    
    else
        
    {
        [PSUserStore userStoreManager].activeUser=userWithEmptyEmail;
        NSLog(@"logout. user with email:%@",[PSUserStore userStoreManager].activeUser.email);
    }
    
    
    
 
    [self performSegueWithIdentifier:@"afterLoggedOutToSplash" sender:nil];
    

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue isKindOfClass:[CustomUnwindSegue class]])
    {
        // Set the start point for the animation to center of the button for the animation
        ((CustomUnwindSegue *)segue).targetPoint = self.view.center;
    }
}


@end
