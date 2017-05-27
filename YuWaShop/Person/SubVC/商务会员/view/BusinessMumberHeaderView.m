//
//  BusinessMumberHeaderView.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "BusinessMumberHeaderView.h"

@implementation BusinessMumberHeaderView


-(void)awakeFromNib{
     [super awakeFromNib];
    
    UIView*totailView=[self viewWithTag:21];
    UITapGestureRecognizer*totailTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTotailTap)];
    [totailView addGestureRecognizer:totailTap];
    
    UIView*WillView=[self viewWithTag:22];
    UITapGestureRecognizer*WillTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchWillTap)];
    [WillView addGestureRecognizer:WillTap];
    self.BGImgArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<60; i++) {
        NSString * path= [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"PersonHeaderBG%zi@2x",i] ofType:@"png"];
        if (path)[self.BGImgArr addObject:[UIImage imageWithContentsOfFile:path]];
    }

    self.boliangImageView.animationImages = self.BGImgArr;
    self.boliangImageView.animationDuration = 3;
    self.boliangImageView.animationRepeatCount = 0;
    [self.boliangImageView startAnimating];

}


-(void)touchTotailTap{
   
    if (self.TotailBlock) {
        self.TotailBlock();
    }
    
}

-(void)touchWillTap{
    if (self.waitBlock) {
        self.waitBlock();
    }
    
}

@end
