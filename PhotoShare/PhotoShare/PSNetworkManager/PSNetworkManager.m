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
                                          @"password":model.password
                                        };
    
    return [_requestManager POST:@"users"
     
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
                             success:(successBlock)success
                             error:(errorBlock) error
{
    NSDictionary *dictionaryForRequest=@{ @"email":model.email,
                                          @"password":model.password};
    
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



@end
