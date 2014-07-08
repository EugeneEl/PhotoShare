//
//  PSStreamViewController.m
//  PhotoShare
//
//  Created by Евгений on 12.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSStreamViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Post.h"
#import "Comment.h"
#import "PSPhotoFromStreamTableViewCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIViewController+UIViewController_PSSharingDataComposer.h"
#import "PSNetworkManager.h"
#import "PSUserStore.h"
#import "User.h"
#import "Post+mapWithModel.h"
#import "Parser.h"
#import "PSPostModel.h"
#import "PSPostsParser.h"
#import "Like.h"
#import "Like+mapWithEmail.h"
#import "PSLikesParser.h"

typedef enum {
    kNew,
    kFavourite
} sortPostsByKey;

static NSString *keyForSortSettings=@"sortKey";

@interface PSStreamViewController() <UITableViewDelegate ,UITableViewDataSource, NSFetchedResultsControllerDelegate, PhotoFromStreamTableViewCell,UIActionSheetDelegate>

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSNumber * post_idParsed;
@property (nonatomic, strong) NSNumber * likesParsed;
@property (nonatomic, copy) NSString * authorMailParsed;
@property (nonatomic, copy) NSString * photoNameParsed;
@property (nonatomic, copy) NSString * photoURLParsed;
@property (nonatomic, copy) NSDate * photo_dateParsed;
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic,strong) NSNumber * commentIDParsed;
@property (nonatomic,copy) NSString * commentatorNameParsed;
@property (nonatomic,copy) NSString * commentTextParsed;
@property (nonatomic,copy) NSDate * commentDateParsed;
@property (nonatomic,assign) NSUInteger offset;
@property (nonatomic, strong) NSData *imageDataToShare;
@property (nonatomic, copy)  NSString *photoName;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,assign) double photoLatitudeParsed;
@property (nonatomic,assign) double photoLongtitudeParsed;
@property (nonatomic,assign) sortPostsByKey sortKey;


- (IBAction)switchSortKey:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *changeSortKeySegmentController;
@property (weak, nonatomic) IBOutlet UITableView *streamTableView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic,strong) NSFetchedResultsController
    *likeFetchedResultsController;
@property (nonatomic,strong) NSFetchedResultsController
    *dateFetchedResultsController;

@end



@implementation PSStreamViewController

#pragma mark - ViewDidLoad
-(void)viewDidLoad
{
   [super viewDidLoad];
    self.streamTableView.dataSource=self;
    self.streamTableView.delegate=self;
    [self loadSettins];
    self.offset=5;
    _cellCount=0;
    self.streamTableView.contentSize=CGSizeMake(self.streamTableView.bounds.size.width,330.0f);
    self.streamTableView.clipsToBounds=NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    PSUserStore *userStore= [PSUserStore userStoreManager];
    User *currentUser=userStore.activeUser;
    _userID=[currentUser.user_id integerValue];
    _authorMailParsed=currentUser.email;
    NSLog(@"user_id:%d",_userID);
    
    
    __weak typeof(self) weakSelf = self;
    [[PSNetworkManager sharedManager] getAllUserPostsWithUserID:_userID
                                                        success:^(id responseObject)
     {
         NSLog(@"%@",responseObject);
         
         PSPostsParser *postParser=[[PSPostsParser alloc]initWithId:responseObject];
         PSPostModel *model=[PSPostModel new];
         NSLog(@"%@",postParser.arrayOfPosts);
         if (postParser.arrayOfPosts)
         {
             for (NSDictionary* dictionary in postParser.arrayOfPosts)
             {
                 model.postTime=[postParser getPostTime:dictionary];
                 model.postID=[postParser getPostID:dictionary];
                 model.postImageURL=[postParser getPostImageURL:dictionary];
                 model.postImageLat=[postParser getPostImageLat:dictionary];
                 model.postImageLng=[postParser getPostImageLng:dictionary];
                 model.postImageName=[postParser getPostImageName:dictionary];
                 model.postArrayOfComments=[postParser getPostArrayOfComments:dictionary];
                 
                 
                 Post *post=[Post MR_createEntity];
                 if ([postParser getPostLikesArray:dictionary]!=nil)
                 {
                     model.postLikesCount=[[postParser getPostLikesArray:dictionary] count];
                     NSLog(@"%@",dictionary);
                     PSLikesParser *likeParser=[PSLikesParser new];
                     likeParser.arrayOfLikes=[postParser getPostLikesArray:dictionary];
                     
                     if ([likeParser.arrayOfLikes count])
                     {
                         
                         
                         for (NSDictionary *dictionary in likeParser.arrayOfLikes)
                         {
                             Like *like=[Like MR_createEntity];
                             [like mapWithEmail:[likeParser getAuthorEmail:dictionary]];
                             [post addLikesObject:like];
                         }
                         
                     }
                 }
                 else
                 {
                     model.postLikesCount=0;
                 }
                 
                 
                 post=[post mapWithModel:model];
                 NSLog(@"Post added%@]n",post);
                 [currentUser addPostsObject:post];
                 
             }
             
             [currentUser.managedObjectContext save:nil];
             [weakSelf.streamTableView reloadData];
         }
         
         
     }
                                                          error:^(NSError *error)
     {
         NSLog(@"error");
     }];

  
 
//    [self.streamTableView reloadData];
}


