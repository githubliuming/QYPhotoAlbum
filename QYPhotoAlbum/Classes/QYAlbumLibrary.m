//
//  QYAlbumLibrary.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYAlbumLibrary.h"
#import "QYAsset.h"
#import "QYPickerConfig.h"
@implementation QYAlbumLibrary

+ (instancetype)sharedInstance
{
    static QYAlbumLibrary* lib = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        if (lib == nil)
        {
            lib = [[QYAlbumLibrary alloc] init];
        }
    });

    return lib;
}

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

- (void)enumerateResources:(PHFetchOptions*)options finishBlock:(void (^)(NSMutableArray* resours))block
{
    //结果集合
    NSMutableArray* assetsResult = [[NSMutableArray alloc] init];
    PHFetchResult<PHAssetCollection*>* result =
        [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                 subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                 options:nil];
    [result enumerateObjectsUsingBlock:^(PHAssetCollection* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        PHFetchResult<PHAsset*>* assets = [PHAsset fetchAssetsInAssetCollection:obj options:options];
        [assets enumerateObjectsUsingBlock:^(PHAsset* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
            QYAsset* asst = [[QYAsset alloc] initWithPhAsset:obj];
            [assetsResult addObject:asst];
        }];

    }];

    if (block)
    {
        block(assetsResult);
    }
}

- (void)getAllImageSource:(void (^)(NSMutableArray* resours))block
{
    PHFetchOptions* options = [self getNewOptions:PHAssetMediaTypeImage mediaSubtype:PHAssetMediaSubtypeNone];
    [self enumerateResources:options finishBlock:block];
}
- (void)getAllVideoSource:(void (^)(NSMutableArray*))block
{
    PHFetchOptions* options = [self getNewOptions:PHAssetMediaTypeVideo mediaSubtype:PHAssetMediaSubtypeNone];
    [self enumerateResources:options finishBlock:block];
}
- (void)getLivePhotoSource:(void (^)(NSMutableArray*))block
{
    // livePhoto 9.1以后才支持
    double sysVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    if (sysVersion >= 9.1)
    {
        PHFetchOptions* options = [self getNewOptions:PHAssetMediaTypeImage mediaSubtype:PHAssetMediaSubtypePhotoLive];
        [self enumerateResources:options finishBlock:block];
    }
    else
    {
        if (block)
        {
            NSMutableArray* results = [[NSMutableArray alloc] init];
            block(results);
        }
    }
}
- (PHFetchOptions*)getNewOptions:(PHAssetMediaType)mediaType mediaSubtype:(PHAssetMediaSubtype)mediaSubtype
{
    PHFetchOptions* options = [[PHFetchOptions alloc] init];
    //筛选条件
    if (mediaSubtype != PHAssetMediaSubtypeNone)
    {
        options.predicate =
            [NSPredicate predicateWithFormat:@"mediaType = %d and mediaSubtype == %d", mediaType, mediaSubtype];
    }
    else
    {
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d  ", mediaType];
    }

    //排序条件
    options.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO] ];
    return options;
}
- (PHFetchResult<PHAssetCollection*>*)getAllAlbumFetchResultWith:(PHAssetCollectionType)CollectionType
                                                         subtype:(PHAssetCollectionSubtype)subtype
{
    PHFetchResult<PHAssetCollection*>* result =
        [PHAssetCollection fetchAssetCollectionsWithType:CollectionType subtype:subtype options:nil];
    return result;
}
- (NSMutableArray*)getAllSmartAlbums
{
    NSMutableArray* results = [[NSMutableArray alloc] init];

    PHFetchResult<PHAssetCollection*>* albums =
        [self getAllAlbumFetchResultWith:PHAssetCollectionTypeSmartAlbum
                                 subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary];
    for (NSInteger i = 0; i < albums.count; i++)
    {
        PHAssetCollection* collection = [albums objectAtIndex:i];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        if (collection.localizedTitle.length > 0)
        {
            [dic setObject:collection.localizedTitle forKey:QYGroupName];
            [results addObject:dic];
        }
    }

    return results;
}
@end
