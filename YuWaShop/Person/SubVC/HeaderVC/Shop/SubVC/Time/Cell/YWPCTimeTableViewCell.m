//
//  YWPCTimeTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCTimeTableViewCell.h"

@implementation YWPCTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWPCTimeModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.timeLabel.text = [NSString stringWithFormat:@"%@  %@",self.model.time,self.model.name];
    self.subTimeLabel.text = self.model.payDays;
}


@end
