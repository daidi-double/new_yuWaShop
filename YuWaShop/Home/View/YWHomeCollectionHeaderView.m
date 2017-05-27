//
//  YWHomeCollectionHeaderView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeCollectionHeaderView.h"

@implementation YWHomeCollectionHeaderView
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

- (void)awakeFromNib {
    [super awakeFromNib];
    self.BGImageView.animationImages = self.BGImgArr;
    self.BGImageView.animationDuration = 3;
    self.BGImageView.animationRepeatCount = 0;
    [self.BGImageView startAnimating];
}

- (IBAction)payBtnAction:(id)sender {
    if (self.payBlock) {
        self.payBlock();
    }
}

- (IBAction)recordBtnAction:(id)sender {
    if (self.recordBlock) {
        self.recordBlock();
    }
}

@end
