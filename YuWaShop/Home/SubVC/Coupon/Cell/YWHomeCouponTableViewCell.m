//
//  YWHomeCouponTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeCouponTableViewCell.h"
#import "JWTools.h"

@implementation YWHomeCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWHomeCouponModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}
- (void)dataSet{
    NSString * cutNumberStr = [self.model.discount_fee stringByReplacingOccurrencesOfString:@".00" withString:@""];
    cutNumberStr = [cutNumberStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    self.cutNumberLabel.text = [NSString stringWithFormat:@"￥%@",cutNumberStr];
    NSString * conditionStr = [self.model.min_fee stringByReplacingOccurrencesOfString:@".00" withString:@""];
    conditionStr = [conditionStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    self.conditionLabel.text = [NSString stringWithFormat:@"满%@减",conditionStr];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",self.model.name];
    self.timeLabel.text = [NSString stringWithFormat:@"%@至%@",[JWTools dateWithYearMonthDayStr:self.model.begin_time],[JWTools dateWithYearMonthDayStr:self.model.end_time]];
}

@end
