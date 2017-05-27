//
//  RBNodeBGView.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/9.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeBGView.h"

@implementation RBNodeBGView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.publishBtn.layer.cornerRadius = 5.f;
    self.publishBtn.layer.borderColor = [UIColor colorWithHexString:@"#B82E34"].CGColor;
    self.publishBtn.layer.borderWidth = 1.f;
    self.publishBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(publishAction)];
    [self addGestureRecognizer:tap];
    
    self.isNode = YES;
}

- (void)setIsNode:(BOOL)isNode{
    _isNode = isNode;
    self.nodeBGView.hidden = !isNode;
    self.aldumBGView.hidden = isNode;
}

- (void)publishAction{
    self.publishBlock();
}

@end
