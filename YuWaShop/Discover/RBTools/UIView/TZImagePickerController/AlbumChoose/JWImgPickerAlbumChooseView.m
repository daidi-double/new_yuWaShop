//
//  JWImgPickerAlbumChooseView.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/20.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWImgPickerAlbumChooseView.h"

@implementation JWImgPickerAlbumChooseView

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction{
    if (!self.dataArr)return;
    self.isOn = !self.isOn;
    if (self.isOn) {
        //开启
        self.chooseImageView.image = [UIImage imageNamed:@"imageTypeChoose_up"];
        if (!self.typeTableV) {
            self.typeTableV = [[[NSBundle mainBundle]loadNibNamed:@"JWImgPickerAlbumChooseTableView" owner:nil options:nil]firstObject];
            self.typeTableV.dataArr = self.dataArr;
            WEAKSELF;
            self.typeTableV.choosedTypeBlock = ^(NSString * index,NSString *chooseStr){
                weakSelf.chooseTypeBlock(index);
                weakSelf.nameLabel.text = chooseStr;
                weakSelf.nameLabelWidth.constant = [JWTools labelWidthWithLabel:weakSelf.nameLabel];
                [weakSelf setNeedsLayout];
                [weakSelf tapAction];
            };
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tapAction)];
            self.typeView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 284.f, kScreen_Width, kScreen_Height - 284.f)];
            self.typeView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.4f];
            [self.typeView addGestureRecognizer:tap];
        }
        [[UIApplication sharedApplication].keyWindow addSubview:self.typeTableV];
        [[UIApplication sharedApplication].keyWindow addSubview:self.typeView];
    }else{
        self.chooseImageView.image = [UIImage imageNamed:@"imageTypeChoose_down"];
        [self.typeTableV removeFromSuperview];
        [self.typeView removeFromSuperview];
    }
}

@end
