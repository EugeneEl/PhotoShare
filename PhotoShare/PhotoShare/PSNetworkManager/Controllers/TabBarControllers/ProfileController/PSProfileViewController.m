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
@property (strong,nonatomic)  NSFetchedResultsController *fetchedResultsController;

@end

@implementation PSProfileViewController



-(void)viewDidLoad {
    
    [super viewDidLoad];
    NSArray* tempArray=[Post MR_findAll];
    self.arrayOfPosts=[tempArray mutableCopy];
    
    
    self.arrayOfURLPhotos=[NSMutableArray new];
    
    for (Post *post in self.arrayOfPosts) {
        
        [self.arrayOfURLPhotos addObject:post.photoURL];
       
    }
    
    for (NSString *photoURLString in self.arrayOfURLPhotos) {
        NSLog(@"added to an array photoURL:%@",photoURLString);
    }
    
    int a;
    
}

/*
-(NSMutableArray*)arrayOfPosts {
    if (!_arrayOfURLPhotos) {
        _arrayOfURLPhotos=[NSMutableArray new];
    }
    return _arrayOfURLPhotos;
}

-(NSMutableArray*)arrayOfURLPhotos {
    if (!_arrayOfURLPhotos) {
        _arrayOfURLPhotos=[NSMutableArray new];
    }
    return _arrayOfURLPhotos;
}

/*

/*

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    
    
    
    NSFetchRequest* fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Post"];
    
    
    NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"postID" ascending:YES ];
    
    [fetchRequest setSortDescriptors:@[descriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:[NSManagedObjectContext MR_defaultContext]
                                                             sectionNameKeyPath:nil
                                                             cacheName:nil];
    
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    //[self.photoCollectionView beginUpdates];
}




- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.photoCollectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
//            [self.photoCollectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
//                                withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
//            [self.streamTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
//                                withRowAnimation:UITableViewRowAnimationFade];
            [self.photoCollectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            break;
    }
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UICollectionView *collectionView = self.photoCollectionView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [collectionView insertItemsAtIndexPaths:indexPath];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
        break;    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.streamTableView endUpdates];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    /*
    PSPhotoFromStreamTableViewCell *aCell = (id)cell;
    
    Post  *postTest=[self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell=(PSPhotoFromStreamTableViewCell*)cell;
    
    aCell.photoNameLabel.text=postTest.photoName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSString *stringFromDate = [dateFormatter stringFromDate:postTest.photoDate];
    aCell.photoDateLabel.text=stringFromDate;
    
    
    [aCell.imageForPost setImageWithURL: [NSURL URLWithString:postTest.photoURL]];
    
    
    
    aCell.likesNumberLabel.text=[NSString stringWithFormat:@"%@",postTest.likes];
 
    
}
*/



//http://www.youtube.com/watch?v=8vB2TMS2uhE


#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  [self.arrayOfURLPhotos count];

}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *viewCellIdentifier=@"collectionCellForPhoto";
    
    PSCollectionCellForPhoto *cell=[self.photoCollectionView dequeueReusableCellWithReuseIdentifier:viewCellIdentifier forIndexPath:indexPath];

    
    //UIImage *image=(UIImage*)[cell viewWithTag:50];
    
    
   // [self configureCell:cell atIndexPath:indexPath];
    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [cell.layer setCornerRadius:50.0f];

    [cell.imageForPhoto setImageWithURL:[NSURL URLWithString:[self.arrayOfURLPhotos objectAtIndex:indexPath.row]]];

    return cell;
}


@end




