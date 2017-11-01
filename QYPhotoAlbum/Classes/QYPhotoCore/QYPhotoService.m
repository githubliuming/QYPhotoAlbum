//
//  QYDataService.m
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYPhotoService.h"
#import "QYGroupModel.h"
#import "QYAssetModel.h"
#import "QYPhotoLibraryObserver.h"
@interface QYPhotoService ()

@property(nonatomic, strong) NSOperationQueue *photoLibrayQueue;

@property(nonatomic, strong) QYPhotoLibraryObserver *libraryObserver;
@end

@implementation QYPhotoService

- (QYPhotoLibraryObserver *)libraryObserver
{
    if (_libraryObserver == nil)
    {
        _libraryObserver = [[QYPhotoLibraryObserver alloc] init];
    }
    return _libraryObserver;
}
+ (instancetype)shareInstanced
{
    static QYPhotoService *photo_service_obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        if (photo_service_obj == nil)
        {
            photo_service_obj = [[QYPhotoService alloc] init];
        }
    });
    return photo_service_obj;
}

+ (BOOL)hasAlbumAuthor { return ([self albumPermissonStatues] == PHAuthorizationStatusAuthorized); }
+ (void)requestAuthor:(void (^)(BOOL hasAuthor))block
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {

        QYAuthorizationStatus qy_status = [self tranformAuthorStatus:status];
        if (block)
        {
            block(qy_status == QYAuthorizationStatusAuthorized);
        }
    }];
}
+ (QYAuthorizationStatus)albumPermissonStatues
{
    PHAuthorizationStatus ph_authorStatus = [PHPhotoLibrary authorizationStatus];
    return [self tranformAuthorStatus:ph_authorStatus];
}

+ (QYAuthorizationStatus)tranformAuthorStatus:(PHAuthorizationStatus)status
{
    QYAuthorizationStatus authorStatus;
    switch (status)
    {
        case PHAuthorizationStatusDenied:
        {
            authorStatus = QYAuthorizationStatusDenied;
        }
        break;
        case PHAuthorizationStatusAuthorized:
        {
            authorStatus = QYAuthorizationStatusAuthorized;
        }
        break;
        case PHAuthorizationStatusRestricted:
        {
            authorStatus = QYAuthorizationStatusRestricted;
        }
        break;
        case PHAuthorizationStatusNotDetermined:
        {
            authorStatus = QYAuthorizationStatusNotDetermined;
        }
        break;
        default:
        {
            authorStatus = QYAuthorizationStatusNotDetermined;
        }
        break;
    }
    return authorStatus;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.photoLibrayQueue = [[NSOperationQueue alloc] init];
        self.photoLibrayQueue.maxConcurrentOperationCount = 5;
    }
    return self;
}
- (void)fetchAllGroupsWithType:(QYPhotoLibarayAssertType)type completion:(fetchAlbumCompletion)completion
{
    [self.photoLibrayQueue addOperationWithBlock:^{

        NSMutableArray *photoGroups = [[NSMutableArray alloc] init];
        NSArray *allAlbums = [self AllGroupAlbums];

        for (PHFetchResult *album in allAlbums)
        {
            [album enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

                if (![obj isKindOfClass:[PHAssetCollection class]]) return;
                PHAssetCollection *collection = (PHAssetCollection *)obj;
                //过滤最近删除
                if (collection.assetCollectionSubtype > 213) return;

                NSArray *assetArray = [self fetchAssetWithCollection:collection withFetchType:type];
                if (assetArray.count <= 0)
                {
                    return;
                }
                if (collection.localizedTitle.length > 0)
                {
                    QYGroupModel *groupModel = [[QYGroupModel alloc] init];
                    groupModel.title = collection.localizedTitle;
                    groupModel.identifier = collection.localIdentifier;
                    NSLog(@"%@", collection.localizedTitle);
                    groupModel.count = assetArray.count;
                    if (collection.assetCollectionType == PHAssetCollectionTypeSmartAlbum &&
                        collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary)
                    {
                        if (photoGroups.count <= 0)
                        {
                            [photoGroups addObject:groupModel];
                        }
                        else
                        {
                            [photoGroups insertObject:groupModel atIndex:0];
                        }
                    }
                    else
                    {
                        [photoGroups addObject:groupModel];
                    }
                    groupModel.asstArray = [[NSMutableArray alloc] initWithArray:assetArray];
                    groupModel.coverAsset = [[assetArray lastObject] copy];
                }
            }];
        }

        if (completion)
        {
            [self runMainThread:^{

                completion([[NSArray alloc] initWithArray:photoGroups]);
            }];
        }
    }];
}
- (void)fetchAllGroupsWithcompletion:(fetchAlbumCompletion)completion
{
    [self fetchAllGroupsWithType:QYPhotoLibarayAssertTypeAll completion:completion];
}

