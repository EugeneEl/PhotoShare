//
//  PSFoundUsers.m
//  PhotoShare
//
//  Created by Евгений on 10.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSFoundUsersViewController.h"
#import "PSFoundUserTableViewCell.h"

@interface PSFoundUsersViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    [_tableView reloadData];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayOfUsersToDisplay count];
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"userCell";
     PSFoundUserTableViewCell *  cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell configureCellWithFollower:[_arrayOfUsersToDisplay objectAtIndex:indexPath.row]];
    return cell;
}

@end
