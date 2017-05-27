//
//  YWPCEOnTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCEOnTableViewCell.h"

@implementation YWPCEOnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setIsChoosed:(BOOL)isChoosed{
    if (_isChoosed == isChoosed)return;
    _isChoosed = isChoosed;
    [self.chooseSwich setOn:isChoosed];
}

- (IBAction)chooseSwichAction:(UISwitch *)sender {
    if (self.chooseBlock) {
        
        self.chooseBlock(sender.isOn);
    }
}


@end