//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    }


#pragma mark UITableViewDataSource

     
     
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [Post MR_countOfEntities];
 //менять в
   
    return count;
}


//PhotoShare[5505:60b] *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Invalid update: invalid number of rows in section 0.  The number of rows contained in an existing section after the update (10) must be equal to the number of rows contained in that section before the update (5), plus or minus the number of rows inserted or deleted from that section (1 inserted, 0 deleted) and plus or minus the number of rows moved into or out of that section (0 moved in, 0 moved out).'



//- (void)insertRowAtBottom {
//   __weak typeof(self) weakSelf = self;
//
//    int64_t delayInSeconds = 2.0;
//   dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//       [weakSelf.streamTableView beginUpdates];
//        _offset+=5;
//        
//              
//    [weakSelf.streamTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
//        
//        [weakSelf.streamTableView endUpdates];
//        
//        [weakSelf.streamTableView.infiniteScrollingView stopAnimating];
//    });
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   PSPhotoFromStreamTableViewCell *cell=[self.streamTableView dequeueReusableCellWithIdentifier:@"photoCell"];
    [self configureCell:cell atIndexPath:indexPath];

    cell.selected=NO;
    return cell;
}



//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    //rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 1.0, 1.0, 0.0);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    //[UIView setAnimationDuration:5.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}


