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
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"￥%@",self.model.total_money];
    self.orderSNStrLabel.text = self.model.order_sn;
    self.orderStatusStrLabel.text = self.model.order_type;
    self.timerLabel.text = [JWTools getTime:self.model.create_time];
    
}

@end
