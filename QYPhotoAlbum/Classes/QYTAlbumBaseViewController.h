//
//  QYTAlbumBaseViewController.h
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface QYTAlbumBaseViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) NSMutableArray* dataSource;

- (void)registerCell:(NSString*)identifier withClass:(Class)aclass;
- (void)refreshTableView;
@end
