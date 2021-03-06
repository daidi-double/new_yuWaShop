//
//  YWHomeQuickPayListTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeQuickPayListTableViewCell.h"
#import "JWTools.h"

@implementation YWHomeQuickPayListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.orderSNLabel.textColor = LIGHTCOLOR;
    self.orderSNStrLabel.textColor = LIGHTCOLOR;
    self.orderStatusStrLabel.textColor = LIGHTCOLOR;
    self.timerLabel.textColor = LIGHTCOLOR;
    self.creatTimeLabel.textColor = LIGHTCOLOR;
    self.oderStatusLabel.textColor = LIGHTCOLOR;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWHomeQuickPayListModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}
- (void)dataSet{
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%.4f",[self.model.total_money floatValue]];
    self.orderSNStrLabel.text = self.model.order_sn;
    self.orderStatusStrLabel.text = self.model.order_type;
    self.timerLabel.text = [JWTools getTime:self.model.create_time];
    
}

@end
