//
//  QYAlbumLibrary.h
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface QYAlbumLibrary : NSObject
/**
 *  判断是否有访问系统权限
 *
 *  @return YES 有权限
 */
+ (BOOL)allowAlbumPermisson;
/**
 *  询问系统权限
 *
 *  @param block 用户操作block
 */
+ (void)requestAlbumPermisson:(void (^)(BOOL gratened))block;
/**
 *  用户系统权限状态
 *
 *  @return 权限状态
 */
+ (PHAuthorizationStatus)albumPermissonStatues;
/**
 *  获取相册中 mediaType 所有资源
 *
 *  @param mediaType 资源类型
 *  @param block     读取完毕的block
 */
- (void)enumerateResources:(PHAssetMediaType)mediaType finishBlock:(void (^)(NSMutableArray* resours))block;
@end
