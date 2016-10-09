//
//  QYVideoViewController.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/9.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYVideoViewController.h"
#import "QYVideoItem.h"
@interface QYVideoViewController ()

@end

@implementation QYVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initNav];
    [self registerCell:QYMutableCellOfVideoIdentifier withClass:[QYVideoItem class]];
    self.title = @"视频";
    QYAlbumLibrary *library = [QYAlbumLibrary sharedInstance];
    __block NSMutableArray *videos = [[NSMutableArray alloc] init];
    [library getAllVideoSource:^(NSMutableArray *resours) {

        videos = resours;
    }];
    self.dataSource = videos;
    [self refreshTableView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QYVideoItem *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:QYMutableCellOfVideoIdentifier forIndexPath:indexPath];
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
