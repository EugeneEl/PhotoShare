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
//@property (nonatomic, strong) NSFetchedResultsController *likeFetchedResultsController;

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

    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayOfUsersToDisplay count];
    }






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"userCell";
    PSFoundUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    User *user = [_arrayOfUsersToDisplay objectAtIndex:indexPath.row];
    [cell configureCellWithFollower:user];
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate



#pragma mark - UITableViewDelegate







@end
