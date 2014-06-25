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

static NSString *keyForPostID                                 =@"post_id";
static NSString *keyForPhotoDate                              =@"photo_date";
static NSString *keyForLikes                                  =@"likes";
static NSString *keyForAuthorMail                             =@"authoremail";
static NSString *keyForPhotoName                              =@"photoName";
static NSString *keyForPhotoURL                               =@"photoURL";
static NSString *keyForLocationDictionary                     =@"location";
static NSString *keyPathForLatitude                           =@"location.latitude";
static NSString *keyPathForLongtitude                         =@"location.longtitude";
static NSString *keyForCommentsArray                          =@"comments";
static NSString *keyForCommentIDInComments                    =@"comment_id";
static NSString *keyForCommentatorNameInComments              =@"commentatorName";
static NSString *keyForCommentTextInComments                  =@"text";
static NSString *keyForCommentDateInComments                  =@"comment_date";


@interface PSStreamViewController() <UITableViewDelegate ,UITableViewDataSource, NSFetchedResultsControllerDelegate>
//@property (weak, nonatomic) IBOutlet UIImageView *imageFromPost;

@property (nonatomic, strong) NSNumber * post_idParsed;
@property (nonatomic, strong) NSNumber * likesParsed;
@property (nonatomic, strong) NSString * authorMailParsed;
@property (nonatomic, strong) NSString * photoNameParsed;
@property (nonatomic, strong) NSString * photoURLParsed;
@property (nonatomic, strong) NSDate * photo_dateParsed;

@property (nonatomic,strong) NSNumber * commentIDParsed;
@property (nonatomic,strong) NSString * commentatorNameParsed;
@property (nonatomic,strong) NSString * commentTextParsed;
@property (nonatomic,strong) NSDate * commentDateParsed;

@property (nonatomic,assign) double photoLatitudeParsed;
@property (nonatomic,assign) double photoLongtitudeParsed;


@property (weak, nonatomic) IBOutlet UITableView *streamTableView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

/*
 
 [
 {
 "post_id"    :1,
 "likes"      : 0,
 
 "authoremail": "trymail22@yandex.ua",
 
 "comments"   : [
 {"commentatorName":"Erick", "text":"red..","comment_date":"2015-01-01 17:35:40 GMT","comment_id":1},
 {"commentatorName":"Jammie", "text":"tasty","comment_date":"2015-01-01 07:35:40 GMT","comment_id":2}
 ],
 
 "photoURL":"http://www.herbalextractsplus.com/images/herbs/tomato-isp.jpg",
 
 "photoName":"tomato",
 
 "location": {"latitude":51.586723,"longitude":-0.34976},
 "photo_date":"2015-01-01 06:35:40 GMT"
 
 },
 
 {
 "post_id"    :2,
 
 "likes"      : 3,
 
 "authoremail": "kartman@yandex.ua",
 
 "comments"   : [
 {"commentatorName":"Ronald", "text":"what a mess!!!","comment_date":"2013-03-27 17:35:40 GMT","comment_id":3},
 {"commentatorName":"Jammie", "text":"o my god..","comment_date":"2013-04-27 07:25:40 GMT","comment_id":4},
 {"commentatorName":"Tirion", "text":"Hope you'll take this mask to school","comment_date":"2013-04-27 09:25:40 GMT","comment_id":5}
 ],
 
 "photoURL":"http://cs532300v4.vk.me/u1722475/video/l_c5183fae.jpg",
 
 "photoName":"kartmanFace",
 
 "location": {"latitude":51.486723,"longitude":-0.354976},
 "photo_date":"2013-02-27 06:35:40 GMT"
 },
 
 {
 "post_id"    :3,
 "likes"      : 0,
 
 "authoremail": "tirion@lannister.uk",
 
 "comments"   : [],
 
 "photoURL":"http://th06.deviantart.net/fs71/PRE/f/2012/234/b/5/tyrion_lannister_by_rickardha-d5c1j75.jpg",
 "photoName":"myPledge",
 
 "location": {"latitude":51.496723,"longitude":-0.65976},
 "photo_date":"2013-03-29 06:35:40 GMT"
 },
 
 {
 "post_id"    : 4,
 "likes"      : 2,
 
 "authoremail": "jamie@lannister.uk",
 
 "comments"   : [{"commentatorName":"Ronald","text":"hope,you'll come back soon","comment_date":"2014-06-11 09:25:40 GMT","comment_id":6},
 {"commentatorName":"Erick","text":"not a good day for Lannisters","comment_date":"2014-08-11 09:25:40 GMT","comment_id":7}],
 
 "photoURL":"http://oinkandjibber.com/wp-content/uploads/2013/04/Jaime-Lannister-Number-One-OJ-620x413.jpg",
 "photoName":"solitaryConfinement",
 
 "location": {"latitude":52.186723,"longitude":-0.3976},
 "photo_date":"2014-06-11 06:35:40 GMT"
 }
 ]
*/

