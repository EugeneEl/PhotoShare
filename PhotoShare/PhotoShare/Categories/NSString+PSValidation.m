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
    
    //in self storing the entered email in a string.**
    // Regular expression to checl the email format.**
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];

    
    /*
    NSString *emailRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    
    
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
     
     
     */
    //return [emailTest evaluateWithObject:self];
        
    return  [emailTest evaluateWithObject:self];
        
}

- (BOOL)ps_isFacebookIDValid {
    
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    return  [alphaNums isSupersetOfSet:inStringSet];
}


@end
