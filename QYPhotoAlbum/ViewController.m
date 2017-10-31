//
//  ViewController.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/8.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "ViewController.h"
#import "QYPhotoService.h"
@interface ViewController ()
@property(nonatomic,strong) QYPhotoService * svervice;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.svervice = [[QYPhotoService alloc] init];
}

- (IBAction)openAlbum:(id)sender
{

    NSString * gifPath = [[NSBundle mainBundle] pathForResource:@"8e6b5520bf718f894833b480acad68d9" ofType:@"gif"];
//    NSData * data = [NSData dataWithContentsOfFile:gifPath];
    
    [self.svervice saveImageToAlblm:[NSURL fileURLWithPath:gifPath] customAlbumName:nil completion:^(BOOL suc, PHAsset * asset) {
        
        if(suc){
        
            NSLog(@"保存成功");
            
        } else {
        
            NSLog(@"保存失败");
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
