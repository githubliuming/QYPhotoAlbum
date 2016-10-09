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

#define QYMutableCellIdentifier @"QYMutableCellIdentifier"
@interface QYSeletedViewController ()

@end

@implementation QYSeletedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self registerCell:QYMutableCellIdentifier withClass:[UICollectionViewCell class]];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 80; }
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QYMutableCellIdentifier];
//    if (cell == nil)
//    {
//        cell =
//            [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//            reuseIdentifier:QYMutableCellIdentifier];
//    }
//    QYAsset *asset = [self.dataSource objectAtIndex:indexPath.row];
//    UIImage *image = [asset getThumbImage];
//    cell.imageView.image = image;
//    return cell;
//}

//- (CGFloat)

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:QYMutableCellIdentifier forIndexPath:indexPath];
    QYAsset *asset = [self.dataSource objectAtIndex:indexPath.row];
    UIImage *image = [asset getThumbImage];
    cell.contentView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    return cell;
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
