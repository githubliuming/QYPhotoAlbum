//
//  QYTAlbumBaseViewController.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYAlbumBaseViewController.h"
#import "QYPickerConfig.h"
#import "QYBaseCollectionViewCell.h"
#import "QYAsset.h"
@interface QYAlbumBaseViewController ()
@property(nonnull, strong) UICollectionView *collectionView;
@end

@implementation QYAlbumBaseViewController

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [[NSMutableArray alloc] init];
    }

    return _dataSource;
}
- (NSMutableDictionary *)seletedDic
{
    if (_seletedDic == nil)
    {
        _seletedDic = [[NSMutableDictionary alloc] init];
    }

    return _seletedDic;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTable];
}

- (void)initTable
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}
- (void)registerCell:(NSString *)identifier withClass:(Class)aclass
{
    [self.collectionView registerClass:aclass forCellWithReuseIdentifier:identifier];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double sizeWidth = (SCREEN_WIDTH - (colNum - 1) * colMargin) / colNum;
    return CGSizeMake(sizeWidth, sizeWidth);
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(colMargin, 0, colMargin, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                                      layout:(UICollectionViewLayout *)collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return colMargin;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                                 layout:(UICollectionViewLayout *)collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return colMargin;
}

#pragma mark 点击CollectionView触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // item 点击
    QYBaseCollectionViewCell *item = (QYBaseCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
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
- (void)refreshTableView { [self.collectionView reloadData]; }
- (BOOL)checkMaxSeletedNum:(int)num
{
    NSUInteger count = [[self.seletedDic allKeys] count];
    return count < num;
}
- (void)showTipMsg:(NSString *)tipString
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示"
                                                                     message:tipString
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:cancelAction];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:NULL];
}
- (void)initNav
{
    self.navigationItem.title = @"照片";
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 40);
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems = @[ item ];
}
- (void)cancelBtnClicked:(id)sender { [self dismissViewControllerAnimated:YES completion:NULL]; }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
