//
//  Comment+mapWthModel.m
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Comment+mapWthModel.h"
#import "PScommentModel.h"

@implementation Comment (mapWthModel)


- (Comment *)commentWithMapModel:(PSCommentModel *)commentModel
{
    self.commentID=[NSNumber numberWithInt:commentModel.commentID];
    self.commentatorName=commentModel.commentatorName;
    self.commentText=commentModel.commentText;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss.SSSSSS'+'00:00"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *date = [dateFormat dateFromString:commentModel.commentDateString];
    NSLog(@"%@",date);
    self.commentatorAvaURL=commentModel.commentatorAvaURL;
    self.commentDate=date;

    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
    return self;
    
    
}

@end
