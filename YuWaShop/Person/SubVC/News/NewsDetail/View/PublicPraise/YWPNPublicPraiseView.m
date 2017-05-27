//
//  YWPNPublicPraiseView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPNPublicPraiseView.h"
#import "NSString+JWAppendOtherStr.h"

@implementation YWPNPublicPraiseView

- (void)awakeFromNib{
    [super awakeFromNib];
    NSMutableAttributedString * praiseStr = [NSString stringWithFirstStr:@"用户可以在新版雨娃宝给您的商户 " withFont:[UIFont systemFontOfSize:15.f] withColor:[UIColor blackColor] withSecondtStr:@"点赞" withFont:[UIFont systemFontOfSize:20.f] withColor:[UIColor blackColor]];
    [praiseStr appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@" 啦" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15.f]}]];
    self.showLabel.attributedText = praiseStr;
    
    self.showImageView.layer.cornerRadius = 68.f;
    self.showImageView.layer.masksToBounds = YES;
}

@end
