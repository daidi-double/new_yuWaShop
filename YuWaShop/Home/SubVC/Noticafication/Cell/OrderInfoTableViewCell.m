//
//  OrderInfoTableViewCell.m
//  YuWaShop
//
//  Created by double on 17/4/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "OrderInfoTableViewCell.h"

@implementation OrderInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(AllOrderModel *)model{
    _model = model;
    [self setDataUI];
}

- (void)setDataUI{
    self.customer_nameLabel.text = self.model.customer_name;
    //判断是否为手机号码，是就隐藏一部分
    if (self.model.customer_name.length >= 11 && [JWTools isNumberWithStr:self.model.customer_name]) {
        self.customer_nameLabel.text = [NSString stringWithFormat:@"%@****",[self.model.customer_name substringToIndex:self.model.customer_name.length - 4]];
    }
    self.create_timeLabel.text = [JWTools getTime:self.model.create_time];
    self.total_moneyLabel.text = [NSString stringWithFormat:@"￥%@",self.model.total_money];
    self.orderStatusLabel.text = self.model.order_type;
}



@end
