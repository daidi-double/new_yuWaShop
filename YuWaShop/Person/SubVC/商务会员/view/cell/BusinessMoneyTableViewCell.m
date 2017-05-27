//
//  BusinessMoneyTableViewCell.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "BusinessMoneyTableViewCell.h"

@implementation BusinessMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    UIView*totailView=[self viewWithTag:21];
    UITapGestureRecognizer*totailTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTotailTap)];
    [totailView addGestureRecognizer:totailTap];
    
    UIView*todayView=[self viewWithTag:22];
    UITapGestureRecognizer*todayTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTodayTap)];
    [todayView addGestureRecognizer:todayTap];
    
    UIView*WillView=[self viewWithTag:23];
    UITapGestureRecognizer*WillTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchWillTap)];
    [WillView addGestureRecognizer:WillTap];

}

-(void)touchTotailTap{
    MyLog(@"1");
}

-(void)touchTodayTap{
    MyLog(@"2");

    
}

-(void)touchWillTap{
    MyLog(@"3");

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
