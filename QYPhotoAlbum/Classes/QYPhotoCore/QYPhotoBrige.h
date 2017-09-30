//
//  QYPhotoBrige.h
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface QYPhotoBrige : NSObject

/**
 是否有相册权限
 @return YES --有权限 NO ---无权限
 */
+ (BOOL)hasAlbumAuthor;

/**
 相册权限状态

 @return 权限状态枚举
 */
+ (PHAuthorizationStatus)albumPermissonStatues;
@end