- (void)fetchCameraRollAlbumListWithType:(QYPhotoLibarayAssertType)type completion:(fetchAlbumCompletion)completion
{
    [self.photoLibrayQueue addOperationWithBlock:^{

        PHFetchResult<PHAssetCollection *> *smartAlbums =
            [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                     subtype:PHAssetCollectionSubtypeAlbumRegular
                                                     options:nil];

        NSMutableArray *groups = [[NSMutableArray alloc] init];
        [smartAlbums
            enumerateObjectsUsingBlock:^(PHAssetCollection *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

                if (![obj isKindOfClass:[PHAssetCollection class]]) return;

                QYGroupModel *groupModel = [[QYGroupModel alloc] init];
                groupModel.title = obj.localizedTitle;
                groupModel.identifier = obj.localIdentifier;

                if (obj.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary)
                {
                    if (obj.localizedTitle.length > 0)
                    {
                        NSArray *medias = [self fetchAssetWithCollection:obj withFetchType:type];
                        groupModel.asstArray = [[NSMutableArray alloc] initWithArray:medias];
                        groupModel.count = medias.count;
                        groupModel.coverAsset = [[medias lastObject] copy];
                        [groups addObject:groupModel];
                    }
                }
            }];

        if (completion)
        {
            [self runMainThread:^{

                completion(groups);
            }];
        }
    }];
}
- (NSArray *)fetchAssetWithCollection:(PHAssetCollection *)collection withFetchType:(QYPhotoLibarayAssertType)type
{
    PHFetchOptions *fectchOptions = [self getFetchOptionWithType:type];
    return [self fectchAssetWithCollection:collection withOptions:fectchOptions];
}

- (NSArray *)fectchAssetWithCollection:(PHAssetCollection *)collection withOptions:(PHFetchOptions *)options
{
    NSMutableArray *assetArray = [[NSMutableArray alloc] init];
    if (collection)
    {
        PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (result.count > 0)
        {
            [result enumerateObjectsUsingBlock:^(PHAsset *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

                if ([obj isKindOfClass:[PHAsset class]])
                {
                    if (obj.mediaType == PHAssetMediaTypeUnknown)
                    {
                        NSLog(@" ---- 图片不支持");
                    }
                    QYAssetModel *assetModel = [[QYAssetModel alloc] initWithAsset:obj];
                    [assetArray addObject:assetModel];
                }
            }];
        }
    }
    return [[NSArray alloc] initWithArray:assetArray];
}

- (NSArray *)AllGroupAlbums
{
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeAny
                                                                          options:nil];
    // 我的照片流 1.6.10重新加入..
    PHFetchResult *myPhotoStreamAlbum =
        [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                 subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream
                                                 options:nil];

    //用户导入的相册
    PHFetchResult *facesAlbums =
        [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                 subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum
                                                 options:nil];
    //用户自定义相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    NSArray *allAlbums = @[ smartAlbums, myPhotoStreamAlbum, topLevelUserCollections, facesAlbums ];
    return allAlbums;
}

