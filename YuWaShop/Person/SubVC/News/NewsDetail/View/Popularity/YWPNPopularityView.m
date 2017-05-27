//
//  YWPNPopularityView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPNPopularityView.h"

@implementation YWPNPopularityView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.showImageView.layer.cornerRadius = 68.f;
    self.showImageView.layer.masksToBounds = YES;
}

@end
