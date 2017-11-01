//
//  QYAssetModel.h
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QYPhotoConstant.h"
@class PHAsset;
@class CLLocation;
@class UIImage;
@interface QYAssetModel : NSObject<NSCopying, NSMutableCopying>

- (instancetype)initWithAsset:(PHAsset *)asset;

@property(nonatomic, strong) PHAsset *asset;
@property(nonatomic, assign) QYPhotoAssetType medaiType;
///**
// 获取原图
//
// @param block 回调
// */
//- (void)getOriginImage:(void (^)(UIImage *image))block progress:(downloadProgressBlock)progressBlock;
//
///**
//
// 获取缩略图片
// @param size 缩略图大小
// @param completion 完成回调
// */
//- (void)getThumbleImageWithSize:(CGSize)size complention:(void (^)(UIImage *image))completion;
//
///**
// 获取视频文件路径
//
// @param finishBlock 完成回调
// @param progressBlock 视频在云端的下载进度回调
// */
//- (void)getVideoUrl:(void (^)(NSURL *videoUrl))finishBlock progress:(downloadProgressBlock)progressBlock;
//
///**
// 取消从云端下载请求
// */
//- (void)cancelRequest;
@end