- (NSFetchedResultsController *)likeFetchedResultsController {
    if (_likeFetchedResultsController!=nil) {
        return _likeFetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Post"];
    NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"likesCount" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[descriptor]];
     

    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
  _likeFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:[NSManagedObjectContext MR_defaultContext]
                                                             sectionNameKeyPath:nil
                                                             cacheName:nil];
    
    
    _likeFetchedResultsController.delegate = self;

    
	NSError *error = nil;
	if (![self.likeFetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _likeFetchedResultsController;

}

- (NSFetchedResultsController *)dateFetchedResultsController {
    
    if (_dateFetchedResultsController!=nil) {
        return _dateFetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest=[[NSFetchRequest alloc]initWithEntityName:@"Post"];
    NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"photoDate" ascending:NO];
    [fetchRequest setSortDescriptors:@[descriptor]];
   // fetchRequest.fetchOffset=_offset;
    _dateFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:fetchRequest
                                                             managedObjectContext:[NSManagedObjectContext MR_defaultContext]
                                                             sectionNameKeyPath:nil
                                                             cacheName:nil];
    
    
    _dateFetchedResultsController.delegate = self;
    
	NSError *error = nil;
	if (![self.dateFetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _dateFetchedResultsController;

}

- (void)photoStreamCellLikeButtonPressed:(PSPhotoFromStreamTableViewCell  *)tableCell
{
    if (!tableCell.likesStatus)
    {
        [[PSNetworkManager sharedManager]
         likePostWithID:[tableCell.postForCell.postID intValue]
         byUser:_userID
         success:^(id responseObject)
         {
             NSLog(@"liked successfully");
             Like *likeToAdd=[Like MR_createEntity];
             [likeToAdd mapWithEmail:_authorMailParsed];
             [tableCell.postForCell addLikesObject:likeToAdd];
             tableCell.likesStatus=YES;
             [tableCell.likeButton setImage:[UIImage imageNamed:@"heart-icon.png"] forState:UIControlStateNormal];
             [tableCell.postForCell.managedObjectContext save:nil];
             
         }
         error:^(NSError *error)
         {
             NSLog(@"error");
         }];
//        [self.streamTableView reloadData];
    }
    if (tableCell.likesStatus)
    {
        [[PSNetworkManager sharedManager] unlikePostWithID:[tableCell.postForCell.postID intValue]
            byUser:_userID
            success:^(id responseObject)
            {
                
                NSLog(@"unlikes success ");
                tableCell.likesStatus=NO;
                [tableCell.likeButton setImage:[UIImage imageNamed:@"grey_heart.png"] forState:UIControlStateNormal];
                for (Like *like in tableCell.postForCell.likes)
                {
                    if ([like.email isEqualToString:_authorMailParsed])
                    {
                        [tableCell.postForCell removeLikesObject:like];
                        break;
                    }
                }
                [tableCell.postForCell.managedObjectContext save:nil];
            }
            error:^(NSError *error)
            {
                NSLog(@"error");
            }];
//        [self.streamTableView reloadData];
    }
     [self.streamTableView reloadData];
}

- (void)photoStreamCellCommentButtonPressed:(PSPhotoFromStreamTableViewCell *)
tableCell {
    NSLog(@"button comment pressed");
}




- (NSFetchedResultsController *)fetchedResultsController
{
    if (self.sortKey==kNew) {
        _fetchedResultsController=self.dateFetchedResultsController;
       // _offset=5;
    }
   
    else if (self.sortKey==kFavourite) {
        _fetchedResultsController=self.likeFetchedResultsController;
      //  _offset=5;
    }
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.streamTableView beginUpdates];
}




- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.streamTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.streamTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.streamTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - UITableViewDelegate

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PSPhotoFromStreamTableViewCell *aCell = (id)cell;
    
    NSLog(@"%@",indexPath);
    Post  *postTest=[self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell=(PSPhotoFromStreamTableViewCell*)cell;
    
    aCell.postForCell=postTest;
    aCell.photoNameLabel.text=postTest.photoName;
    aCell.timeintervalLabel.text=[self timeIntervalFromPhoto:postTest.photoDate];
    NSString *commentsNumberString =[NSString stringWithFormat:@"%lu", (unsigned long)[postTest.comments count]];
    aCell.commentsNumberLabel.text=commentsNumberString;
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void)
    {
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:postTest.photoURL]];
        
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [aCell.imageForPost setImage:image];
            [aCell setNeedsLayout]; //test here
        });
    });
    
    aCell.likesStatus=NO;
    if (![postTest.likesCount intValue])
    {
     //  aCell.likeButton.imageView.image=[UIImage imageNamed:@"heart-icon.png"];
        [aCell.likeButton setImage:[UIImage imageNamed:@"grey_heart.png"] forState:UIControlStateNormal];
        NSLog(@"no likes");
    }
    else
    {
        for (Like *like in postTest.likes)
        {
            if ([like.email isEqualToString:_authorMailParsed])
            {
                [aCell.likeButton setImage:[UIImage imageNamed:@"heart-icon.png"] forState:UIControlStateNormal];
                aCell.likesStatus=YES;
                break;
            }
            else
            {
                [aCell.likeButton setImage:[UIImage imageNamed:@"grey_heart.png"] forState:UIControlStateNormal];
            }
        }

    }
    
    
