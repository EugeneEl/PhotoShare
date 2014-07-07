//
//  PScommentModel.h
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSCommentModel : NSObject

@property(nonatomic,copy)     NSString  *commentText;
@property(nonatomic,copy)     NSString  *commentDateString;
@property (nonatomic,copy)    NSString  *commentatorName;
@property (nonatomic,assign)  NSInteger commentID;


@end
