//
//  QYTAlbumBaseViewController.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYTAlbumBaseViewController.h"

@interface QYTAlbumBaseViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView* tableView;

@end

@implementation QYTAlbumBaseViewController

- (NSMutableArray*)dataSource
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
    // Do any additional setup after loading the view.
    [self initTable];
}

- (void)initTable
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
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
