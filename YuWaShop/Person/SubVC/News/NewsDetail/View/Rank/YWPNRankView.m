//
//  YWPNRankView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPNRankView.h"

@implementation YWPNRankView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.showImageView.layer.cornerRadius = 80.f;
    self.showImageView.layer.masksToBounds = YES;
}

@end
