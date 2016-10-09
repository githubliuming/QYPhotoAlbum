//
//  ViewController.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "ViewController.h"
#import "QYSeletedViewController.h"
#import "QYPickerViewCotroller.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)openAlbum:(id)sender
{
    QYPickerViewCotroller* vc = [[QYPickerViewCotroller alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:NULL];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
