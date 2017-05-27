//
//  YWHomeCommoditiesTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeCommoditiesTableViewCell.h"

@implementation YWHomeCommoditiesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWHomeCommoditiesModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}
- (void)dataSet{
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.goods_img] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:nil];
    self.nameLabel.text = self.model.goods_name;
    self.conLabel.text = self.model.goods_info;
    
//    NSString * priceStr = [self.model.goods_price stringByReplacingOccurrencesOfString:@".00" withString:@""];
//    priceStr = [priceStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.goods_price];
}

@end
