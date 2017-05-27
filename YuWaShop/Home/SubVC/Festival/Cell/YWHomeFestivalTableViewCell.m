//
//  YWHomeFestivalTableViewCell.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeFestivalTableViewCell.h"
#import "JWTools.h"

@implementation YWHomeFestivalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.BGView.layer.borderWidth = 2.f;
    self.BGView.layer.borderColor = [UIColor colorWithHexString:@"#6d6f6e"].CGColor;
    self.BGView.layer.cornerRadius = 5.f;
    self.BGView.layer.masksToBounds = YES;
    
    self.boardLabel.layer.borderWidth = 2.f;
    self.boardLabel.layer.cornerRadius = 19.f;
    self.boardLabel.layer.masksToBounds = YES;
    self.statusLabel.transform = CGAffineTransformRotate(self.statusLabel.transform, -M_1_PI);
    [self statusShow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setStatus:(NSInteger)status{
    if (_status == status) return;
    _status = status;
    [self statusShow];
}

- (void)statusShow{
    self.boardLabel.layer.borderColor = [UIColor colorWithHexString:self.status == 1?@"#3cbaea":(self.status == 2?@"#FF0000":@"#b3b3b3")].CGColor;
    self.statusLabel.textColor = [UIColor colorWithHexString:self.status == 1?@"#3cbaea":(self.status == 2?@"#FF0000":@"#b3b3b3")];
    self.statusLabel.text = self.status == 1?@"未开始":(self.status == 2?@"进行中":@"已结束");
}

- (void)setModel:(YWHomeFestivalModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}
- (void)dataSet{
    NSString * showName;
    
    int zhekou = [self.model.rebate floatValue]*10;
    NSInteger cut = zhekou;
    if (cut%10 == 0) {
        showName = cut== 100?@"全付":[NSString stringWithFormat:@"%zi折",(cut/10)];
    }else{
        NSString * str = [NSString stringWithFormat:@"%d",zhekou];
        CGFloat currCut = [str floatValue]/10;

        showName = [NSString stringWithFormat:@"%.1f折",currCut];
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 全场%@",self.model.title,showName];
    self.timeLabel.text = [NSString stringWithFormat:@"%@~%@",[JWTools dateWithYearMonthDayStr:self.model.btime],[JWTools dateWithYearMonthDayStr:self.model.etime]];;
}

@end
