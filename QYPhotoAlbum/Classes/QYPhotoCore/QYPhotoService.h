//
//  QYDataService.h
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYPhotoService : NSObject

/**
 是否具有相册权限

 @return YES 已经授权 -- NO 未授权 
 */
+ (BOOL)hasAlbumAuthor;

/**
 相册权限状态
 
 @return 权限状态枚举
 */
+ (PHAuthorizationStatus)albumPermissonStatues;

- (void)fetchAllGroups;
@end
