//
//  QYAssetModel.m
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYAssetModel.h"
#import <Photos/PHAsset.h>
#import "QYPhotoService.h"
#import "PHAsset+covertToMP4.h"
@interface QYAssetModel ()

@property(nonatomic,strong) PHAsset * asset;
@property(nonatomic, strong) UIImage *cachedThumbnail;  // 缓存缩略图
@property(nonatomic, assign) PHImageRequestID requestID;
@end
@implementation QYAssetModel

- (instancetype) initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self) {
        
        self.medaiType = [self transformAssetType:_asset];
        self.identifer = _asset.localIdentifier;
        self.pixelWidth = _asset.pixelWidth;
        self.pixelHeight = _asset.pixelHeight;
        self.creationDate = _asset.creationDate;
        self.modificationDate = _asset.modificationDate;
        self.location = _asset.location;
        self.duration = self.duration;
        
    }
    return self;
}

//系统mediatype 转换为 自定义type
- (QYPhotoAssetType)transformAssetType:(PHAsset *)asset
{
    switch (asset.mediaType) {
        case PHAssetMediaTypeAudio:
            return QYPhotoAssetTypeAudio;
        case PHAssetMediaTypeVideo:{
        
            if(self.asset.mediaSubtypes == PHAssetMediaSubtypeVideoHighFrameRate){
            
                return QYPhotoAssetTypeVideoHighFrameRate;
            }
            return QYPhotoAssetTypeVideo;
        }
        case PHAssetMediaTypeImage:
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"])return QYPhotoAssetTypeGif;
            
            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive || asset.mediaSubtypes == 10) return QYPhotoAssetTypeLiviePhoto;
            
            return QYPhotoAssetTypeImage;
        default:
            return QYPhotoAssetTypeUnknown;
    }
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    QYAssetModel * assetModel = [[[self class] alloc] initWithAsset:_asset];
    return assetModel;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    QYAssetModel * assetModel = [[[self class] alloc]initWithAsset:_asset];
    return assetModel;
}

- (void)getOriginImage:(void(^)(UIImage * image))block{

    QYPhotoService * photoServices = [QYPhotoService shareInstanced];
   self.requestID = [photoServices requestOriginalImageForAsset:_asset completion:^(UIImage * _Nullable image) {
       
       if (block) {
           block(image);
       }
   } progressBlock:^(double progress, NSError * _Nullable error) {
       
   }];
    
}
- (void)getThumbleImageWithSize:(CGSize)size complention:(void(^)(UIImage * image)) completion{

    void (^finishBlock)(void) = ^{
        if (completion) {
            completion(self.cachedThumbnail);
        }
    };
    if (self.cachedThumbnail) {
        finishBlock();
        return;
    }
    __weak typeof(self) weakSelf = self;
    QYPhotoService * service = [QYPhotoService shareInstanced];
   self.requestID = [service requestImageForAsset:_asset size:size completion:^(UIImage * _Nullable image) {
       
       __strong typeof(self) strongSelf = weakSelf;
       if (strongSelf) {
           strongSelf.cachedThumbnail = image;
           finishBlock();
       } else {
           
           NSLog(@" QYAssetModel is nil");
       }
   } progressBlock:^(double progress, NSError * _Nullable error) {
       
        
   }];
}
- (void)getVideoUrl:(void(^)(NSURL * videoUrl))block{

    if(self.medaiType == QYPhotoAssetTypeLiviePhoto)
    {
    
        [self.asset getLivePhotoOfMP4Data:^(NSData *data, NSString *filePath, UIImage *coverImage) {
            
            if (block) {
                block([NSURL fileURLWithPath:filePath]);
            }
        }];
    } else if(self.medaiType == QYPhotoAssetTypeVideo || self.medaiType == QYPhotoAssetTypeVideoHighFrameRate){
    
        QYPhotoService * photoService = [QYPhotoService shareInstanced];
        [photoService requestVideoWithAsset:self.asset finish:^(NSURL *videoPath, NSError *error) {
            
        } progress:^(double progress, NSError *error) {
            
        }];
    }
    
}
@end