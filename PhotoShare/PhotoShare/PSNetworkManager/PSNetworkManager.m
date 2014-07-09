//
//  PSNetworkManager.m
//  PhotoShare
//
//  Created by Евгений on 10.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//


/*
 "user_name": "April28",
 "posts": [
 {
 "text": "pinkphoto",
 "img_url": "http://test.intern.yalantis.com/api/img/4",
 "id": 5
 },
 {
 "text": "pinkphoto",
 "img_url": "http://test.intern.yalantis.com/api/img/5",
 "id": 7
 },
 {
 "text": "photolabel",
 "img_url": "http://test.intern.yalantis.com/api/img/6",
 "id": 8
 },
 {
 "text": "soda",
 "img_url": "http://test.intern.yalantis.com/api/img/7",
 "id": 9
 },
 {
 "text": "ice cream",
 "img_url": "http://test.intern.yalantis.com/api/img/8",
 "id": 10
 },
 {
 "text": "flower",
 "img_url": "http://test.intern.yalantis.com/api/img/9",
 "id": 11
 },
 {
 "text": "coffee",
 "img_url": "http://test.intern.yalantis.com/api/img/10",
 "id": 12
 }
 
 */

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
//        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer new];
        [_requestManager setRequestSerializer:[AFJSONRequestSerializer new]];
//        [serializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
//        [_requestManager setResponseSerializer:serializer];
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

- (AFHTTPRequestOperation *)checkIfLoginedWith:(PSUserModel *)model success:(successBlock)success error:(errorBlock)errorBlock
{
    return [_requestManager GET:@"users"
                     parameters:@{}
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                            success();
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                            errorBlock(error);
                        }];
}

- (AFHTTPRequestOperation *)signUpModel:(PSUserModel *)model
                                success:(successBlock)success
                                  error:(errorBlock)error
{
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
                             error:(errorBlock) error
{
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


- (void)someMethodThatTakesABlock:(void (^)(NSError* error))blockName
{
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
                                       error:(errorBlock)error
{
    
    
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

//Get posts


/*
 
 {
 "cnt_followers": 1,
 "followed": [],
 "user_name": "Skiv",
 "posts": [],
 "email": "skiv@mail.com",
 "image_id": null,
 "followers": [
 {
 "img_url": "http://test.intern.yalantis.com/api/img/3",
 "user_name": "J",
 "id": 1,
 "email": "black@man.com"
 }
 ],
 "cnt_posts": 0,
 "cnt_followed": 0,
 "password": "123",
 "img_url": null,
 "id": 2
 },
 {
 "cnt_followers": 0,
 "followed": [
 {
 "img_url": null,
 "user_name": "Skiv",
 "id": 2,
 "email": "skiv@mail.com"
 }
 ],
 "user_name": "J",
 "posts": [
 {
 "text": "Rammmmmm!",
 "img_url": "http://test.intern.yalantis.com/api/img/2",
 "id": 1
 }
 ],
 "email": "black@man.com",
 "image_id": 3,
 "followers": [],
 "cnt_posts": 1,
 "cnt_followed": 1,
 "password": "123",
 "img_url": "http://test.intern.yalantis.com/api/img/3",
 "id": 1
 },
 {
 "cnt_followers": 0,
 "followed": [],
 "user_name": "Ray412",
 "posts": [],
 "email": "ray412@yandex.ua",
 "image_id": null,
 "followers": [],
 "cnt_posts": 0,
 "cnt_followed": 0,
 "password": "1234567",
 "img_url": null,
 "id": 3
 },
 {
 "cnt_followers": 0,
 "followed": [],
 "user_name": "April28",
 "posts": [],
 "email": "april28@yandex.ua",
 "image_id": null,
 "followers": [],
 "cnt_posts": 0,
 "cnt_followed": 0,
 "password": "2223334",
 "img_url": null,
 "id": 4
 }
*/

//48.470311";
//longitude = "35.047674";
/*
 [
 {
 "author": {
 "user_name": "J",
 "id": 1,
 "email": "black@man.com"
 },
 "text": "Rammmmmm!",
 "comments": [
 {
 "text": "efdasdjhasjkdhas",
 "author_id": 1,
 "author": "J",
 "id": 1,
 "tstamp": "2014-07-03T09:36:41.445442"
 }
 ],
 "tstamp": "2014-07-03T09:36:41.441578",
 "likes": [
 {
 "email": "skiv@mail.com"
 }
 ],
 "lat": "51.586723",
 "lng": "56.366000",
 "img_url": "http://test.intern.yalantis.com/api/img/2",
 "id": 1
 }
 ]
 
*/

- (AFHTTPRequestOperation *) getPostsPage:(NSInteger)page
                             pageSize:(NSInteger)pageSize
                             success:(successBlockWithId)success
                             error:(errorBlock)error
                             userID:(NSInteger)userID
{
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
                                                error:(errorBlock)error
{
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
                             error:(errorBlock)error
{
    
    
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
                                 error:(errorBlock)errorWithCode

{
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
                                              error:(errorBlock)error
{
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
                                     error:(errorBlock)error
{
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
                               error:(errorBlock)errorWithCode

{

   
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







@end
