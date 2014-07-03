//
//  PSUserModel.h
//  PhotoShare
//
//  Created by Евгений on 10.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSUserModel : NSObject

@property(nonatomic,copy)   NSString  *email;
//@property(nonatomic,copy) NSString  *facebookId;
@property(nonatomic,copy)   NSString  *password;
@property (nonatomic,copy)  NSString  *name;
@property (nonatomic,assign,getter = isSignUpValid,readonly) BOOL     signUpValid;
@property (nonatomic,assign,getter = isLoginValid,readonly)  BOOL     loginValid;

@end
