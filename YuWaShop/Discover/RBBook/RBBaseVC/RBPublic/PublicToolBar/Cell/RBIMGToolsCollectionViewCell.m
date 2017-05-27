//
//  RBIMGToolsCollectionViewCell.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/21.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RBIMGToolsCollectionViewCell.h"

@implementation RBIMGToolsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setFilterName:(NSString *)filterName{
    if (!filterName)return;
    UIImage *image = [JWTools filteredImage:[UIImage imageNamed:@"image_base"] withFilterName:filterName];
    self.showImageView.image = image;
}

@end
