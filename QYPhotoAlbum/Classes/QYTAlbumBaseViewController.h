//
//  QYTAlbumBaseViewController.h
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYTAlbumBaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray* dataSource;

- (void) refreshTableView;
@end
