//
//  YWMessageAddressBookTableViewCell.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageAddressBookTableViewCell.h"

@implementation YWMessageAddressBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconImageView.layer.cornerRadius = 17.f;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.countLabel.layer.cornerRadius = 8.f;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.countLabel.layer.borderWidth = 1.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YWMessageAddressBookModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    if ([self.model.friend_remark isEqualToString:@""]) {
        
        self.nameLabel.text = self.model.nikeName;
    }else{
        self.nameLabel.text = self.model.friend_remark;
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.header_img] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
}

@end
