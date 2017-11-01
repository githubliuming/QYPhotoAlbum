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

@property(nonatomic, assign) PHImageRequestID requestID;
@end
@implementation QYAssetModel

- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    if (self)
    {
        self.asset = asset;
        self.medaiType = [self transformAssetType:_asset];
    }
    return self;
}

//系统mediatype 转换为 自定义type
- (QYPhotoAssetType)transformAssetType:(PHAsset *)asset
{
    switch (asset.mediaType)
    {
        case PHAssetMediaTypeAudio:
            return QYPhotoAssetTypeAudio;
        case PHAssetMediaTypeVideo:
        {
            if (self.asset.mediaSubtypes == PHAssetMediaSubtypeVideoHighFrameRate)
            {
                return QYPhotoAssetTypeVideoHighFrameRate;
            }
            return QYPhotoAssetTypeVideo;
        }
        case PHAssetMediaTypeImage:
            if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) return QYPhotoAssetTypeGif;

            if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive || asset.mediaSubtypes == 10)
                return QYPhotoAssetTypeLiviePhoto;

            return QYPhotoAssetTypeImage;
        default:
            return QYPhotoAssetTypeUnknown;
    }
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    QYAssetModel *assetModel = [[[self class] alloc] initWithAsset:_asset];
    return assetModel;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    QYAssetModel *assetModel = [[[self class] alloc] initWithAsset:_asset];
    return assetModel;
}
@end
