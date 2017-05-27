//
//  VIPTabBar.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/9/1.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "VIPTabBar.h"

@implementation VIPTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.backgroundColor=[UIColor greenColor];
//        self.alpha=1.0;
    }
    return self;
}



    
- (void)layoutSubviews{
        [super layoutSubviews];
        
        CGFloat endgeWidth = ACTUAL_WIDTH(18.f);
        CGFloat tabBarWidth = (self.width - endgeWidth*2)/self.numberCount;
        CGFloat tabBarY = self.height/2;
        NSInteger index = 0;
        for (UIView * subView in self.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                //这个 宽要先设置。  不然先设置了中心点 再改宽度  会出bug
                [subView setWidth:tabBarWidth];
                subView.center = CGPointMake(endgeWidth + tabBarWidth/2 + index * tabBarWidth, tabBarY);
                index++;
                
            }
        }
        
        
    }
    
    


@end