//[aCell.imageForPost setImageWithURL: [NSURL URLWithString:postTest.photoURL]];
   // aCell.likesNumberLabel.text=[NSString stringWithFormat:@"%@",postTest.likes];
    aCell.delegate=self;
    
    
}

- (NSString *)timeIntervalFromPhoto:(NSDate *) date
{
    NSTimeInterval timeIntervalBetweenPhotos=[date timeIntervalSinceNow];
    
    if ((timeIntervalBetweenPhotos/-86400>1))
    
    {
        return [NSString stringWithFormat:@"%i days ago",abs(timeIntervalBetweenPhotos/(60*60*24))];
    }
    
    else if ((timeIntervalBetweenPhotos/-3600)>1)
    {
        return [NSString stringWithFormat:@"%i hours ago",abs(timeIntervalBetweenPhotos/3600)];
    }
    
    else if ((timeIntervalBetweenPhotos/-60)>1)
    {
        return [NSString stringWithFormat:@"%i minutes ago",abs(timeIntervalBetweenPhotos/60)];
    }
    
    else
        return [NSString stringWithFormat:@"%i seconds ago",abs(timeIntervalBetweenPhotos)];
}


- (IBAction)switchSortKey:(id)sender
{
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        self.sortKey=kNew;
        [self saveSettings];
        [self.streamTableView setContentOffset:CGPointMake(0, 0)];
        [self.streamTableView reloadData];
        
    }
    else if (selectedSegment == 1)
    {
        self.sortKey=kFavourite;
        [self.streamTableView reloadData];
        [self.streamTableView setContentOffset:CGPointMake(0, 0)];
        [self saveSettings];
    }
    
}

#pragma mark - Save and Load

- (void)saveSettings {
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    if (self.sortKey==kNew) {
       [userDefaults setInteger:0 forKey:keyForSortSettings];
    }
    else if (self.sortKey==kFavourite) {
       [userDefaults setInteger:1 forKey:keyForSortSettings];
    }
    [userDefaults synchronize];
}

- (void)loadSettins {
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    int KeyFromDefaults;
    
    KeyFromDefaults=[userDefaults integerForKey:keyForSortSettings];
    
    if (KeyFromDefaults==0)
    {
        self.sortKey=kNew;
        self.changeSortKeySegmentController.selectedSegmentIndex=0;
    }
    
    else if (KeyFromDefaults==1)
    {
        self.sortKey=kFavourite;
        self.changeSortKeySegmentController.selectedSegmentIndex=1;
    }
    else
    {
        self.sortKey=kNew;
        self.changeSortKeySegmentController.selectedSegmentIndex=0;
    }
    
}

#pragma mark - PhotoFromStreamTableViewCell
- (void)photoStreamCellShareButtonPressed:(PSPhotoFromStreamTableViewCell  *)
tableCell
{
 
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:tableCell.postForCell.photoURL]];
    UIImage* image=[UIImage imageWithData:data];
    self.imageDataToShare=UIImageJPEGRepresentation(image, 1.0);
    self.photoName=tableCell.postForCell.photoName;
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Share"
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString
                                  (@"actionSheetButtonCancelNameKey", "")
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil, nil];
    
    
    [actionSheet setTitle:NSLocalizedString(@"actionSheetTitleNameKey", "")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"actionSheetButtonEmailNameKey", "")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"actionSheetButtonTwitterNameKey", "")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"actionSheetButtonFacebookNameKey", "")];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"actionSheetButtonSaveNameKey", "")];
    
    //without next line action sheet does not appear on iphone 3.5 inch
    [actionSheet showFromTabBar:(UIView*)self.view];



}



