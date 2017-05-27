//
//  YWPCChooseTimeModel.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCChooseTimeModel.h"

@implementation YWPCChooseTimeModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.payDays = @"";
        self.payTimeArr = [NSMutableArray arrayWithCapacity:0];
        [self.payTimeArr addObject:[[YWPCChooseSubTimeModel alloc]init]];
    }
    return self;
}

- (void)setIsPayAllDay:(BOOL)isPayAllDay{
    if (_isPayAllDay == isPayAllDay)return;
    _isPayAllDay = isPayAllDay;
    if (!_isPayAllDay) {
        [self.payTimeArr removeAllObjects];
        [self.payTimeArr addObject:[[YWPCChooseSubTimeModel alloc]init]];
    }else{
        [self.payTimeArr removeAllObjects];
        YWPCChooseSubTimeModel * model = [[YWPCChooseSubTimeModel alloc]init];
        model.name = @"24小时营业";
        model.time = @"00:00-24:00";
        [self.payTimeArr addObject:model];
    }
}

@end
