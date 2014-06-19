//
//  NSString+PSValidation.m
//  PhotoShare
//
//  Created by Евгений on 12.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "NSString+PSValidation.h"

@implementation NSString (PSValidation)


- (BOOL)ps_isNameValid {
    return self.length > 2;
}

- (BOOL)ps_isPasswordValid {
    return self.length > 6;
}

- (BOOL)ps_isEmailValid {
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
        
    return  [emailTest evaluateWithObject:self];
        
}

- (BOOL)ps_isFacebookIDValid {
    
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    return  [alphaNums isSupersetOfSet:inStringSet];
}


@end
