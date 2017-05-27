//
//  YWPCESelTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCESelTableViewCell.h"

@implementation YWPCESelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsChoosed:(BOOL)isChoosed{
    if (_isChoosed == isChoosed)return;
    _isChoosed = isChoosed;
    self.chooseImageView.image = [UIImage imageNamed:isChoosed?@"photo_sel_photoPickerVc":@"photo_def_previewVc"];
}

@end
