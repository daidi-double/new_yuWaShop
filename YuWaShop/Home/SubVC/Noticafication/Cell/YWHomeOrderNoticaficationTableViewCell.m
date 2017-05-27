//
//  YWHomeOrderNoticaficationTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/1.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeOrderNoticaficationTableViewCell.h"
#import "JWTools.h"

@implementation YWHomeOrderNoticaficationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rePlayBtn.layer.borderColor = CNaviColor.CGColor;
    self.rePlayBtn.layer.borderWidth = 1.f;
    self.rePlayBtn.layer.cornerRadius = 5.f;
    self.rePlayBtn.layer.masksToBounds = YES;
    
    self.BGView.layer.borderColor = [UIColor colorWithHexString:@"#9b9b9b"].CGColor;
    self.BGView.layer.borderWidth = 2.f;
    self.BGView.layer.cornerRadius = 5.f;
    self.BGView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWHomeNoPayListModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}
- (void)dataSet{
    [self.rePlayBtn setTitleColor:[UIColor colorWithHexString:@"#25C0E9"] forState:UIControlStateNormal];
    self.rePlayBtn.layer.borderColor = [UIColor colorWithHexString:@"#25C0E9"].CGColor;
    [self.rePlayBtn setTitle:@"回复" forState:UIControlStateNormal];
    [self.rePlayBtn setUserInteractionEnabled:YES];
    
    self.phoneLabel.text = [NSString stringWithFormat:@"%@ (%@%@)",(self.model.reserve.customer_phone?self.model.reserve.customer_phone:@"匿名"),(self.model.reserve.customer_name?self.model.reserve.customer_name:@""),([self.model.reserve.customer_sex isEqualToString:@"1"]?@"先生":@"女士")];
    self.timeLabel.text = [self.model.reserve.ctime integerValue]>0?[JWTools dateWithStr:self.model.reserve.ctime]:@"不详";
    self.nmberLabel.text = [NSString stringWithFormat:@"%zi人",[self.model.reserve.customer_num integerValue]];
    self.rePlayLabel.text = ([self.model.reserve.customer_message isEqualToString:@""]||!self.model.reserve.customer_message)?@"无留言":self.model.reserve.customer_message;
}

- (IBAction)rePlayBtnAction:(id)sender {
    self.rePlayBlock();
}

@end
