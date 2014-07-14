//
//  User+PSUpdatePosts.m
//  PhotoShare
//
//  Created by Евгений on 11.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "User+PSUpdatePosts.h"
#import "PSNetworkManager.h"
#import "PSPostsParser.h"
#import "PSPostModel.h"
#import "PSCommentsParser.h"
#import "PScommentModel.h"
#import "Post.h"
#import "PSLikesParser.h"
#import "Like.h"
#import "Like+mapWithEmail.h"
#import "Post+PSMapWithModel.h"

@implementation User (PSUpdatePosts)

- (void)updatePostsForUserID:(int)userID {
     __weak typeof(self) weakSelf = self;
    [[PSNetworkManager sharedManager] getAllUserPostsWithUserID:[self.user_id intValue] success:^(id responseObject) {
        
        
        PSPostsParser *postParser = [[PSPostsParser alloc]initWithId:responseObject];
        PSPostModel *model = [PSPostModel new];
        NSLog(@"%@",postParser.arrayOfPosts);
        
        if (postParser.arrayOfPosts)
        {
            for (NSDictionary* dictionary in postParser.arrayOfPosts)
            {
                NSNumber *postIDToCheck = [NSNumber numberWithInt:model.postID=[postParser getPostID:dictionary]];
                
                Post *post=nil;
                if ([[Post  MR_findByAttribute:@"postID" withValue:postIDToCheck ]firstObject])
                {
                    post=[[Post  MR_findByAttribute:@"postID" withValue:postIDToCheck]firstObject];
                }
                else
                {
                    model.postTime = [postParser getPostTime:dictionary];
                    model.postID = [postParser getPostID:dictionary];
                    model.postImageURL = [postParser getPostImageURL:dictionary];
                    model.postImageLat = [postParser getPostImageLat:dictionary];
                    model.postImageLng = [postParser getPostImageLng:dictionary];
                    model.postImageName = [postParser getPostImageName:dictionary];
                    model.postArrayOfComments = [postParser getPostArrayOfComments:dictionary];
                    
                    Post *post=[Post MR_createEntity];
                    if ([postParser getPostLikesArray:dictionary]!=nil)
                    {
                        model.postLikesCount = [[postParser getPostLikesArray:dictionary] count];
                        NSLog(@"%@",dictionary);
                        PSLikesParser *likeParser = [PSLikesParser new];
                        likeParser.arrayOfLikes = [postParser getPostLikesArray:dictionary];
                        
                        if ([likeParser.arrayOfLikes count])
                        {
                            
                            
                            for (NSDictionary *dictionary in likeParser.arrayOfLikes)
                            {
                                Like *like = [Like MR_createEntity];
                                [like mapWithEmail:[likeParser getAuthorEmail:dictionary]];
                                [post addLikesObject:like];
                            }
                            
                        }
                    }
                    else
                    {
                        model.postLikesCount = 0;
                    }
                    
                    
                    post = [post mapWithModel:model];
                    NSLog(@"Post added%@]n",post);
                    [weakSelf addPostsObject:post];
                    
                }
                
                [weakSelf.managedObjectContext MR_saveToPersistentStoreAndWait];
                
            }
        }
        } error:^(NSError *error)
        {
            NSLog(@"error");
        }];
    }
     

@end
