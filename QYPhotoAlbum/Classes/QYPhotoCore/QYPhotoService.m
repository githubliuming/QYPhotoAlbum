//
//  QYDataService.m
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYPhotoService.h"
#import "QYPhotoBrige.h"
@implementation QYPhotoService

+ (BOOL)hasAlbumAuthor{return [QYPhotoBrige hasAlbumAuthor];}

+ (PHAuthorizationStatus)albumPermissonStatues{return [QYPhotoBrige albumPermissonStatues];}
@end
