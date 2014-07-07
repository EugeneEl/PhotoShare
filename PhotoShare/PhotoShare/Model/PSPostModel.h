//
//  PSPostModel.h
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSPostModel : NSObject
@property (nonatomic, assign) NSInteger postID;
@property (nonatomic, copy)   NSString  *postImageURL;
@property (nonatomic, assign) double postImageLat;
@property (nonatomic ,assign) double postImageLng;
@property (nonatomic, copy)   NSString *postImageName;
@property (nonatomic, strong) NSArray *postArrayOfComments;
@property (nonatomic, strong) NSString *postTime;
@property (nonatomic, assign) NSInteger postLikesCount;



@end
