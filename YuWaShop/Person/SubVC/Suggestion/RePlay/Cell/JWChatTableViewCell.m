//
//  JWChatTableViewCell.m
//  JWQQChat
//
//  Created by scjy on 16/4/17.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import "JWChatTableViewCell.h"
#import "JWTools.h"

@implementation JWChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconImageView.layer.cornerRadius = 25.f;
    self.iconImageView.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(YWPSRePlayModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
    [self layoutSet];
}

- (void)dataSet{
    self.timeLabel.text = [JWTools dateWithStr:self.model.ctime];
    if (self.model.status==1) {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"YW_IMG"] completed:nil];
    }
    [self.contentButton setBackgroundImage:[[UIImage imageNamed:self.model.status == 1?@"chat_send_nor":@"chat_recive_press_pic"] resizableImageWithImage] forState:UIControlStateNormal];
    self.nameLabel.text = self.model.status==0?@"雨娃开店宝":[UserSession instance].nickName;
    self.nameLabel.textAlignment = self.model.status==0?NSTextAlignmentLeft:NSTextAlignmentRight;
}

- (void)layoutSet{
    [self contentBtnSize];
    if (self.model.status == 1) {
        self.iconImageViewLeftEndge.constant = kScreen_Width - 64.f;
        self.buttonLeftEndge.constant = kScreen_Width - 66.f - self.buttonWidth.constant;
    }
    [self setNeedsLayout];
}

- (void)contentBtnSize{
    self.contentButton.titleEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.contentButton setTitle:self.model.customer_content forState:UIControlStateNormal];
    
    NSDictionary * attributes = @{NSFontAttributeName:self.contentButton.titleLabel.font};
    
    CGRect rect = [self.model.customer_content boundingRectWithSize:CGSizeMake(kScreen_Width - 182.f, kScreen_Height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    self.buttonWidth.constant = rect.size.width + 50.f;
    self.buttonHeight.constant = rect.size.height + 20.f;
}


@end
