//
//  QYLivePhotoViewController.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/9.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYLivePhotoViewController.h"
#import "QYLivePhotoItem.h"
@interface QYLivePhotoViewController ()

@end

@implementation QYLivePhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    self.title = @"livePhoto";
    [self registerCell:QYMutableCellOfLivePhotoIdentifier withClass:[QYLivePhotoItem class]];
    QYAlbumLibrary *library = [QYAlbumLibrary sharedInstance];
    __block NSMutableArray *livePhotos = [[NSMutableArray alloc] init];
    [library getLivePhotoSource:^(NSMutableArray *resours) {
        livePhotos = resours;
    }];
    self.dataSource = livePhotos;
    [self refreshTableView];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QYLivePhotoItem *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:QYMutableCellOfLivePhotoIdentifier forIndexPath:indexPath];
    QYAsset *asset = [self.dataSource objectAtIndex:indexPath.row];
    UIImage *image = [asset getThumbImage];
    cell.contentView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    NSArray *sIndexPahts = [self.seletedDic allKeys];
    cell.seletedImage = [sIndexPahts containsObject:indexPath];
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
