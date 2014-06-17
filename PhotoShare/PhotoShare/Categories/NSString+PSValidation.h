//
//  NSString+PSValidation.h
//  PhotoShare
//
//  Created by Евгений on 12.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PSValidation)

- (BOOL)ps_isNameValid;

- (BOOL)ps_isPasswordValid;

- (BOOL)ps_isEmailValid;

- (BOOL)ps_isFacebookIDValid;

@end
