//
//  PSNetworkManager.m
//  PhotoShare
//
//  Created by Евгений on 10.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//


#import "PSNetworkManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "PSUserModel.h"

static NSString *PSBaseURL=@"http://test.intern.yalantis.com/api/";
@interface PSNetworkManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@end

@implementation PSNetworkManager


-(id)init {
    
    if (self=[super init]) {
        
        NSURL *url=[NSURL URLWithString:PSBaseURL];
        _requestManager=[[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
        [_requestManager setRequestSerializer:[AFJSONRequestSerializer new]];
    }
    
    return self;
    
}

+ (PSNetworkManager *)sharedManager {
    
    static PSNetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}


- (AFHTTPRequestOperation *)signUpModel:(PSUserModel *)model
                                success:(successBlock)success
                                  error:(errorBlock)error {
    NSDictionary *dictionaryForRequest=@{ @"email":model.email,
                                          @"password":model.password,
                                          @"user_name":model.name
                                        };
    
    return [_requestManager POST:@"users/register"
     
        parameters:dictionaryForRequest
     
        success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"sign up success");
         success();
         
     }
    
     
        failure:^(AFHTTPRequestOperation *operation, NSError *e)
     {
         error(e);
         NSLog(@"sign up error:%@",[e localizedDescription]);
     }];
}






- (AFHTTPRequestOperation *)loginWithModel:(PSUserModel*)model
                             success:(successBlockWithId)success
                             error:(errorBlock) error {
    NSDictionary *dictionaryForRequest=@{ @"email":model.email,
                                          @"password":model.password};
    
    return [_requestManager POST:@"users/login"
            
                      parameters:dictionaryForRequest
            
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"login success");
                success(responseObject);
            }
            
            
            failure:^(AFHTTPRequestOperation *operation, NSError *e)
            {
                error(e);
                NSLog(@"login error:%@",[e localizedDescription]);
            }];

}


- (void)someMethodThatTakesABlock:(void (^)(NSError* error))blockName {
    NSLog(@"someMethodThatTakesABlock has been called");
    
    [_requestManager
    GET:(PSBaseURL)
    parameters:(nil)
     
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"GET request was successfull");
     }
     
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"GET request was failed");
         blockName(error);
         NSLog([error description]);
     }
     ];
    
}

- (AFHTTPRequestOperation *) fetchUserStream:(PSUserModel*)model
                                     success:(successBlock)success
                                       error:(errorBlock)error {
    
    
    NSDictionary *dictionaryForRequest=@{ @"email":model.email,
                                          @"password":model.password
                                          };
    
    return [_requestManager GET:@"users"
            
                     parameters:dictionaryForRequest
            
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"login success");
                success();
            }
            
            
            failure:^(AFHTTPRequestOperation *operation, NSError *e)
            {
                error(e);
                NSLog(@"login error:%@",[e localizedDescription]);
            }];
    
}


- (AFHTTPRequestOperation *) getPostsPage:(NSInteger)page
                             pageSize:(NSInteger)pageSize
                             success:(successBlockWithId)success
                             error:(errorBlock)error
                             userID:(NSInteger)userID {
    NSString *request=@"posts/";
    request=[request stringByAppendingString:[NSString stringWithFormat:@"%d?cnt=%d&page=%d",userID,pageSize,page]];
    
    
   
    return [_requestManager GET:request
            
                     parameters:nil
            
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"Posts was retrieved");
                success(responseObject);
                
            }
            
            
                        failure:^(AFHTTPRequestOperation *operation, NSError *e)
            {
                error(e);
                NSLog(@"error:%@",[e localizedDescription]);
            }];
    
}


- (AFHTTPRequestOperation *)getAllUserPostsWithUserID:(NSInteger)userID
                            success:(successBlockWithId)success
                                                error:(errorBlock)error {
    NSString *request=@"posts/";
    request=[request stringByAppendingString:[NSString stringWithFormat:@"%d",userID]];
    
    return [_requestManager GET:request
            
                     parameters:nil
            
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"Posts was retrieved");
                success(responseObject);
                
            }
            
            
                        failure:^(AFHTTPRequestOperation *operation, NSError *e)
            {
                error(e);
                NSLog(@"error:%@",[e localizedDescription]);
            }];

}



- (AFHTTPRequestOperation *) getUserPosts:(NSInteger)page
                             pageSize:(NSInteger)pageSize
                             success:(successBlockWithId)success
                             error:(errorBlock)error {
    
    
    NSDictionary *dictionaryForRequest=@{@"cnt" : @(pageSize),
                                         @"page" : @(page)
                                         };
    
    return [_requestManager GET:@"get_user_posts"
            
                     parameters:dictionaryForRequest
            
                        success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"Posts was retrieved");
                success(responseObject);
                
            }
            
            
                        failure:^(AFHTTPRequestOperation *operation, NSError *e)
            {
                error(e);
                NSLog(@"error:%@",[e localizedDescription]);
            }];
    
}

