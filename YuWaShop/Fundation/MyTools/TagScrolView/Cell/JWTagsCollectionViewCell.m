//
//  JWTagCollectionViewCell.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "JWTagsCollectionViewCell.h"

@implementation JWTagsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.chooseColor = CNaviColor;
    self.fontColor = [UIColor colorWithHexString:@"#333333"];
//    self.nameLabel.layer.borderColor = CNaviColor.CGColor;
//    self.nameLabel.layer.borderWidth = 1.f;
//    self.nameLabel.layer.cornerRadius = 3.f;
//    self.nameLabel.layer.masksToBounds = YES;
}

- (void)setChoosed:(BOOL)choosed{
    _choosed = choosed;
    if (_choosed) {
        self.nameLabel.textColor = self.chooseColor;
    }else{
        self.nameLabel.textColor = self.fontColor;
    }
}


@end
