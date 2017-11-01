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

- (id)copyWithZone:(nullable NSZone *)zone
{
    QYGroupModel *groupModel = [[self class] allocWithZone:zone];
    groupModel.title = self.title;
    groupModel.asstArray = [self.asstArray mutableCopy];
    groupModel.identifier = self.identifier;
    groupModel.count = self.count;
    groupModel.coverAsset = [self.coverAsset copy];
    return groupModel;
}
- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    QYGroupModel *groupModel = [[[self class] alloc] init];
    groupModel.title = self.title;
    groupModel.asstArray = [self.asstArray mutableCopy];
    groupModel.identifier = self.identifier;
    groupModel.count = self.count;
    groupModel.coverAsset = [self.coverAsset copy];
    return groupModel;
}
@end
