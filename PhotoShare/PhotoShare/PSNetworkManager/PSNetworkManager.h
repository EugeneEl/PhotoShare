//
//  PSNetworkManager.h
//  PhotoShare
//
//  Created by Евгений on 10.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;
@class PSUserModel;

typedef void (^successBlockWithId)(id);

typedef void (^successBlock)(void);
typedef void (^errorBlock)(NSError* error);

@interface PSNetworkManager : NSObject

+ (PSNetworkManager *) sharedManager;

- (AFHTTPRequestOperation *)signUpModel:(PSUserModel *)model
                            success:(successBlock)success
                            error:(errorBlock)error;

- (void)someMethodThatTakesABlock:(void (^)(NSError*))blockName;


- (AFHTTPRequestOperation *) loginWithModel:(PSUserModel*)model
                                    success:(successBlockWithId)success
                                      error:(errorBlock) error;


- (AFHTTPRequestOperation *) fetchUserStream:(PSUserModel*)model
                                     success:(successBlock)success
                                       error:(errorBlock)error;

- (AFHTTPRequestOperation *) getPostsPage:(NSInteger)page
                                 pageSize:(NSInteger)pageSize
                                  success:(successBlockWithId)success
                                    error:(errorBlock)error
                                   userID:(NSInteger)userID;
- (AFHTTPRequestOperation *)getAllUserPostsWithUserID:(NSInteger)userID
                                              success:(successBlockWithId)success
                                                error:(errorBlock)error;

- (AFHTTPRequestOperation *) sendImage:(UIImage *)image withLatitude:(double)lat andLongtitude:(double)lng withText:(NSString *)text  fromUserID:(NSInteger)userID
                               success:(successBlockWithId)successWithId
                                 error:(errorBlock)errorWithCode;

- (AFHTTPRequestOperation *)likePostWithID:(int)PostID byUser:(int)userID
                                   success:(successBlockWithId)success
                                     error:(errorBlock)error;


- (AFHTTPRequestOperation *)unlikePostWithID:(int)PostID byUser:(int)userID
                                     success:(successBlockWithId)success
                                       error:(errorBlock)error;

- (AFHTTPRequestOperation *) updateUserInforWithuserAva:(UIImage *)image newPassword:(NSString *)password newUserName:(NSString *)name  fromUserID:(NSInteger)userID
                             success:(successBlockWithId)successWithId
                               error:(errorBlock)errorWithCode;


- (AFHTTPRequestOperation *)commentPostID:(int)PostID fronUserID:(int)userID withText:(NSString *)text
                                  success:(successBlockWithId)successWithId
                                    error:(errorBlock)errorWithCode;

- (AFHTTPRequestOperation *)findFriendsByName:(NSString *)  nameForSearch
                                      success:(successBlockWithId)success
                                        error:(errorBlock)errorBlock;


- (AFHTTPRequestOperation *)PSFollowToUserWithID:(int)followerID fromUserWithID:(int)userID
                                       success:(successBlockWithId)success
                                         error:(errorBlock)errorBlock;

- (AFHTTPRequestOperation *)PSUnfollowUserWithID:(int)followerID fromUserWithID:(int)userID
                                       success:(successBlockWithId)success
                                         error:(errorBlock)errorBlock;
- (AFHTTPRequestOperation *)getInfoFromUser:(int)userID
                                      success:(successBlockWithId)success
                                        error:(errorBlock)errorBlock;

@end
