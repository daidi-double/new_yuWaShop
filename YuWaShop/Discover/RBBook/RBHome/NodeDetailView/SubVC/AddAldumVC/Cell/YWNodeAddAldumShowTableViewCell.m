//
//  YWNodeAddAldumShowTableViewCell.m
//  YuWa
//
//  Created by Tian Wei You on 16/10/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWNodeAddAldumShowTableViewCell.h"

@implementation YWNodeAddAldumShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showPublicAction:(UISwitch *)sender {
    self.showPublicBlock(sender.isOn);
}

@end
