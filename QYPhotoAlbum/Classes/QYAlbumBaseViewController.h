//
//  QYTAlbumBaseViewController.h
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYAlbumBaseViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) NSMutableArray* dataSource;
@property(nonatomic, strong) NSMutableDictionary* seletedDic;  //记录选择的照片

- (void)registerCell:(NSString*)identifier withClass:(Class)aclass;
- (void)refreshTableView;
- (BOOL)checkMaxSeletedNum:(int)num;
- (void)showTipMsg:(NSString*)tipString;
- (void)initNav;
@end
