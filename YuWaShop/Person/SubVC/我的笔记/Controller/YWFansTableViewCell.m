//
//  YWFansTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWFansTableViewCell.h"

@implementation YWFansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   

    UIImageView*imageView=[self viewWithTag:1];
    imageView.layer.cornerRadius=20;
    imageView.image=[UIImage imageNamed:@"placeholder"];

    UIButton*followButton=[self viewWithTag:4];
    followButton.layer.cornerRadius=6;
    followButton.layer.borderWidth=1;
    followButton.layer.borderColor=CNaviColor.CGColor;

   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
