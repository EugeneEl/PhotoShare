//
//  PSProfileViewController.m
//  PhotoShare
//
//  Created by Евгений on 13.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSProfileViewController.h"
#import "PSFindFriendsViewController.h"
#import "Post.h"
#import "Comment.h"
#import "PSCollectionCellForPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "User+PSGetCurrentUser.h"
#import  "PSNetworkManager.h"
#import "User+PSUpdatePosts.h"

static NSString *viewCellIdentifier=@"collectionCellForPhoto";

@interface
PSProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, weak) IBOutlet UIImageView *avaImageView;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel *countsOfPostsLabel;
@property (nonatomic, weak) IBOutlet UILabel *countOfFollowersLabel;
@property (nonatomic, weak) IBOutlet UILabel *countOfFlollowingsLabel;
- (IBAction)actionFindFriends:(id)sender;
- (IBAction)actionToFollowers:(id)sender;
- (IBAction)actionToFollowings:(id)sender;
@property (nonatomic, strong) NSMutableArray *arrayOfURLPhotos;
@property (nonatomic, copy) NSMutableArray *arrayOfPosts;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, assign) BOOL displayMe;

@end

@implementation PSProfileViewController

#pragma mark - viewDidLoad
-(void)viewDidLoad {
    
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    _displayMe=YES;
    
    if (_userToDisplay!=[User getCurrentUser]) {
        NSLog(@"display another user");
        _displayMe=NO;
    }
    if (_displayMe) {

            _currentUser=[User getCurrentUser];
            NSArray *array=[[Post MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"user.user_id==%@",_currentUser.user_id]] mutableCopy];
            
            _arrayOfPosts=[array mutableCopy];
            NSLog(@"Posts:%@",_arrayOfPosts);
            NSArray* tempArray=[Post MR_findAll];
            self.arrayOfPosts=[tempArray mutableCopy];
            self.arrayOfURLPhotos=[NSMutableArray new];
            for (Post *post in self.arrayOfPosts)
            {
                
                [self.arrayOfURLPhotos addObject:post.photoURL];
                
            }
            
            for (NSString *photoURLString in self.arrayOfURLPhotos)
            {
                NSLog(@"added to an array photoURL:%@",photoURLString);
            }
    }
    else {
        NSArray *array=[Post MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"user.user_id==%@",_userToDisplay.user_id]];
        
        if (!array) {
            [_userToDisplay updatePostsForUserID:[_userToDisplay.user_id intValue]];
        }
        array=[Post MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"user.user_id==%@",_userToDisplay.user_id]];
        
        _arrayOfPosts=[array mutableCopy];
        
        
        NSLog(@"Posts:%@",_arrayOfPosts);
        NSArray* tempArray=[Post MR_findAll];
        self.arrayOfPosts=[tempArray mutableCopy];
        self.arrayOfURLPhotos=[NSMutableArray new];
        for (Post *post in self.arrayOfPosts)
        {
            
            [self.arrayOfURLPhotos addObject:post.photoURL];
            
        }
        
        for (NSString *photoURLString in self.arrayOfURLPhotos)
        {
            NSLog(@"added to an array photoURL:%@",photoURLString);
        }

    }
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   // [_arrayOfPosts removeAllObjects];
    //[_arrayOfURLPhotos removeAllObjects];
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  [self.arrayOfURLPhotos count];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSCollectionCellForPhoto *cell=[self.photoCollectionView dequeueReusableCellWithReuseIdentifier:viewCellIdentifier forIndexPath:indexPath];
    [cell.imageForPhoto setImageWithURL:[NSURL URLWithString:[self.arrayOfURLPhotos objectAtIndex:indexPath.row]]];
    return cell;
    
}


#pragma mark - FriendsAction
- (IBAction)actionFindFriends:(id)sender {
    [self performSegueWithIdentifier:@"goToFindFriends" sender:sender];
}

- (IBAction)actionToFollowers:(id)sender {
}

- (IBAction)actionToFollowings:(id)sender {
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToFindFriends"]) {
        PSFindFriendsViewController *destinationController=(PSFindFriendsViewController *)segue.destinationViewController;
    }
}


@end




