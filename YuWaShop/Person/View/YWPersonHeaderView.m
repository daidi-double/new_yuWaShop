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
    if ([UserSession instance].routes.count<=0) {
        [self.myAccountBtn setTitle:[NSString stringWithFormat:@"管理员账号:%@ >",[UserSession instance].account] forState:UIControlStateNormal];
    }else{
        [self.myAccountBtn setTitle:[NSString stringWithFormat:@"门店账号:%@ >",[UserSession instance].account] forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
}
- (IBAction)childAccountAction:(UIButton *)sender {
    [self.delegate toChildAccountPage];
}

- (void)tapAction{
    self.iconBtnBlock();
}

- (IBAction)touchBtnACtion:(UIButton *)sender {
    self.chooseBtnBlock(sender.tag);
}



@end
