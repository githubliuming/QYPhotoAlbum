//
//  QYPhotoConstant.h
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#ifndef QYPhotoConstant_h
#define QYPhotoConstant_h
@class UIImage;
typedef NS_ENUM(NSInteger, QYPhotoLibarayAssertType) {

    QYPhotoLibarayAssertTypeAll,                 //相册所有元素
    QYPhotoLibarayAssertTypePhotos,              //所有图片
    QYPhotoLibarayAssertTypeVideo,               //所有视频
    QYPhotoLibarayAssertTypePanoramas,           //全景图片
    QYPhotoLibarayAssertTypeLivePhoto,           // livePhoto
    QYPhotoLibarayAssertTypeLivePhotoAndVideos,  // livePhoto和视频
};

typedef NS_ENUM(NSInteger, QYPhotoAssetType) {

    QYPhotoAssetTypeUnknown,             //位置类型
    QYPhotoAssetTypeImage,               //图片
    QYPhotoAssetTypeGif,                 // gif
    QYPhotoAssetTypeLiviePhoto,          // livePhoto
    QYPhotoAssetTypeVideo,               //视频
    QYPhotoAssetTypeVideoHighFrameRate,  //慢动作视频
    QYPhotoAssetTypeAudio,               //音频
    QYPhotoAssetTypeNetImage,
};

typedef NS_ENUM(NSInteger, QYAuthorizationStatus) {
    QYAuthorizationStatusNotDetermined = 0,  // 用户还没有关于这个应用程序做出了选择
    QYAuthorizationStatusRestricted,         // 这个应用程序未被授权访问图片数据。用户不能更改该应用程序的状态,可能是由于活动的限制,如家长控制到位。
    QYAuthorizationStatusDenied,             // 用户已经明确否认了这个应用程序访问图片数据
    QYAuthorizationStatusAuthorized          // 用户授权此应用程序访问图片数据
};

typedef void (^fetchAlbumCompletion)(NSArray* _Nullable array);
typedef void (^downloadProgressBlock)(double progress, NSError* _Nullable error);
typedef void (^requestImageBlock)(UIImage* _Nullable image);
typedef void (^requestVideoBlock)(NSURL* _Nullable url, NSError* _Nullable error);
typedef void (^deleteAssetCompletionBlock)(BOOL success, NSError* _Nullable error);

#pragma mark - notificationName
#define QYPhotoLibraryhasChangedNotification @"QYPhotoLibraryhasChangedNotification"
#endif /* QYPhotoConstant_h */
