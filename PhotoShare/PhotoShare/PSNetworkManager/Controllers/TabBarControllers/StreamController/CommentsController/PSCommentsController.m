//
//  PSCommentsController.m
//  PhotoShare
//
//  Created by Евгений on 09.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSCommentsController.h"
#import "Post.h"
#import "User.h"
#import "Comment.h"
#import "PSCommentsParser.h"
#import "PSCommentTableViewCell.h"

@interface PSCommentsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arrayOfComments;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@end

@implementation PSCommentsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrayOfComments=[[_postToComment.comments allObjects] mutableCopy];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"commentDate" ascending:YES];
    _arrayOfComments=[[_arrayOfComments sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] mutableCopy];
    
    _commentTableView.delegate=self;
    _commentTableView.dataSource=self;
    [_commentTableView reloadData];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_postToComment.comments count];
    //return ([_postToComment.comments count]) ? [_postToComment.comments count] : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *CellIdentifier = @"commentCell";
    
    PSCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    [cell configureCellWithComment:[_arrayOfComments objectAtIndex:indexPath.row]];
    
    
    return cell;
}

@end
