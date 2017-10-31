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
@interface QYAssetModel : NSObject<NSCopying,NSMutableCopying>


- (instancetype) initWithAsset:(PHAsset *)asset;

@property(nonatomic,strong)NSString * identifer;
@property(nonatomic,assign) QYPhotoAssetType medaiType;

@property (nonatomic, assign) NSUInteger pixelWidth;
@property (nonatomic, assign) NSUInteger pixelHeight;

@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *modificationDate;

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, assign) NSTimeInterval duration;


/**
 获取原图

 @param block 回调
 */
- (void)getOriginImage:(void(^)(UIImage * image))block;
- (void)getThumbleImageWithSize:(CGSize)size complention:(void(^)(UIImage * image)) completion;
- (void)getVideoUrl:(void(^)(NSURL * videoUrl))blcok;
@end
