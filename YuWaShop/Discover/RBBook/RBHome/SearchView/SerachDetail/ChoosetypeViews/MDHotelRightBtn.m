//
//  MDHotelRightBtn.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelRightBtn.h"

@implementation MDHotelRightBtn

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}
- (void)tapAction{
    //酒店界面
    self.isOn = !self.isOn;
    if (self.isOn) {
        //开启
        self.imgView.image = [UIImage imageNamed:@"icon-Upward-triangle"];
        if (!self.typeTableV) {
            self.typeTableV = [[[NSBundle mainBundle]loadNibNamed:@"MDHotelChooseTypeTableVC" owner:nil options:nil]firstObject];
            WEAKSELF;
            self.typeTableV.choosedTypeBlock = ^(NSString * index,NSString *chooseStr){
                weakSelf.chooseTypeBlock(index);
                weakSelf.tittleLabel.text = chooseStr;
                [weakSelf tapAction];
            };
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tapAction)];
            self.typeView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 184.f, kScreen_Width, kScreen_Height - 184.f)];
            self.typeView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.4f];
            [self.typeView addGestureRecognizer:tap];
        }
        [[UIApplication sharedApplication].keyWindow addSubview:self.typeTableV];
        [[UIApplication sharedApplication].keyWindow addSubview:self.typeView];
    }else{
        self.imgView.image = [UIImage imageNamed:@"icon-Downward-expansion"];
        [self.typeTableV removeFromSuperview];
        [self.typeView removeFromSuperview];
    }
}


@end
