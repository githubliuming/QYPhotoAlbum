//
//  QYPhotoBrige.m
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYPhotoBrige.h"
#import "QYGroupModel.h"
#import "QYAssetModel.h"
#import "QYPhotoConstant.h"
@interface QYPhotoBrige()
@property(nonatomic,strong) NSOperationQueue * photoLibrayQueue;


@end
@implementation QYPhotoBrige

+ (BOOL)hasAlbumAuthor{return ([self albumPermissonStatues] == PHAuthorizationStatusAuthorized);}

+ (PHAuthorizationStatus)albumPermissonStatues { return [PHPhotoLibrary authorizationStatus]; }

-(instancetype)init{

    self = [super init];
    if (self) {
        
        self.photoLibrayQueue = [[NSOperationQueue alloc] init];
        self.photoLibrayQueue.maxConcurrentOperationCount = 5;
    }
    return self;
}


- (void)fetchAllGroups{

    [self.photoLibrayQueue addOperationWithBlock:^{
       
        NSMutableArray * photoGroups = [[NSMutableArray alloc] init];
        NSArray * allAlbums = [self AllGroupAlbums];
        
        for (PHFetchResult * album in allAlbums) {
            
            [album enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                if (![obj isKindOfClass:[PHAssetCollection class]]) return;
                
                PHAssetCollection * collection = (PHAssetCollection *)obj;
                if (collection.localizedTitle.length > 0) {
                    
                    QYGroupModel * groupModel = [[QYGroupModel alloc] init];
                    groupModel.title  = collection.localizedTitle;
                    groupModel.identifier = collection.localIdentifier;
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

                }
            }];
        }
    }];
}
- (NSMutableArray *)fetchAssertWithCollection:(PHAssetCollection *)collection{

    NSMutableArray * assertArray = [[NSMutableArray alloc] init];
    if (collection) {
        
        [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        
    }
    return assertArray;
    
}

- (NSArray *)AllGroupAlbums{

    PHFetchResult *smartAlbums =
    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
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
    return  allAlbums;
}

- (PHFetchOptions *)getFetchOptionWithType:(QYPhotoLibarayAssertType)type{

    PHFetchOptions  * option = nil;
    switch (type) {
        case QYPhotoLibarayAssertTypeAll:
        {
        
        } break;
        case QYPhotoLibarayAssertTypePhotos:
        {
        
        }break;
        case QYPhotoLibarayAssertTypeVideo:
        {
        
        }break;
        case QYPhotoLibarayAssertTypePanoramas:
        {
        
        }break;
        case QYPhotoLibarayAssertTypeLivePhoto:
        {
        
        }break;
        case QYPhotoLibarayAssertTypeLivePhotoAndVideos:
        {
        
        }break;
        default:
            break;
    }
    return option;
}
@end
