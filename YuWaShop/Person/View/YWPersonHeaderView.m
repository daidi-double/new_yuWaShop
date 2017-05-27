//
//  YWPersonHeaderView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonHeaderView.h"

@implementation YWPersonHeaderView
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.BGImgArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<60; i++) {
            NSString * path= [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"PersonHeaderBG%zi@2x",i] ofType:@"png"];
            if (path)[self.BGImgArr addObject:[UIImage imageWithContentsOfFile:path]];
        }
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.BGImageView.animationImages = self.BGImgArr;
    self.BGImageView.animationDuration = 3;
    self.BGImageView.animationRepeatCount = 0;
    [self.BGImageView startAnimating];
    self.BGImageHeight.constant = ACTUAL_WIDTH(250.f);
    self.iconImageTop.constant = ACTUAL_WIDTH(60.f);
    self.iconImageView.layer.cornerRadius = 44.f;
    self.iconImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.iconImageView addGestureRecognizer:tap];
    [self setNeedsDisplay];
}

- (void)tapAction{
    self.iconBtnBlock();
}

- (IBAction)touchBtnACtion:(UIButton *)sender {
    self.chooseBtnBlock(sender.tag);
}



@end
