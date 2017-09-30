//
//  QYPhotoConstant.h
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#ifndef QYPhotoConstant_h
#define QYPhotoConstant_h

typedef NS_ENUM (NSInteger,QYPhotoLibarayAssertType){

    QYPhotoLibarayAssertTypeAll,               //相册所有元素
    QYPhotoLibarayAssertTypePhotos,            //所有图片
    QYPhotoLibarayAssertTypeVideo,             //所有视频
    QYPhotoLibarayAssertTypePanoramas,         //全景图片
    QYPhotoLibarayAssertTypeLivePhoto,          //livePhoto
    QYPhotoLibarayAssertTypeLivePhotoAndVideos,//livePhoto和视频
};

typedef NS_ENUM(NSInteger,QYPhotoAssetType){

    QYPhotoAssertTypeUnknown,
    QYPhotoAssetTypeImage,
    QYPhotoAssetTypeVideo,
    
} ;
#endif /* QYPhotoConstant_h */
