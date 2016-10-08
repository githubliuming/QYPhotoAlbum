//
//  QYAlbumLibrary.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYAlbumLibrary.h"

@implementation QYAlbumLibrary

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }

    return self;
}
+ (BOOL)allowAlbumPermisson { return [self albumPermissonStatues] == PHAuthorizationStatusAuthorized; }
+ (PHAuthorizationStatus)albumPermissonStatues { return [PHPhotoLibrary authorizationStatus]; }
+ (void)requestAlbumPermisson:(void (^)(BOOL gratened))block
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        BOOL gratened = status == PHAuthorizationStatusAuthorized;
        if (block)
        {
            block(gratened);
        }

    }];
}

- (void)enumerateResources:(PHAssetMediaType)mediaType finishBlock:(void (^)(NSMutableArray* resours))block
{
    //结果集合
    NSMutableArray* assetsResult = [[NSMutableArray alloc] init];

    PHFetchOptions* options = [[PHFetchOptions alloc] init];
    //筛选条件
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", mediaType];
    //排序条件
    options.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO] ];
    //开始筛选
    PHFetchResult<PHAssetCollection*>* result =
        [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                 subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                 options:nil];
    [result enumerateObjectsUsingBlock:^(PHAssetCollection* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        PHFetchResult<PHAsset*>* assets = [PHAsset fetchAssetsInAssetCollection:obj options:options];
        [assets enumerateObjectsUsingBlock:^(PHAsset* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {

            
            [assetsResult addObject:obj];
        }];

    }];

    if (block)
    {
        block(assetsResult);
    }
}
@end
