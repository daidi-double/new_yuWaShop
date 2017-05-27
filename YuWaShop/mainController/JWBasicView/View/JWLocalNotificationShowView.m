//
//  JWLocalNotificationShowView.m
//  YuWa
//
//  Created by Tian Wei You on 16/10/21.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWLocalNotificationShowView.h"

@implementation JWLocalNotificationShowView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.showImageView.layer.cornerRadius = 5.f;
    self.showImageView.layer.masksToBounds = YES;
    self.width = kScreen_Width;
}

@end
