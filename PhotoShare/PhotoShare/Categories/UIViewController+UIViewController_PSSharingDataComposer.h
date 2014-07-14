//
//  UIViewController+UIViewController_PSSharingDataComposer.h
//  PhotoShare
//
//  Created by Евгений on 27.06.14.
//  Copyright (c) 2014 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIViewController (PSSharingDataComposer)


- (void)shareToTwitterWithData:(NSData *)photoData
                     photoName:(NSString *)photoTitle
                       success:(void(^)(void))success
                       failure:(void(^)(NSError *error))failure;
- (void)shareToFacebookWithData:(NSData *)photoData
                      photoName:(NSString *)photoTitle
                        success:(void(^)(void))success
                        failure:(void(^)(NSError *error))failure;

- (void)SaveToAlbumWithData:(NSData *)photoData
                    success:(void(^)(void))success
                    failure:(void(^)(NSError *error))failure;



@end
