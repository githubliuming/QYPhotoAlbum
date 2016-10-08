//
//  QYAsset.h
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import <Photos/Photos.h>
typedef void (^AlbumImageBlock)(UIImage *image);
@interface QYAsset : NSObject
- (instancetype)initWithPhAsset:(PHAsset *)asset;

- (UIImage *)getThumbImage;
- (UIImage *)getFullScreenImage;
@end