- (PHFetchOptions *)getFetchOptionWithType:(QYPhotoLibarayAssertType)type
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    switch (type)
    {
        case QYPhotoLibarayAssertTypeAll:
        {
            options.predicate = [NSPredicate
                predicateWithFormat:@"mediaType = %d or mediaType = %d", PHAssetMediaTypeImage, PHAssetMediaTypeVideo];
        }
        break;
        case QYPhotoLibarayAssertTypePhotos:
        {
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
        }
        break;
        case QYPhotoLibarayAssertTypeVideo:
        {
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeVideo];
        }
        break;
        case QYPhotoLibarayAssertTypePanoramas:
        {
            options.predicate =
                [NSPredicate predicateWithFormat:@"mediaType = %d and mediaSubtype == %d", PHAssetMediaTypeImage,
                                                 PHAssetMediaSubtypePhotoPanorama];
        }
        break;
        case QYPhotoLibarayAssertTypeLivePhoto:
        {
            double sysVersion = [[UIDevice currentDevice].systemVersion doubleValue];
            if (sysVersion >= 9.1f)
            {
                options.predicate =
                    [NSPredicate predicateWithFormat:@"mediaType = %d and mediaSubtype == %d", PHAssetMediaTypeImage,
                                                     PHAssetMediaSubtypePhotoLive];
            }
            else
            {
                options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
            }
        }
        break;
        case QYPhotoLibarayAssertTypeLivePhotoAndVideos:
        {
            double sysVersion = [[UIDevice currentDevice].systemVersion doubleValue];
            if (sysVersion >= 9.1f)
            {
                options.predicate =
                    [NSPredicate predicateWithFormat:@"mediaType = %d and mediaSubtype == %d", PHAssetMediaTypeImage,
                                                     PHAssetMediaSubtypePhotoLive];
            }
            else
            {
                options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
            }
        }
        break;
        default:
            break;
    }
    return options;
}
#pragma mark - 获取照片

- (PHImageRequestID)requestOriginalImageForAsset:(PHAsset *)asset
                                      completion:(requestImageBlock)completion
                                   progressBlock:(downloadProgressBlock)progressBlock
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeExact];
    options.networkAccessAllowed = YES;
    options.progressHandler =
        ^(double progress, NSError *_Nullable error, BOOL *_Nonnull stop, NSDictionary *_Nullable info) {

            if (progressBlock)
            {
                [self runMainThread:^{
                    progressBlock(progress, error);
                }];
            }
        };

    return [[PHCachingImageManager defaultManager]
        requestImageDataForAsset:asset
                         options:options
                   resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI,
                                   UIImageOrientation orientation, NSDictionary *_Nullable info) {

                       BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] &&
                                              ![info objectForKey:PHImageErrorKey] &&
                                              ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];

                       if (downloadFinined)
                       {
                           if (completion)
                           {
                               [self runMainThread:^{

                                   completion([UIImage imageWithData:imageData]);
                               }];
                           }
                       }
                       else
                       {
                           if ([[info objectForKey:PHImageCancelledKey] boolValue])
                           {
                               // PHImageCancelledKey 对应的值为真时代表用户手动取消云端下载
                               NSLog(@"PHImageCancelledKey 对应的值为真时代表用户手动取消云端下载");
                               return;
                           }
                           if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue])
                           {
                               if ([info[PHImageResultIsInCloudKey] integerValue] == 1)
                               {
                                   //下载失败
                                   if (completion)
                                   {
                                       [self runMainThread:^{
                                           completion(nil);

                                       }];
                                   }
                               }
                               else
                               {
                                   if (completion)
                                   {
                                       [self runMainThread:^{

                                           completion([UIImage imageWithData:imageData]);
                                       }];
                                   }
                               }
                           }
                       }
                   }];
}

/**
 * @brief 根据传入size获取图片
 */
- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset
                                    size:(CGSize)size
                              completion:(requestImageBlock)completion
                           progressBlock:(downloadProgressBlock)progressBlock
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = YES;
    option.progressHandler =
        ^(double progress, NSError *_Nullable error, BOOL *_Nonnull stop, NSDictionary *_Nullable info) {
            if (progressBlock)
            {
                [self runMainThread:^{

                    progressBlock(progress, error);
                }];
            }
        };

    return [self requestImageForAsset:asset
                                 size:size
                           completion:^(UIImage *image, NSDictionary *info) {

                               BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] &&
                                                      ![info objectForKey:PHImageErrorKey];
                               //不要该判断，即如果该图片在iCloud上时候，会先显示一张模糊的预览图，待加载完毕后会显示高清图
                               // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]
                               if (downloadFinined && completion)
                               {
                                   [self runMainThread:^{

                                       completion(image);
                                   }];
                               }

                           }];
}
/**
 * @brief 获取原图
 */
- (PHImageRequestID)requestOriginalImageForAsset:(PHAsset *)asset
                                      completion:(void (^)(UIImage *, NSDictionary *))completion
{
    return [self requestImageForAsset:asset
                                 size:CGSizeMake(asset.pixelWidth, asset.pixelHeight)
                           resizeMode:PHImageRequestOptionsResizeModeNone
                           completion:completion];
}

- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset
                                    size:(CGSize)size
                              completion:(void (^)(UIImage *, NSDictionary *))completion
{
    return [self requestImageForAsset:asset
                                 size:size
                           resizeMode:PHImageRequestOptionsResizeModeFast
                           completion:completion];
}

- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset
                                    size:(CGSize)size
                              resizeMode:(PHImageRequestOptionsResizeMode)resizeMode
                              completion:(void (^)(UIImage *, NSDictionary *))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    option.resizeMode = resizeMode;  //控制照片尺寸
    //    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    option.networkAccessAllowed = YES;

    /*
     info字典提供请求状态信息:
     PHImageResultIsInCloudKey：图像是否必须从iCloud请求
     PHImageResultIsDegradedKey：当前UIImage是否是低质量的，这个可以实现给用户先显示一个预览图
     PHImageResultRequestIDKey和PHImageCancelledKey：请求ID以及请求是否已经被取消
     PHImageErrorKey：如果没有图像，字典内的错误信息
     */
    return [self requestImageForAsset:asset size:size options:option completion:completion];
}

- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset
                                    size:(CGSize)size
                                 options:(PHImageRequestOptions *)options
                              completion:(void (^)(UIImage *, NSDictionary *))completion
{
    return [[PHCachingImageManager defaultManager]
        requestImageForAsset:asset
                  targetSize:size
                 contentMode:PHImageContentModeAspectFill
                     options:options
               resultHandler:^(UIImage *_Nullable image, NSDictionary *_Nullable info) {
                   BOOL downloadFinined =
                       ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey];
                   //不要该判断，即如果该图片在iCloud上时候，会先显示一张模糊的预览图，待加载完毕后会显示高清图
                   // && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]
                   if (downloadFinined && completion)
                   {
                       completion(image, info);
                   }
               }];
}
#pragma mark - 导出视频
- (PHImageRequestID)requestVideoWithAsset:(PHAsset *)asset
                                   finish:(requestVideoBlock)finishBlock
                                 progress:(downloadProgressBlock)progressHandler
{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
    options.version = PHVideoRequestOptionsVersionCurrent;
    if (progressHandler)
    {
        options.progressHandler =
            ^(double progress, NSError *_Nullable error, BOOL *_Nonnull stop, NSDictionary *_Nullable info) {

                [self runMainThread:^{

                    progressHandler(progress, error);
                }];
            };
    }
    return [self requestVideoWithiAsset:asset
                                options:options
                                 finish:^(NSURL *videoPath, NSError *error) {

                                     if (finishBlock)
                                     {
                                         [self runMainThread:^{
                                             finishBlock(videoPath, error);
                                         }];
                                     }
                                 }];
}

