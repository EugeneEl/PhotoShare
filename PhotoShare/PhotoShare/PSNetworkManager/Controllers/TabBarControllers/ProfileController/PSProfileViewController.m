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

static NSString *viewCellIdentifier=@"collectionCellForPhoto";

@interface
PSProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak)   IBOutlet UICollectionView *photoCollectionView;

@property (nonatomic, strong) NSMutableArray *arrayOfURLPhotos;

@property (weak, nonatomic) IBOutlet UIImageView *avaImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countsOfPostsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfFlollowingsLabel;
- (IBAction)actionFindFriends:(id)sender;
- (IBAction)actionToFollowers:(id)sender;
- (IBAction)actionToFollowings:(id)sender;
@property (nonatomic, copy) NSMutableArray *arrayOfPosts;
@property (nonatomic, strong) User *userToDisplay;

@end

@implementation PSProfileViewController

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    if (_userToDisplay!=[User getCurrentUser]) {
        
    }
    else {
        
        _arrayOfPosts=[[Post MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"user.user_id==%@",[User getCurrentUser].user_id] mutableCopy]];
        NSLog(@"Posts:",_arrayOfPosts);
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

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [self.arrayOfURLPhotos count];
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSCollectionCellForPhoto *cell=[self.photoCollectionView dequeueReusableCellWithReuseIdentifier:viewCellIdentifier forIndexPath:indexPath];
    [cell.imageForPhoto setImageWithURL:[NSURL URLWithString:[self.arrayOfURLPhotos objectAtIndex:indexPath.row]]];
    return cell;
    
}

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




