//
//  MDHotelChooseTypeTableVC.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelChooseTypeTableVC.h"

@interface MDHotelChooseTypeTableVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)NSArray * dataArr;

@end

@implementation MDHotelChooseTypeTableVC

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataArr = @[@"综合排序",@"时间排序",@"热度排序"];
        self.frame = CGRectMake(0.f, 64.f + 30.f, kScreen_Width, 30.f * self.dataArr.count);
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.row;
    self.choosedTypeBlock([NSString stringWithFormat:@"%zi",self.selectIndex],self.dataArr[indexPath.row]);
    [self removeFromSuperview];
    [self reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.f;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * typeCell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    if (!typeCell) {
        typeCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCel"];
    }
    typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == self.selectIndex) {
        typeCell.accessoryType = UITableViewCellAccessoryCheckmark;
        typeCell.tintColor = CNaviColor;
        typeCell.textLabel.textColor = CNaviColor;
    }else{
        typeCell.accessoryType = UITableViewCellAccessoryNone;
        typeCell.textLabel.textColor = CsubtitleColor;
    }
    typeCell.textLabel.text = self.dataArr[indexPath.row];
    typeCell.textLabel.font = [UIFont systemFontOfSize:15.f];
    typeCell.backgroundColor = [UIColor colorWithHexString:@"#F5F8FA"];
    if (![typeCell viewWithTag:10086]) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 29.f, kScreen_Width, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        lineView.tag = 10086;
        [typeCell addSubview:lineView];
    }
    typeCell.alpha = 1.f;
    return typeCell;
}

@end
