//
//  ChildAccountShopTableViewCell.m
//  雨掌柜
//
//  Created by double on 17/6/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChildAccountShopTableViewCell.h"

@implementation ChildAccountShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accountNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.isCurrentAccountLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.managerLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.addLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.addLabel.hidden = YES;
    self.addImageView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
