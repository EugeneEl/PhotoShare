//
//  Post+mapWithModel.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Post+mapWithModel.h"
#import "PSPostModel.h"
#import "PSCommentsParser.h"
#import "PScommentModel.h"
#import "Comment+mapWthModel.h"
#import "Comment.h"

@implementation Post (mapWithModel)

- (Post *)mapWithModel:(PSPostModel*) postModel
{

    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss.SSSSSS'+'00:00"];
    //[dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *date = [dateFormat dateFromString:postModel.postTime];
    NSLog(@"%@",date);
    
    self.photoDate=date;
    self.likesCount=[NSNumber numberWithInt:postModel.postLikesCount];
    self.postID=[NSNumber numberWithInt:postModel.postID];
    self.photoName=postModel.postImageName;
    self.photoLocationLatitude=[NSNumber numberWithDouble:postModel.postImageLat];
    self.photoLocationLongtitude=[NSNumber numberWithDouble:postModel.postImageLng];
    self.photoURL=postModel.postImageURL;
    self.likesCount=[NSNumber numberWithInt:postModel.postLikesCount];
    
    PSCommentModel *commentModel=[[PSCommentModel alloc]init];
//    PSCommentsParser *commmentParser=[[PSCommentsParser alloc]initWithId:postModel.postArrayOfComments];
    
    PSCommentsParser *commentParser=[PSCommentsParser new];
    commentParser.arrayOfComments=postModel.postArrayOfComments;
    
    NSLog(@"postModel:%@\n",postModel.postArrayOfComments);
    
    if (commentParser.arrayOfComments)
    {
        for (NSDictionary *dictionary in commentParser.arrayOfComments)
        {
            commentModel.commentText=[commentParser getCommentText:dictionary];
            commentModel.commentatorName=[commentParser getAuthorName:dictionary];
            commentModel.commentID=[commentParser getCommentID:dictionary];
            commentModel.commentDateString=[commentParser getCommentTime:dictionary];
            
            Comment *commentToAdd=[Comment MR_createEntity];
            commentToAdd=[commentToAdd commentWithMapModel:commentModel];
            [self addCommentsObject:commentToAdd];
            
        }
    }
    
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
    return self;
}
@end
