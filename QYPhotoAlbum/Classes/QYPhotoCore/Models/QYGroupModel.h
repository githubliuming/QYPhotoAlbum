//
//  QYGroupModel.h
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QYAssetModel;
@interface QYGroupModel : NSObject<NSCopying,NSMutableCopying>

@property(nonatomic,strong)NSString * title;              ///<* 相册组标题
@property(nonatomic,strong)NSString * identifier;         ///<* 相册组唯一标志
@property(nonatomic,strong)QYAssetModel * coverAsset;     ///<* 组封面
@property(nonatomic,strong)NSMutableArray * asstArray;    ///<* 筛选出的


@end
