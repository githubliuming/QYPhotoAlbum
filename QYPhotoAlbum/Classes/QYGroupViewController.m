//
//  QYGroupViewController.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/9.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYGroupViewController.h"
#import "QYPickerConfig.h"
#import "QYAlbumLibrary.h"
#import "QYSeletedViewController.h"
#import "QYLivePhotoViewController.h"
#import "QYVideoViewController.h"
@interface QYGroupViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation QYGroupViewController

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [[NSMutableArray alloc] initWithArray:@[ @"相机图片", @"视频", @"livePhoto" ]];
    }

    return _dataSource;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initTabel];
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
- (void)initTabel
{
    CGRect frame = self.view.bounds;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QYPickerViewCellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:QYPickerViewCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        [self openCameraImage];
    }
    if (indexPath.row == 1)
    {
        [self openVideo];
    }
    if (indexPath.row == 2)
    {
        [self openLivePhoto];
    }
}
- (void)cancelBtnClicked:(id)sender { [self dismissViewControllerAnimated:YES completion:NULL]; }
- (void)openCameraImage
{
    QYSeletedViewController *vc = [[QYSeletedViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openLivePhoto
{
    QYLivePhotoViewController *livePhotoVC = [[QYLivePhotoViewController alloc] init];
    [self.navigationController pushViewController:livePhotoVC animated:YES];
}
- (void)openVideo
{
    QYVideoViewController *videoVC = [[QYVideoViewController alloc] init];
    [self.navigationController pushViewController:videoVC animated:YES];
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