#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // NSLog(@"Была нажата кнопка с номером - %d",buttonIndex);
    //Cancel   0
    //Email    1
    //Twitter  2
    //FaceBook 3
    //Save     4
    
    
    switch (buttonIndex) {
        {case 1: //Email photo
            
            [self shareByEmail:_imageDataToShare photoName:_photoName
                       success:^
             {
                 
                 //NSLog(@"Photo was posted to facebook successfully");
                 UIAlertView *alert=[[UIAlertView alloc]
                                     initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                                     message:NSLocalizedString(@"alertViewOnMailSuccesstKey","")
                                     delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
             
             
                       failure:^(NSError *error)
             {
                 if (error.code==100)
                 {
                     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"alertViewOnTwitterErrorNoPhotoKey", "") delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")  otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }
                 
                 else if (error.code==103)
                 {
                     UIAlertView *alert=[[UIAlertView alloc]
                                         initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                         message:NSLocalizedString(@"alertViewOnMailConfigerAccountKey","")
                                         delegate:nil
                                         cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
                                         otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 
             }];
            
            // [self shareByEmail:self.imageDataToShare];
            break;}
            
        {
        case 2:
            [self shareToTwitterWithData:_imageDataToShare
                               photoName:_photoName
                                 success:^
             {
                 NSLog(@"Photo was tweeted successfully");
                 UIAlertView *alert=[[UIAlertView alloc]
                                     initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                                     message:NSLocalizedString(@   "alertViewOnTwitterSuccesstKey","")
                                     delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                     otherButtonTitles:nil, nil];
                 [alert show];
                 
             }
             
                                 failure:^(NSError *error)
             {
                 
                 if (error.code==100)
                 {
                     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"alertViewOnTwitterErrorNoPhotoKey", "") delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")  otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }
                 
                 else if (error.code==101)
                 {
                     UIAlertView *alert=[[UIAlertView alloc]
                                         initWithTitle:NSLocalizedString(@"alertViewOnTwitterConfigerAccountKey", "")
                                         message:NSLocalizedString(@"alertViewOnMailConfigerAccountKey","")
                                         delegate:nil
                                         cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")
                                         otherButtonTitles:nil, nil];
                     [alert show];
                 }
             }
             ];
            
            
            break;}
            
        {case 3:
            
            [self shareToFacebookWithData:_imageDataToShare photoName:_photoName
                                  success:^
             {
                 NSLog(@"Photo was successfully posted to facebook");
                 UIAlertView *alert=[[UIAlertView alloc]
                                     initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                                     message:NSLocalizedString(@ "alertViewOnFacebookSuccesstKey","")
                                     delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
                                  failure:^(NSError *error) {
                                      
                                      if (error.code==100)
                                      {
                                          UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:NSLocalizedString(@"alertViewOnTwitterErrorNoPhotoKey", "") delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "")  otherButtonTitles:nil, nil];
                                          [alert show];
                                          
                                      }
                                      
                                      else if (error.code==102)
                                      {
                                          UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@ "ErrorStringKey", "")
                                                                                        message:NSLocalizedString(@"alertViewOnFacebookConfigerAccountKey", "")
                                                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"actionSheetButtonCancelNameKey", "") otherButtonTitles:nil, nil];
                                          [alert show];
                                          
                                      }
                                      
                                  }];
            
            
            
            break;
        }
            
        {case 4:
            [self SaveToAlbumWithData:_imageDataToShare
                              success:^{
                                  UIAlertView *alert=[[UIAlertView alloc]
                                                      initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                                                      message:NSLocalizedString(@ "alertViewOnSaveSuccessKey", "")
                                                      delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                                      otherButtonTitles:nil, nil];
                                  [alert show];
                              }
                              failure:^(NSError *error) {
                                  
                                  UIAlertView *alert=[[UIAlertView alloc]
                                                      initWithTitle:NSLocalizedString(@"alertViewSuccessKey", "")
                                                      message:NSLocalizedString(@ "alertViewOnSaveSuccessKey", "")
                                                      delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"alertViewOkKey", "")
                                                      otherButtonTitles:nil, nil];
                                  [alert show];
                                  
                              }];
            
            break;
        }
        default:
            break;
    }
}




@end
