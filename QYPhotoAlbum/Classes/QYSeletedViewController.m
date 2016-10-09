//
//  QYSeletedViewController.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYSeletedViewController.h"
#import "QYAsset.h"
#import "QYAlbumLibrary.h"
#import "QYImageItem.h"
#import "QYPickerConfig.h"
@interface QYSeletedViewController ()
@end

@implementation QYSeletedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self registerCell:QYMutableCellIdentifier withClass:[QYImageItem class]];
    if ([QYAlbumLibrary allowAlbumPermisson])
    {
        [self requsetImages];
    }
    else
    {
        if ([QYAlbumLibrary albumPermissonStatues] == PHAuthorizationStatusNotDetermined)
        {
            __weak typeof(self) weakSelf = self;
            [QYAlbumLibrary requestAlbumPermisson:^(BOOL gratened) {

                if (gratened)
                {
                    [weakSelf requsetImages];
                }
            }];
        }
        else
        {
            //权限被拒 无法访问相册
        }
    }
}

- (void)requsetImages
{
    QYAlbumLibrary *library = [[QYAlbumLibrary alloc] init];
    __block NSMutableArray *images = nil;
    [library enumerateResources:PHAssetMediaTypeImage
                    finishBlock:^(NSMutableArray *resours) {
                        images = resours;
                    }];

    self.dataSource = images;
    [self refreshTableView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QYImageItem *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:QYMutableCellIdentifier forIndexPath:indexPath];
    QYAsset *asset = [self.dataSource objectAtIndex:indexPath.row];
    UIImage *image = [asset getThumbImage];
    cell.contentView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    NSArray *sIndexPahts = [self.seletedDic allKeys];
    cell.seletedImage = [sIndexPahts containsObject:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // item 点击
    QYImageItem *item = (QYImageItem *)[collectionView cellForItemAtIndexPath:indexPath];
    NSArray *sIndexPahts = [self.seletedDic allKeys];
    if ([sIndexPahts containsObject:indexPath])
    {
        [self.seletedDic removeObjectForKey:indexPath];
        item.contentView.backgroundColor = [UIColor whiteColor];
        item.seletedImage = NO;
    }
    else
    {
        if ([self checkMaxSeletedNum:maxSeletedNum])
        {
            item.seletedImage = YES;
            QYAsset *asset = [self.dataSource objectAtIndex:indexPath.row];
            [self.seletedDic setObject:asset forKey:indexPath];
        }
        else
        {
            [self showTipMsg:[NSString stringWithFormat:@"最多选择%d张图片", maxSeletedNum]];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
