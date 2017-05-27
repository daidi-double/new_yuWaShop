
//
//  YWHomeCompareOtherTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeCompareOtherTableViewCell.h"

@implementation YWHomeCompareOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.showImageView.layer.cornerRadius = 5.f;
    self.showImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWHomeCompareOtherModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}
- (void)dataSet{
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.model.company_img] placeholderImage:[UIImage imageNamed:@"YW_IMG"] completed:nil];
    self.nameLabel.text = self.model.company_name;
    NSString * countStr;
    switch (self.model.status) {
        case 0:
            countStr = [NSString stringWithFormat:@"浏览人数:%@人",[self strIsNull:self.model.log]];
            break;
        case 1:
            countStr = [NSString stringWithFormat:@"消费人数:%@人",[self strIsNull:self.model.order]];
            break;
        case 2:
            countStr = [NSString stringWithFormat:@"消费金额%@元",[self strIsNull:self.model.money]];
            break;
        case 3:
            countStr = [NSString stringWithFormat:@"总评分:%@分",[self strIsNull:self.model.star]];
            break;
            
        default:
            break;
    }
    self.countLabel.text = countStr;
}

- (NSString *)strIsNull:(NSString *)str{
    return ([str isKindOfClass:[NSNull class]]||[str isEqualToString:@"(null)"]||[str isEqualToString:@"<null>"])?@" ":str;
}

@end
