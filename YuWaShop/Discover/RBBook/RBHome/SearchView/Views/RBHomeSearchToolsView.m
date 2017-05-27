//
//  RBHomeSearchToolsView.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/18.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBHomeSearchToolsView.h"

@implementation RBHomeSearchToolsView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
}

- (IBAction)typeBtnAction:(id)sender {
    //只有笔记所以暂时不可选
    self.typeChooseBlock(0);
}

- (void)setSearchKey:(NSString *)searchKey{
    if (!searchKey)return;
    _searchKey = searchKey;
    [self makeSearchKeyView];
}

- (void)makeSearchKeyView{
    self.textField.placeholder = @"";
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f]};
    CGRect conRect = [self.searchKey boundingRectWithSize:CGSizeMake(MAXFLOAT,20.f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    UILabel * searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.typeBtn.width + 5.f, 4.f, conRect.size.width + 10.f, 22.f)];
    searchLabel.backgroundColor = CNaviColor;
    searchLabel.textAlignment = NSTextAlignmentCenter;
    searchLabel.textColor = [UIColor whiteColor];
    searchLabel.text = self.searchKey;
    searchLabel.font = [UIFont systemFontOfSize:14.f];
    searchLabel.layer.cornerRadius = 3.f;
    searchLabel.layer.masksToBounds = YES;
    [self addSubview:searchLabel];
}

@end
