//
//  QYBaseCollectionViewCell.m
//  QYPhotoAlbum
//
//  Created by liuming on 16/10/9.
//  Copyright © 2016年 burning. All rights reserved.
//

#import "QYBaseCollectionViewCell.h"

@interface QYBaseCollectionViewCell ()

@property(nonatomic, strong) UIView* foregroundView;
@property(nonatomic, strong) UIImageView* seletedImageView;
@end
@implementation QYBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.foregroundView = [[UIView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.foregroundView];
        self.seletedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        [self.contentView addSubview:self.seletedImageView];
        self.foregroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.seletedImageView.hidden = YES;
    }

    return self;
}
- (void)setSeletedImage:(BOOL)seletedImage
{
    _seletedImage = seletedImage;
    if (_seletedImage)
    {
        self.foregroundView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7];
        self.seletedImageView.hidden = NO;
    }
    else
    {
        self.foregroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.seletedImageView.hidden = YES;
    }
}
@end
