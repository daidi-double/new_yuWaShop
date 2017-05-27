//
//  YWHomeAdvanceOrderTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/1.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeAdvanceOrderTableViewCell.h"
#import "JWTools.h"

@implementation YWHomeAdvanceOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rePlayBtn.layer.borderColor = CNaviColor.CGColor;
    self.rePlayBtn.layer.borderWidth = 1.f;
    self.rePlayBtn.layer.cornerRadius = 5.f;
    self.rePlayBtn.layer.masksToBounds = YES;
    
    self.rejectBtn.layer.borderColor = CNaviColor.CGColor;
    self.rejectBtn.layer.borderWidth = 1.f;
    self.rejectBtn.layer.cornerRadius = 5.f;
    self.rejectBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWHomeAdvanceOrderModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}
- (void)dataSet{
    self.phoneLabel.text = [NSString stringWithFormat:@"%@  %@",self.model.customer_phone,self.model.customer_name];
    self.timeLabel.text = [JWTools dateWithStr:self.model.customer_time];
    self.nmberLabel.text = [NSString stringWithFormat:@"%@人",self.model.customer_num];
    self.rePlayLabel.text = self.model.customer_message;
    if (self.status != 1) {
        self.myRePlayLabel.text = [self.model.seller_message isEqualToString:@""]?@"已回复":self.model.seller_message;
    }
}

- (void)setStatus:(NSInteger)status{
    _status = status;
    self.rePlayBtn.hidden = status != 1;
    self.rejectBtn.hidden = status != 1;
}

- (void)layoutSet{
    if (self.status == 1) {
        self.replayLabelHeight.constant = 0.f;
        self.customReplayHeight.constant = 44.f;
    }else{
        self.replayLabelHeight.constant = 38.f;
        self.customReplayHeight.constant = 20.f;
    }
    [self setNeedsLayout];
}

- (IBAction)rePlayBtnAction:(id)sender {
    self.rePlayBlock();
}
- (IBAction)rejectBtnAction:(UIButton *)sender {
    self.rejectBlock();
}

@end
