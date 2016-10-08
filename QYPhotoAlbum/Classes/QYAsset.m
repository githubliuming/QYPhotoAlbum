//
//  QYAsset.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYAsset.h"
@interface QYAsset ()

@property(nonatomic, strong) PHAsset *asset;
@end
@implementation QYAsset

- (instancetype)initWithPhAsset:(PHAsset *)asset
{
    self = [super init];
    if (self)
    {
        self.asset = asset;
    }

    return self;
}
@end
