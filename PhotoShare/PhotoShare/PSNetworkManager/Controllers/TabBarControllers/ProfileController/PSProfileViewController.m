//
//  PSProfileViewController.m
//  PhotoShare
//
//  Created by Евгений on 13.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSProfileViewController.h"
#import "Post.h"
#import "Comment.h"
#import "PSCollectionCellForPhoto.h"
#import "UIImageView+AFNetworking.h"

@interface
PSProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak)   IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSMutableArray *arrayOfURLPhotos;
@property (nonatomic, strong) NSMutableArray *arrayOfPosts;

@end

@implementation PSProfileViewController

-(void)viewDidLoad
{
    
    [super viewDidLoad];
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

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [self.arrayOfURLPhotos count];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *viewCellIdentifier=@"collectionCellForPhoto";
    
    PSCollectionCellForPhoto *cell=[self.photoCollectionView dequeueReusableCellWithReuseIdentifier:viewCellIdentifier forIndexPath:indexPath];

    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [cell.layer setCornerRadius:50.0f];

    [cell.imageForPhoto setImageWithURL:[NSURL URLWithString:[self.arrayOfURLPhotos objectAtIndex:indexPath.row]]];

    return cell;
}


@end



