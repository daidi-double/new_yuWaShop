//
//  YWHomeRefundTableViewCell.m
//  YuWaShop
//
//  Created by TianWei You on 16/12/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeRefundTableViewCell.h"

@implementation YWHomeRefundTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rePlayBtn.layer.borderColor = CNaviColor.CGColor;
    self.rePlayBtn.layer.borderWidth = 1.f;
    self.rePlayBtn.layer.cornerRadius = 5.f;
    self.rePlayBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWHomeRefundModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}
- (void)dataSet{
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:@"2333333333"] placeholderImage:[UIImage imageNamed:@"YW_IMG"] completed:nil];
    self.nameLabel.text = [NSString stringWithFormat:@"客户昵称:%@",@"233333号客户"];
    self.phoneLabel.textColor = CsubtitleColor;
    self.phoneLabel.text = [NSString stringWithFormat:@"联系电话:%@",@"13123333333333"];
    self.timeLabel.textColor = CsubtitleColor;
    self.timeLabel.text = [NSString stringWithFormat:@"退款时间:%@",@"2333·23·22"];
    self.priceLabel.textColor = CpriceColor;
    self.priceLabel.text = [NSString stringWithFormat:@"退款金额:%@￥",@"23333333"];
}

- (void)setStatus:(NSInteger)status{
    _status = status;
    self.rePlayBtn.hidden = status != 1;
}

- (IBAction)rePlayBtnAction:(id)sender {
    self.rePlayBlock(self.model.orderID);
}

@end
