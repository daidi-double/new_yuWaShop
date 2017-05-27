//
//  YWHomeCompareSortTableView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeCompareSortTableView.h"

@implementation YWHomeCompareSortTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    if (!dataArr)return;
    if (!_dataArr) {
        _dataArr = dataArr;
        return;
    }
    _dataArr = dataArr;
    [self reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex != indexPath.row){
        self.selectIndex = indexPath.row;
        self.choosedTypeBlock(self.selectIndex);
    }
    self.hidden = YES;
    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * typeCompareCell = [tableView dequeueReusableCellWithIdentifier:@"typeCompareCell"];
    if (!typeCompareCell) {
        typeCompareCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCompareCell"];
    }
    typeCompareCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.selectIndex) {
        typeCompareCell.tintColor = CNaviColor;
        typeCompareCell.textLabel.textColor = CNaviColor;
        typeCompareCell.backgroundColor = [UIColor colorWithHexString:@"#F5F8FA"];
    }else{
        typeCompareCell.textLabel.textColor = CsubtitleColor;
        typeCompareCell.backgroundColor = [UIColor whiteColor];
    }
    typeCompareCell.textLabel.text = self.dataArr[indexPath.row];
    typeCompareCell.textLabel.textAlignment = NSTextAlignmentCenter;
    typeCompareCell.textLabel.font = [UIFont systemFontOfSize:15.f];
    
    if (![typeCompareCell viewWithTag:10086]) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 43.f, kScreen_Width, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        lineView.tag = 10086;
        [typeCompareCell addSubview:lineView];
    }
    typeCompareCell.alpha = 1.f;
    return typeCompareCell;
}

@end
