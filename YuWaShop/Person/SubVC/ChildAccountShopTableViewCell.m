//
//  ChildAccountShopTableViewCell.m
//  雨掌柜
//
//  Created by double on 17/6/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChildAccountShopTableViewCell.h"
#import "NSString+JWAppendOtherStr.h"


@implementation ChildAccountShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accountNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.managerLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.addLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.addLabel.hidden = YES;
    self.addImageView.hidden = YES;
}
- (void)setModel:(MainAccountListModel *)model{
    _model = model;
    [self setData];
}
- (void)setData{
    self.accountNameLabel.text = self.model.company_name;
    if ([self.model.is_current isEqualToString:@"1"]) {

        self.accountNameLabel.attributedText = [NSString stringWithFirstStr:[NSString stringWithFormat:@"%@",self.model.company_name] withFont:[UIFont systemFontOfSize:12] withColor:[UIColor colorWithHexString:@"#333333"] withSecondtStr:@"(当前账号)" withFont:[UIFont systemFontOfSize:12] withColor:[UIColor colorWithHexString:@"#999999"]];
    }
    if ([self.model.isChild integerValue] == 0) {
        
        self.managerLabel.text = [NSString stringWithFormat:@"管理员账号:%@",self.model.username];
    }else{
       self.managerLabel.text = [NSString stringWithFormat:@"门店账号:%@",self.model.username];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
