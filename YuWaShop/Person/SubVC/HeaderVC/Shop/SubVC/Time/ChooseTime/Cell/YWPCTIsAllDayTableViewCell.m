//
//  YWPCTIsAllDayTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCTIsAllDayTableViewCell.h"

@implementation YWPCTIsAllDayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIsPayAllDay:(BOOL)isPayAllDay{
    if (_isPayAllDay == isPayAllDay)return;
    _isPayAllDay = isPayAllDay;
    [self.allDaySwich setOn:_isPayAllDay];
    self.payAllDayBlock(isPayAllDay);
}

- (IBAction)payAllDaySwichAction:(UISwitch *)sender {
    _isPayAllDay = sender.isOn;
    self.payAllDayBlock(sender.isOn);
}


@end
