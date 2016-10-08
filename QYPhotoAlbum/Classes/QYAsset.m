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

- (UIImage *)getThumbImage
{
    PHImageRequestOptions *options = [self getImageOptions];
    __block UIImage *image = nil;
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestImageForAsset:self.asset
                       targetSize:CGSizeMake(240, 240)
                      contentMode:PHImageContentModeAspectFill
                          options:options
                    resultHandler:^(UIImage *_Nullable result, NSDictionary *_Nullable info) {

                        image = result;
                    }];

    return image;
}

- (UIImage *)getFullScreenImage
{
    PHImageRequestOptions *options = [self getImageOptions];

    PHImageManager *manager = [PHImageManager defaultManager];
    __block UIImage *image = nil;
    [manager requestImageDataForAsset:self.asset
                              options:options
                        resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI,
                                        UIImageOrientation orientation, NSDictionary *_Nullable info) {

                            image = [UIImage imageWithData:imageData];
                        }];

    return image;
}
- (PHImageRequestOptions *)getImageOptions
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    [options setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [options setResizeMode:PHImageRequestOptionsResizeModeExact];
    [options setVersion:PHImageRequestOptionsVersionCurrent];
    options.networkAccessAllowed = NO;
    options.synchronous = YES;
    return options;
}
@end
