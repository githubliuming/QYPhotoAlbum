//
//  QYPickerViewCotroller.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/9.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYPickerViewCotroller.h"
#import "QYGroupViewController.h"
#import "QYPickerConfig.h"

@interface QYPickerViewCotroller ()

@end

@implementation QYPickerViewCotroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    QYGroupViewController* rootVC = [[QYGroupViewController alloc] init];
    [self setViewControllers:@[ rootVC ] animated:YES];
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
