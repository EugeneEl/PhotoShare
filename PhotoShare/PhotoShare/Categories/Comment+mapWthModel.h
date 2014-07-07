//
//  Comment+mapWthModel.h
//  PhotoShare
//
//  Created by Евгений on 04.07.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import "Comment.h"
@class PSCommentModel;
@interface Comment (mapWthModel)
- (Comment *)commentWithMapModel:(PSCommentModel *)commentModel;
@end
