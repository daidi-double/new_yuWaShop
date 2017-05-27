//
//  YWPersonShopHeaderView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonShopHeaderView.h"
#import "JWTools.h"

@implementation YWPersonShopHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.imageCountLabBGView.layer.cornerRadius = 9.f;
    self.imageCountLabBGView.layer.masksToBounds = YES;
}
- (void)setModel:(YWPersonShopHeaderModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}
- (void)dataSet{
    CGFloat point = [self.model.score floatValue];
    NSInteger countTime = point/1;
    if (point >= 0.5f && point < 1.f) {
        UIImageView * imageView = [self viewWithTag:1];
        imageView.image = [UIImage imageNamed:@"home-hotel-star-half"];
    }else{
        for (int i = 0; i <= countTime; i++) {
            UIImageView * imageView = [self viewWithTag:(i+1)];
            if (!imageView)break;
            if (i > point-1 && i <= point - 0.5f) {
                imageView.image = [UIImage imageNamed:@"home-hotel-star-half"];
            }else if(i<countTime){
                imageView.image = [UIImage imageNamed:@"home-hotel-star-0"];
            }
        }
    }
    self.imageCountLabel.text = self.model.img_nums;
}
- (void)refreshUI{
    self.nameLabel.text = [UserSession instance].nickName;
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:nil];
    self.signatureLabel.text = [UserSession instance].personality;
}
- (void)layoutSet{
    self.imageCountBGWidth.constant = [JWTools labelWidthWithLabel:self.imageCountLabel] + 5.f;
    [self setNeedsLayout];
}

@end
