//
//  RBAlbumCollectionViewCell.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/9.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBAlbumCollectionViewCell.h"

@implementation RBAlbumCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius = 13.f;
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setModel:(RBCenterAlbumModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    self.nameLabel.text = self.model.name;
    
    [self.model.images enumerateObjectsUsingBlock:^(NSString *  _Nonnull imageStr, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx <= 3) {
            UIImageView * imageView = [self viewWithTag:idx + 1];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:nil];
        }
    }];
    if (self.model.images.count < 4) {
        for (NSInteger i = self.model.images.count; i <= 4; i++) {
            UIImageView * imageView = [self viewWithTag:i + 1];
            imageView.image = [UIImage imageNamed:@"placeholder"];
        }
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"笔记·%@ 粉丝·%@",self.model.total,self.model.fans];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.user.images] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
    
    NSMutableAttributedString * author = [NSString stringWithFirstStr:@"由" withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor colorWithHexString:@"#868686"] withSecondtStr:self.model.user.nickname withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor blackColor]];
    [author appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@"创建" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#868686"],NSFontAttributeName:[UIFont systemFontOfSize:13.f]}]];
    self.actorlabel.attributedText = author;
    
}

- (void)layoutSet{
    
    [self setNeedsLayout];
}

@end