- (PHImageRequestID)requestVideoWithiAsset:(PHAsset *)asset
                                   options:(PHVideoRequestOptions *)options
                                    finish:(void (^)(NSURL *videoPath, NSError *error))finishBlock
{
    __weak typeof(self) weakSelf = self;
    PHImageManager *imageManager = [PHImageManager defaultManager];
    PHImageRequestID requestId = [imageManager
        requestAVAssetForVideo:asset
                       options:options
                 resultHandler:^(AVAsset *_Nullable asset, AVAudioMix *_Nullable audioMix,
                                 NSDictionary *_Nullable info) {

                     __strong typeof(weakSelf) strongSelf = weakSelf;
                     NSLog(@"video info = %@", info);

                     if ([[info objectForKey:PHImageCancelledKey] boolValue])
                     {
                         // PHImageCancelledKey 对应的值为真时代表用户手动取消云端下载
                         NSLog(@"PHImageCancelledKey 对应的值为真时代表用户手动取消云端下载");
                         return;
                     }

                     if ([asset isKindOfClass:[AVURLAsset class]])
                     {
                         NSURL *URL = [((AVURLAsset *)asset)URL];
                         if (finishBlock)
                         {
                             finishBlock(URL, nil);
                         }
                     }
                     else if ([asset isKindOfClass:[AVComposition class]])
                     {
                         //慢动作处理
                         NSString *fileName =
                             [NSString stringWithFormat:@"mergeSlowMoVideo_%lld.mov",
                                                        (long long)[[NSDate date] timeIntervalSince1970]];
                         NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(
                             NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                         ;
                         NSString *myPathDocs = [documentsDirectory stringByAppendingPathComponent:fileName];
                         NSURL *url = [NSURL fileURLWithPath:myPathDocs];

                         [strongSelf exportVideoWithComposition:asset
                                                        fileUrl:url
                                                     completion:^(NSURL *url, NSError *error) {

                                                         if (finishBlock)
                                                         {
                                                             finishBlock(url, error);
                                                         }
                                                     }];
                     }
                 }];
    return requestId;
}
#pragma mark - 视频/图片元素的 save

- (void)saveImageToAblum:(UIImage *)image
         customAlbumName:(NSString *)cAlbumName
              completion:(void (^)(BOOL, PHAsset *))completion
{
    void (^block)(BOOL suc, PHAsset *asset) = ^(BOOL suc, PHAsset *asset) {

        if (completion)
        {
            [self runMainThread:^{

                completion(suc, asset);
            }];
        }
    };
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied)
    {
        block(NO, nil);
    }
    else if (status == PHAuthorizationStatusRestricted)
    {
        block(NO, nil);
    }
    else
    {
        __block PHObjectPlaceholder *placeholderAsset = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *newAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            placeholderAsset = newAssetRequest.placeholderForCreatedAsset;
        }
            completionHandler:^(BOOL success, NSError *_Nullable error) {
                if (!success)
                {
                    block(NO, nil);
                    return;
                }
                PHAsset *asset = [self getAssetFromlocalIdentifier:placeholderAsset.localIdentifier];
                if (cAlbumName != nil)
                {
                    PHAssetCollection *desCollection = [self getDestinationCollectionWithName:cAlbumName];
                    block(NO, nil);

                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:desCollection]
                            addAssets:@[ asset ]];
                    }
                        completionHandler:^(BOOL success, NSError *_Nullable error) {
                            block(success, asset);
                        }];
                }
                else
                {
                    block(success, asset);
                }
            }];
    }
}

- (void)saveImageToAblum:(UIImage *)image completion:(void (^)(BOOL, PHAsset *))completion
{
    [self saveImageToAblum:image customAlbumName:nil completion:completion];
}

- (void)saveVideoToAblum:(NSURL *)url
         customAlbumName:(NSString *)cAlbumName
              completion:(void (^)(BOOL, PHAsset *))completion
{
    void (^block)(BOOL suc, PHAsset *asset) = ^(BOOL suc, PHAsset *asset) {

        if (completion)
        {
            [self runMainThread:^{

                completion(suc, asset);
            }];
        }
    };

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied)
    {
        block(NO, nil);
    }
    else if (status == PHAuthorizationStatusRestricted)
    {
        block(NO, nil);
    }
    else
    {
        __block PHObjectPlaceholder *placeholderAsset = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *newAssetRequest =
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
            placeholderAsset = newAssetRequest.placeholderForCreatedAsset;
        }
            completionHandler:^(BOOL success, NSError *_Nullable error) {
                if (!success)
                {
                    block(NO, nil);
                    return;
                }
                PHAsset *asset = [self getAssetFromlocalIdentifier:placeholderAsset.localIdentifier];
                if (cAlbumName != nil)
                {
                    PHAssetCollection *desCollection = [self getDestinationCollectionWithName:cAlbumName];
                    if (!desCollection) completion(NO, nil);

                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:desCollection]
                            addAssets:@[ asset ]];
                    }
                        completionHandler:^(BOOL success, NSError *_Nullable error) {

                            block(success, asset);

                        }];
                }
                else
                {
                    block(success, asset);
                }
            }];
    }
}
- (void)saveVideoToAblum:(NSURL *)url completion:(void (^)(BOOL, PHAsset *))completion
{
    [self saveVideoToAblum:url customAlbumName:nil completion:completion];
}

