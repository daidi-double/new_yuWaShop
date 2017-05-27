//
//  YWMessageNotificationCell.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageNotificationCell.h"

#import "JWTools.h"
@implementation YWMessageNotificationCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImageView.layer.cornerRadius = 25.f;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(YWMessageNotificationModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.timeLbael.text = [JWTools dateWithOutYearStr:self.model.ctime];
    self.nameLabel.text = self.model.title;
    self.conLabel.text = self.model.content;
    self.iconImageView.image = [UIImage imageNamed:[self.model.status isEqualToString:@"0"]?@"message_Notification_Order":@"message_Notification_Pay"];
}

@end
