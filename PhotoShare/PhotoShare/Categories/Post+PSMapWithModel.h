//
//  Post+mapWithModel.h
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Post.h"
@class PSPostModel;

@interface Post (mapWithModel)
- (Post *)mapWithModel:(PSPostModel*) postModel;
@end
