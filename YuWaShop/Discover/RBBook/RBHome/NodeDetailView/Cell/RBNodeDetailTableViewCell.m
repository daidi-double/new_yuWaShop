//
//  RBNodeDetailTableViewCell.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeDetailTableViewCell.h"
#import "JWTools.h"

@implementation RBNodeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(RBNodeShowModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    self.nameLabel.text = [self.model.title stringByRemovingPercentEncoding];
    self.conLabel.text = self.model.desc;
    self.timeLabel.text = [JWTools dateWithStr:self.model.time];
    self.collectionLabel.text = [NSString stringWithFormat:@"%@次收藏",self.model.fav_count];
    self.likeLabel.text = [NSString stringWithFormat:@"%@次赞",self.model.likes];
}

- (void)layoutSet{
    self.nameLabelHeight.constant = [JWTools labelHeightWithLabel:self.nameLabel withWidth:kScreen_Width - 30.f] + 32.f;
    self.conLabelHeight.constant = [JWTools labelHeightWithLabel:self.conLabel withWidth:kScreen_Width - 30.f];
    [self setNeedsLayout];
}

- (void)refreshCollectionCountWithAdd:(BOOL)isAdd{
    self.model.likes = [NSString stringWithFormat:@"%zi",[self.model.fav_count integerValue] + isAdd==YES?1:-1];
    self.collectionLabel.text = [NSString stringWithFormat:@"%@次收藏",self.model.fav_count];
}

- (void)refreshLikesCountWithAdd:(BOOL)isAdd{
    self.model.fav_count = [NSString stringWithFormat:@"%zi",[self.model.likes integerValue] + isAdd==YES?1:-1];
    self.likeLabel.text = [NSString stringWithFormat:@"%@次赞",self.model.likes];
}

@end
