//
//  ViewController.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "ViewController.h"
#import "QYPhotoService.h"
#import "PLAlbumContensCell.h"
#import "QYGroupModel.h"
#import "QYPhotoListVC.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) QYPhotoService *svervice;

@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) UITableView *listTable;
@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation ViewController

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"首页";

    self.listTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.listTable.backgroundColor = [UIColor whiteColor];
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    self.listTable.rowHeight = 76;
    self.listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTable.showsVerticalScrollIndicator = NO;
    self.listTable.showsHorizontalScrollIndicator = NO;
    self.listTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.listTable];

    self.indicatorView =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.frame = CGRectMake((CGRectGetWidth(self.view.bounds) - 100) / 2.0,
                                          (CGRectGetHeight(self.view.bounds) - 100) / 2.0, 100, 100);
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    [QYPhotoService requestAuthor:^(BOOL hasAuthor) {
        if (hasAuthor)
        {
            [self loadAlblums];
        }
    }];
}

- (void)loadAlblums
{
    [[QYPhotoService shareInstanced] fetchAllGroupsWithcompletion:^(NSArray *_Nullable array) {

        if (array)
        {
            [self.dataSource addObjectsFromArray:array];
            [self.listTable reloadData];
        }
        [self.indicatorView stopAnimating];
        [self.indicatorView removeFromSuperview];
        self.indicatorView = nil;
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"AlbumContentsCellId";

    PLAlbumContensCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell)
    {
        cell = [[PLAlbumContensCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.indexPath = indexPath;
    QYGroupModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [cell setContentModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    QYGroupModel *groupModel = self.dataSource[indexPath.row];
    QYPhotoListVC *listVC = [[QYPhotoListVC alloc] init];
    listVC.title = groupModel.title;
    listVC.dataSource = [groupModel.asstArray mutableCopy];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (IBAction)openAlbum:(id)sender
{
    //    NSString * gifPath = [[NSBundle mainBundle] pathForResource:@"8e6b5520bf718f894833b480acad68d9"
    //    ofType:@"gif"];
    //    NSData * data = [NSData dataWithContentsOfFile:gifPath];

    //    [self.svervice saveImageToAlblm:[NSURL fileURLWithPath:gifPath] customAlbumName:nil completion:^(BOOL suc,
    //    PHAsset * asset) {
    //
    //        if(suc){
    //
    //            NSLog(@"保存成功");
    //
    //        } else {
    //
    //            NSLog(@"保存失败");
    //        }
    //    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