@end



@implementation PSStreamViewController

@synthesize fetchedResultsController = _fetchedResultsController;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSData *dataFromJSON=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"response1" ofType:@"json" inDirectory:nil]];
    NSLog(@"file context:%@",dataFromJSON);
    
    
    
    NSMutableArray *parsedData= [[NSJSONSerialization JSONObjectWithData:dataFromJSON
                                                         options:0 error:nil] mutableCopy];
    NSLog(@"parsedArray:%@",parsedData);

    NSDictionary* searchedPost=[NSDictionary new];
    
    
    //sort array by date
    [parsedData sortUsingComparator:
     ^NSComparisonResult(NSDictionary *a, NSDictionary *b)
     {
         return [a[keyForPhotoDate] compare:b[keyForPhotoDate]];
     }];
    
    
    //"2015-01-01 06:35:40:622 GMT"
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    //writing posts to CoreData
    for (NSDictionary *dict in parsedData)
    {
        
        //Reading data from JSON
        self.post_idParsed=[dict objectForKey:keyForPostID];
        NSLog(@"post_id:%@",self.post_idParsed);
        self.likesParsed=[dict objectForKey:keyForLikes];
        NSLog(@"likes:%@",self.likesParsed);
        self.authorMailParsed=[dict objectForKey:keyForAuthorMail];
        NSLog(@"authorMail:%@",self.authorMailParsed);
        self.photoNameParsed=[dict objectForKey:keyForPhotoName];
        NSLog(@"photoName:%@",self.photoNameParsed);
        self.photoURLParsed=[dict objectForKey:keyForPhotoURL];
        NSLog(@"photoURL:%@",self.photoURLParsed);
        
        
        //coordinates in degrees @"key1.@specialKey.
        self.photoLatitudeParsed=[[dict valueForKeyPath:keyPathForLatitude]doubleValue ];
        self.photoLongtitudeParsed=[[dict valueForKeyPath:keyPathForLongtitude] doubleValue];
        
        NSLog(@"latitudeParsed:%f",self.photoLatitudeParsed);
        NSLog(@"longtitudeParsed:%f",self.photoLongtitudeParsed);
        
        
        
        NSMutableArray *commentsArray=[dict objectForKey:keyForCommentsArray];
        NSLog(@"commentsArray:%@",commentsArray);


        NSLog(@"date:%@",[dict objectForKey:keyForPhotoDate]);
        
        self.photo_dateParsed=[dateFormatter dateFromString:[dict objectForKey:keyForPhotoDate]];
        
        NSLog(@"photo_date:%@",self.photo_dateParsed);
        

        
        //check if the parsed post exists in CoreData
        Post *existingPost=[[Post MR_findByAttribute:@"postID" withValue:self.post_idParsed]firstObject];
        
        if (!existingPost)
        {
            existingPost=[Post MR_createEntity];
            
            existingPost.postID=self.post_idParsed;
            existingPost.likes=self.likesParsed;
            existingPost.authorMail=self.authorMailParsed;
            existingPost.photoName=self.photoNameParsed;
            existingPost.photoURL=self.photoURLParsed;
            existingPost.photoDate=self.photo_dateParsed;
            existingPost.photoLocationLatitude=[NSNumber numberWithDouble:self.photoLatitudeParsed];
            existingPost.photoLocationLongtitude=[NSNumber numberWithDouble:self.photoLongtitudeParsed];
            

            
            //parse and check comments
            for (NSDictionary *dictOfComments in commentsArray)
            {
                
                self.commentIDParsed=[dictOfComments objectForKey:keyForCommentIDInComments];
                
                if ([[existingPost.comments filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"commentID == %@",self.commentIDParsed]] anyObject])
                {
                    NSLog(@"Post %@ has comment with id %@",existingPost.postID, self.commentIDParsed);
                    
                }
                
                else
                {
                    //parsed date,text,name of comment
                    self.commentatorNameParsed=[dictOfComments objectForKey:keyForCommentatorNameInComments];
                    self.commentTextParsed=[dictOfComments objectForKey:keyForCommentTextInComments];
                    self.commentDateParsed=[dateFormatter dateFromString:[dictOfComments objectForKey:keyForCommentDateInComments]];
                                            
                     NSLog(@"photo_date:%@",self.commentDateParsed);
                    
                    //creating an instance of Comment entity
                    
                    Comment *commentToAdd=[Comment MR_createEntity];
                    
                    commentToAdd.commentID=self.commentIDParsed;
                    commentToAdd.commentatorName=self.commentatorNameParsed;
                    commentToAdd.commentText=self.commentTextParsed;
                    commentToAdd.commentDate=self.commentDateParsed;
                    
                    [existingPost addCommentsObject:commentToAdd];
                }
                    
                
            }
            
            
            NSLog(@"added post with id:%@ to database", existingPost.postID);
            NSLog(@"Post coords:%@, %@",existingPost.photoLocationLatitude,existingPost.photoLocationLongtitude );
            [existingPost.managedObjectContext MR_saveToPersistentStoreAndWait];
            
        }
        
    
        else if (existingPost) {
            NSLog(@"Post with id:%@ already exists in database",existingPost.postID);
        }
    
        
    }
    
    //taking the last Post from sortded by date array
    searchedPost=[parsedData firstObject];
    
    
    NSLog(@"firstPost:%@",searchedPost);
    
    NSURL *urlForImage = [NSURL URLWithString:[searchedPost objectForKey:keyForPhotoURL]];
   
    
    //NSURLRequest *requestURLForImage=[NSURLRequest requestWithURL:urlForImage];
    
    //__weak PSStreamViewController *weakSelf=self;
    
    
    [self.image setImageWithURL:urlForImage];
    
   
    
    self.streamTableView.dataSource=self;
    self.streamTableView.delegate=self;
    //[self.streamTableView reloadData];
    self.fetchedResultsController.delegate=self;
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [Post MR_countOfEntities];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
   PSPhotoFromStreamTableViewCell *cell=[self.streamTableView dequeueReusableCellWithIdentifier:@"photoCell"];
    
    [self configureCell:cell atIndexPath:indexPath];

    
    return cell;
    
}


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
	if (![self.fetchedResultsController performFetch:&error])
    {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
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


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
 
    PSPhotoFromStreamTableViewCell *aCell = (id)cell;
    
    Post  *postTest=[self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell=(PSPhotoFromStreamTableViewCell*)cell;
    
    aCell.photoNameLabel.text=postTest.photoName;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSString *stringFromDate = [dateFormatter stringFromDate:postTest.photoDate];
    aCell.photoDateLabel.text=stringFromDate;
    
    NSString *commentsNumberString =[NSString stringWithFormat:@"%lu", [postTest.comments count]];
    
    NSLog(@"textFromData:%@",commentsNumberString);
    
    aCell.commentsNumberLabel.text=commentsNumberString;
    
    
    NSLog(@"textInLabel%@",aCell.commentsNumberLabel.text);
    
    [aCell.imageForPost setImageWithURL: [NSURL URLWithString:postTest.photoURL]];
    
    
    
    aCell.likesNumberLabel.text=[NSString stringWithFormat:@"%@",postTest.likes];

}


#pragma mark - UITableViewDelegate

@end
