//
//  PSFoundUsers.m
//  PhotoShare
//
//  Created by Евгений on 10.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSFoundUsersViewController.h"
#import "PSFoundUserTableViewCell.h"

@interface PSFoundUsersViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *likeFetchedResultsController;

@end

@implementation PSFoundUsersViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super init];
    if (self) {
        _arrayOfUsersToDisplay=[NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

   // [_tableView setDelegate:self];
   // [_tableView setDataSource:self];
    [self fetchUsers];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayOfUsersToDisplay count];
    }



////
////- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
////    static NSString *cellIdentifier = @"userCell";
////     PSFoundUserTableViewCell *  cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//////    [cell configureCellWithFollower:[_arrayOfUsersToDisplay objectAtIndex:indexPath.row]];
////    return cell;
////}
//


- (void)fetchUsers {
//    NSFetchedResultsController *fetchedResultsConbtroller;
//    if (_likeFetchedResultsController!=nil) {
//        return _likeFetchedResultsController;
//    }
//    
    NSFetchRequest* fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"User"];
    NSSortDescriptor *desciptor=[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:@[desciptor]];
//    NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"followers" ascending:NO];
//    [fetchRequest setSortDescriptors:@[descriptor]];
    [fetchRequest setRelationshipKeyPathsForPrefetching:@[@"followers"]];
    [fetchRequest setRelationshipKeyPathsForPrefetching:@[@"followed"]];
    _likeFetchedResultsController= [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:[NSManagedObjectContext MR_defaultContext]
                                     sectionNameKeyPath:nil
                                     cacheName:nil];
    
    
    _likeFetchedResultsController.delegate = self;
    
	NSError *error = nil;
	if (![_likeFetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    [_tableView reloadData];

    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *CellIdentifier = @"userCell";
    
    PSFoundUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    User *user= [_likeFetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    
    [cell configureCellWithFollower:user];
    
    
    return cell;
}
    
    
    




#pragma mark - NSFetchedResultsControllerDelegate



#pragma mark - UITableViewDelegate







@end
