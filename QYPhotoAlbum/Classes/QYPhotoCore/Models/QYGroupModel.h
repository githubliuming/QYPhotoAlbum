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

@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * identifier;
@property(nonatomic,strong) NSMutableArray * asstArray;


@end
