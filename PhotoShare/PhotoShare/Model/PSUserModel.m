//
//  PSUserModel.m
//  PhotoShare
//
//  Created by Евгений on 10.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "PSUserModel.h"
#import "NSString+PSValidation.h"

@implementation PSUserModel


- (BOOL) isSignUpValid
{

    return  ([self.name ps_isNameValid] && ([self.email ps_isEmailValid]) && ([self.password ps_isPasswordValid]) && ([self.facebookId ps_isFacebookIDValid]));
  
}

@end
