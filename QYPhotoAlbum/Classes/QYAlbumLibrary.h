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

+ (instancetype)sharedInstance;
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
 *  获取相册中所有图片
 *
 *  @param block 结果回掉
 */
- (void)getAllImageSource:(void (^)(NSMutableArray* resours))block;
/**
 *  获取相册中的所有视频
 *
 *  @param block 结果回掉
 */
- (void)getAllVideoSource:(void (^)(NSMutableArray* resours))block;
/**
 *  获取相册中所有的livePhoto
 *
 *  @param block 结果回掉
 */
- (void)getLivePhotoSource:(void (^)(NSMutableArray* resours))block;

- (NSMutableArray*)getAllSmartAlbums;
@end
