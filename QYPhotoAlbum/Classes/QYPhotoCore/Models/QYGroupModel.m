//
//  QYGroupModel.m
//  QYPhotoAlbum
//
//  Created by yoyo on 2017/9/30.
//  Copyright © 2017年 burning. All rights reserved.
//

#import "QYGroupModel.h"
#import "QYAssetModel.h"
@implementation QYGroupModel

- (id)copyWithZone:(nullable NSZone *)zone{

    QYGroupModel * groupModel = [[QYGroupModel alloc] init];
    groupModel.title = self.title;
    groupModel.asstArray = [self.asstArray mutableCopy];
    groupModel.identifier =self.identifier;
    return groupModel;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone{

    QYGroupModel * groupModel = [[QYGroupModel alloc] init];
    groupModel.title = self.title;
    groupModel.asstArray = [self.asstArray mutableCopy];
    groupModel.identifier =self.identifier;
    return groupModel;
}
@end
