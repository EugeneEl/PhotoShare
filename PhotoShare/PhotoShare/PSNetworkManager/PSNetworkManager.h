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

typedef void (^successBlock)(void);
typedef void (^errorBlock)(NSError* error);

@interface PSNetworkManager : NSObject

+ (PSNetworkManager *) sharedManager;

- (AFHTTPRequestOperation *)signUpModel:(PSUserModel *)model
                            success:(successBlock)success
                            error:(errorBlock)error;

- (void)someMethodThatTakesABlock:(void (^)(NSError*))blockName;

- (AFHTTPRequestOperation *)checkIfLoginedWith:(PSUserModel *)model
                                       success:(successBlock)success
                                         error:(errorBlock)errorBlock;

- (AFHTTPRequestOperation *) loginWithModel:(PSUserModel*)model
                                    success:(successBlock)success
                                      error:(errorBlock) error;


- (AFHTTPRequestOperation *) fetchUserStream:(PSUserModel*)model
                                     success:(successBlock)success
                                       error:(errorBlock)error;

@end
