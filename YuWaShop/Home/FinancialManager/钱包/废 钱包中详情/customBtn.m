//
//  customBtn.m
//  YuWa
//
//  Created by double on 17/3/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "customBtn.h"

@implementation customBtn

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLbl];
        [self addSubview:self.downImageView];
    }
    return self;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width/2, 44)];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = [UIFont systemFontOfSize:17];
        _titleLbl.textAlignment = 1;
        _titleLbl.text = @"直接介绍分红";
        CGRect shopNameWidth = [_titleLbl.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 44) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: _titleLbl.font} context:nil];
        _titleLbl.frame= CGRectMake(0, 0, shopNameWidth.size.width , 44);
//        _titleLbl.centerY = 12.5;
        _titleLbl.centerX = self.width/2-10;
        
    }
    return _titleLbl;
}
- (UIImageView*)downImageView{
    if (!_downImageView) {
        _downImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 0, 10, 10)];
        
        _downImageView.centerX = self.titleLbl.width + self.titleLbl.x+10;
        _downImageView.centerY = self.height/2;
    }
    return _downImageView;
}
@end
