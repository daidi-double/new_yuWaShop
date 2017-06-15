//
//  ChildAccountTableViewCell.m
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChildAccountTableViewCell.h"

@implementation ChildAccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    self.accountLabel.textColor = [UIColor colorWithHexString:@"#999999"];
}
- (void)setChildModel:(ChildModel *)childModel{
    _childModel = childModel;
    [self setData];
}

-(void)setData{
    
    self.shopNameLabel.text = self.childModel.company_name;
    self.accountLabel.text = self.childModel.username;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
