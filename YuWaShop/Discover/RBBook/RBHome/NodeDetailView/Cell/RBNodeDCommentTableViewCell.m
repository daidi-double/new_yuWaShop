//
//  RBNodeDCommentTableViewCell.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeDCommentTableViewCell.h"
#import "JWTools.h"
#import "NSString+JWAppendOtherStr.h"

@implementation RBNodeDCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius = 16.f;
    self.iconImageView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(RBNodeShowCommentModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.user.images] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
    self.nameLabel.text = self.model.user.nickname;
    //判断是否为手机号码，是就隐藏一部分
    if (self.model.user.nickname.length == 11 && [JWTools isNumberWithStr:self.model.user.nickname]) {
        NSString * number = [self.model.user.nickname substringToIndex:7];
        self.nameLabel.text = [NSString stringWithFormat:@"%@****",number];
    }
    if (self.model.target_comment.user.nickname) {
        NSMutableAttributedString * con = [NSString stringWithFirstStr:@"回复" withFont:self.conLabel.font withColor:self.conLabel.textColor withSecondtStr:self.model.target_comment.user.nickname withFont:self.conLabel.font withColor:[UIColor lightGrayColor]];
        [con appendAttributedString:[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@":%@",self.model.content] attributes:@{NSForegroundColorAttributeName:self.conLabel.textColor,NSFontAttributeName:self.conLabel.font}]];
        self.conLabel.attributedText = con;
    }else{
        self.conLabel.text = self.model.content;
    }
    
    self.timeLabel.text = [JWTools dateWithStr:self.model.time];
}

- (void)layoutSet{
    self.conLabelHeight.constant = [JWTools labelHeightWithLabel:self.conLabel withWidth:(kScreen_Width - 66.f)];
    [self setNeedsLayout];
}


@end