- (void)saveImageToAlblm:(NSURL *)gifUrl
         customAlbumName:(NSString *)cAlbumName
              completion:(void (^)(BOOL, PHAsset *))completion
{
    void (^block)(BOOL suc, PHAsset *asset) = ^(BOOL suc, PHAsset *asset) {

        if (completion)
        {
            [self runMainThread:^{

                completion(suc, asset);
            }];
        }
    };

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied)
    {
        block(NO, nil);
    }
    else if (status == PHAuthorizationStatusRestricted)
    {
        block(NO, nil);
    }
    else
    {
        __block PHObjectPlaceholder *placeholderAsset = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *newAssetRequest =
                [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:gifUrl];
            placeholderAsset = newAssetRequest.placeholderForCreatedAsset;
        }
            completionHandler:^(BOOL success, NSError *_Nullable error) {
                if (!success)
                {
                    block(NO, nil);
                    return;
                }
                PHAsset *asset = [self getAssetFromlocalIdentifier:placeholderAsset.localIdentifier];
                if (cAlbumName != nil)
                {
                    PHAssetCollection *desCollection = [self getDestinationCollectionWithName:cAlbumName];
                    block(NO, nil);

                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:desCollection]
                            addAssets:@[ asset ]];
                    }
                        completionHandler:^(BOOL success, NSError *_Nullable error) {
                            block(success, asset);
                        }];
                }
                else
                {
                    block(success, asset);
                }
            }];
    }
}

- (PHAsset *)getAssetFromlocalIdentifier:(NSString *)localIdentifier
{
    if (localIdentifier == nil)
    {
        NSLog(@"Cannot get asset from localID because it is nil");
        return nil;
    }
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[ localIdentifier ] options:nil];
    if (result.count)
    {
        return result[0];
    }
    return nil;
}

//获取自定义相册
- (PHAssetCollection *)getDestinationCollectionWithName:(NSString *)collectionName
{
    if (collectionName == nil)
    {
        return nil;
    }
    //找是否已经创建自定义相册
    PHFetchResult<PHAssetCollection *> *collectionResult =
        [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                 subtype:PHAssetCollectionSubtypeAlbumRegular
                                                 options:nil];
    for (PHAssetCollection *collection in collectionResult)
    {
        if ([collection.localizedTitle isEqualToString:collectionName])
        {
            return collection;
        }
    }
    //新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName]
                           .placeholderForCreatedAssetCollection.localIdentifier;
    }
                                                         error:&error];
    if (error)
    {
        NSLog(@"创建相册：%@失败", collectionName);
        return nil;
    }
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[ collectionId ] options:nil].lastObject;
}

- (void)deleteMedaiWithAsset:(PHAsset *)asset
        withCunstomAlubmName:(NSString *)albumName
                  completion:(deleteAssetCompletionBlock)completion
{
    void (^block)(BOOL suc, NSError *error) = ^(BOOL suc, NSError *error) {

        if (completion)
        {
            [self runMainThread:^{

                completion(suc, error);
            }];
        }
    };

    if (asset)
    {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{

            [PHAssetChangeRequest deleteAssets:@[ asset ]];

        }
            completionHandler:^(BOOL success, NSError *_Nullable error) {

                if (albumName != nil)
                {
                    PHAssetCollection *desCollection = [self getDestinationCollectionWithName:albumName];
                    block(NO, nil);

                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:desCollection]
                            addAssets:@[ asset ]];
                    }
                        completionHandler:^(BOOL success, NSError *_Nullable error) {
                            block(success, error);
                        }];
                }
                else
                {
                    block(success, error);
                }

            }];
    }
    else
    {
        NSError *error =
            [NSError errorWithDomain:@"相册元素不存在" code:0 userInfo:@{
                @"errorKey" : @"asset is nill"
            }];
        block(NO, error);
    }
}

- (void)deleteMedaiWithAsset:(PHAsset *)asset completion:(deleteAssetCompletionBlock)completion
{
    [self deleteMedaiWithAsset:asset completion:completion];
}
#pragma mark 导出视频
- (void)exportVideoWithComposition:(AVAsset *)asset
                           fileUrl:(NSURL *)fileUrl
                        completion:(void (^)(NSURL *url, NSError *error))completion
{
    AVAssetExportSession *exporter =
        [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = fileUrl;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (exporter.status == AVAssetExportSessionStatusCompleted)
            {
                NSURL *URL = exporter.outputURL;
                if (completion)
                {
                    completion(URL, nil);
                }
            }
            else
            {
                if (completion)
                {
                    completion(nil, exporter.error);
                }
            }
        });
    }];
}

- (void)runMainThread:(void (^)(void))block
{
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)cancelRequestID:(PHImageRequestID)requestId
{
    [[PHCachingImageManager defaultManager] cancelImageRequest:requestId];
}
#pragma mark - 注册/移除 PHLibrary Observer
- (void)registerObserver { [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self.libraryObserver]; }
- (void)removeRegisterObserver { [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self.libraryObserver]; }
@end
