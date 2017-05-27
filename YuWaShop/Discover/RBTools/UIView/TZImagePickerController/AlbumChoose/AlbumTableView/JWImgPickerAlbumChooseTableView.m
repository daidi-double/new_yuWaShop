//
//  JWImgPickerAlbumChooseTableView.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/20.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWImgPickerAlbumChooseTableView.h"

#import "JWImagePickerTableViewCell.h"

#define IMGPICKERCELL @"JWImagePickerCell"
@interface JWImgPickerAlbumChooseTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)NSInteger selectIndex;
@end

@implementation JWImgPickerAlbumChooseTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.frame = CGRectMake(0.f, 44.f, kScreen_Width, 240.f);
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    if (!dataArr)return;
    _dataArr = dataArr;
    [self reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.row;
    TZAlbumModel * model = self.dataArr[indexPath.row];
    self.choosedTypeBlock([NSString stringWithFormat:@"%zi",self.selectIndex],model.name);
    [self removeFromSuperview];
    [self reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr?self.dataArr.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JWImagePickerTableViewCell * typeCell = [tableView dequeueReusableCellWithIdentifier:IMGPICKERCELL];
    if (!typeCell) {
        [tableView registerNib:[UINib nibWithNibName:IMGPICKERCELL bundle:nil] forCellReuseIdentifier:IMGPICKERCELL];
        typeCell = [tableView dequeueReusableCellWithIdentifier:IMGPICKERCELL];
    }
    typeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    typeCell.backgroundColor = [UIColor colorWithHexString:(indexPath.row == self.selectIndex)?@"#d9d9d9":@"#ffffff"];
    typeCell.model = self.dataArr[indexPath.row];
    typeCell.alpha = 1.f;
    return typeCell;
}

@end