//http://nsscreencast.com/episodes/31-posting-multi-part-forms-with-afnetworking
- (AFHTTPRequestOperation *) sendImage:(UIImage *)image withLatitude:(double)lat andLongtitude:(double)lng withText:(NSString *)text  fromUserID:(NSInteger)userID
                               success:(successBlockWithId)successWithId
                                 error:(errorBlock)errorWithCode {
    
    
    NSDictionary *params = @{
                             @"lat":@(lat),
                             @"lng":@(lng),
                             @"text":text,
                             @"author_id":@(userID)
                             };
    
    return  [_requestManager POST:@"posts/" parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
        {
         if (image)
         {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0)
                                        name:@"pic"
                                    fileName:@"pic.jpg"
                                    mimeType:@"image/jpeg"
                 ];
         }
        }
        success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            successWithId(responseObject);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            errorWithCode(error);
        }];
}

- (AFHTTPRequestOperation *)likePostWithID:(int)PostID byUser:(int)userID
                                  success:(successBlockWithId)success
                                              error:(errorBlock)error {
    NSString *request=@"posts/";
    request=[request stringByAppendingString:[NSString stringWithFormat:@"%d/like/%d",userID,PostID]];
    NSLog(@"%@",request);
    return [_requestManager GET:request
            
            parameters:nil
            
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"Posts was liked");
                success(responseObject);
                
            }
            
            
            failure:^(AFHTTPRequestOperation *operation, NSError *e)
            {
                error(e);
                NSLog(@"error:%@",[e localizedDescription]);
            }];
}



- (AFHTTPRequestOperation *)unlikePostWithID:(int)PostID byUser:(int)userID
                                   success:(successBlockWithId)success
                                     error:(errorBlock)error {
    NSString *request=@"posts/";
    request=[request stringByAppendingString:[NSString stringWithFormat:@"%d/unlike/%d",userID,PostID]];
    return [_requestManager GET:request
            
                     parameters:nil
            
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"Posts was unliked");
                success(responseObject);
                
            }
            
            
                        failure:^(AFHTTPRequestOperation *operation, NSError *e)
            {
                error(e);
                NSLog(@"error:%@",[e localizedDescription]);
            }];
}

- (AFHTTPRequestOperation *) updateUserInforWithuserAva:(UIImage *)image newPassword:(NSString *)password newUserName:(NSString *)name  fromUserID:(int)userID
                             success:(successBlockWithId)successWithId
                               error:(errorBlock)errorWithCode {

   
    NSDictionary *params=[NSDictionary new];
    if ((![password isEqualToString:@""]) && (![name isEqualToString:@""])) {
        params = @{@"user_name":name,
                   @"password":password,
                   };
    }
    else if ( [name isEqualToString:@""] && (![password isEqualToString:@""])) {
        params = @{@"password":password};
    }
    else if ( (![name isEqualToString:@""] )&& ([password isEqualToString:@""]))
    {
        params = @{@"user_name":name};
    }
    else if (([password isEqualToString:@""]) && ([name isEqualToString:@""])){
        params=nil;
    }
    
    NSString *request=[NSString stringWithFormat:@"users/%d",userID];

    return  [_requestManager  POST:request parameters:params
     constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             if (image)
             {
                 [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0)
                                             name:@"pic"
                                         fileName:@"pic.jpg"
                                         mimeType:@"image/jpeg"
                  ];
             }
         }
         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             successWithId(responseObject);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             errorWithCode(error);
         }];
}



- (AFHTTPRequestOperation *)commentPostID:(int)PostID fronUserID:(int)userID withText:(NSString *)text
                            success:(successBlockWithId)successWithId
                                    error:(errorBlock)errorWithCode {
    
    NSString *request=@"comments/";
    
    
    
    NSDictionary *params = @{@"author_id":@(userID),
                             @"post_id":@(PostID),
                             @"text":text};
    
    
    
    return  [_requestManager POST:request
            parameters:params
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                successWithId(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                errorWithCode(error);
            }];
    
}

- (AFHTTPRequestOperation *)findFriendsByName:(NSString *)  nameForSearch
                                      success:(successBlockWithId)success
                                        error:(errorBlock)errorBlock {
    NSString *request=@"users?search=";
    request=[request stringByAppendingString:nameForSearch];
    
    
    return  [_requestManager GET:request
                     parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
                     {
                         success(responseObject);
                     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
                     {
                     errorBlock(error);
                     }];
}

- (AFHTTPRequestOperation *)PSFollowToUserWithID:(int)followerID fromUserWithID:(int)userID
                                       success:(successBlockWithId)success
                                         error:(errorBlock)errorBlock {
    NSString *request=[NSString stringWithFormat:@"users/%d/follow/%d",userID,followerID];
    
    return  [_requestManager GET:request
                      parameters:nil
                         success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 success(responseObject);
             }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 errorBlock(error);
             }];

    
}

- (AFHTTPRequestOperation *)PSUnfollowUserWithID:(int)followerID fromUserWithID:(int)userID
                                       success:(successBlockWithId)success
                                         error:(errorBlock)errorBlock {
    NSString *request=[NSString stringWithFormat:@"users/%d/unfollow/%d",userID,followerID];
    
    return  [_requestManager GET:request
                      parameters:nil
                         success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 success(responseObject);
             }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 errorBlock(error);
             }];
    
    
}

- (AFHTTPRequestOperation *)getInfoFromUser:(int)userID
                                       success:(successBlockWithId)success
                                         error:(errorBlock)errorBlock {
    NSString *request=[NSString stringWithFormat:@"users/%d",userID];
    
    return  [_requestManager GET:request
                      parameters:nil
                         success:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 success(responseObject);
             }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
                 errorBlock(error);
             }];
    
    
}




@end
