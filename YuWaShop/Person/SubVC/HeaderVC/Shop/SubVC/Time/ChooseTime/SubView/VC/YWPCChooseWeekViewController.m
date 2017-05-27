//
//  YWPCChooseWeekViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCChooseWeekViewController.h"
#import "YWPCChooseWeekTableViewCell.h"

@interface YWPCChooseWeekViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic,strong)NSMutableArray * chooseArr;

@end

@implementation YWPCChooseWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self dataSet];
}

- (void)makeNavi{
    self.title = @"添加每周营业日";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"保存" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside withWidth:33.f];
}

- (void)dataSet{
    self.dataArr = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    self.chooseArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWPCChooseWeekTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWPCChooseWeekTableViewCell"];
}

- (void)saveInfo{
    if (self.chooseArr.count <= 0) {
        [self showHUDWithStr:@"请选择每周营业日" withSuccess:NO];
        return;
    }else{
        NSMutableArray * chooseArrTemp = [NSMutableArray arrayWithArray:[self.chooseArr mutableCopy]];
        [self.chooseArr removeAllObjects];
        for (NSString * str in self.dataArr) {
            NSString * choosedStr;
            for (int i = 0; i<chooseArrTemp.count; i++) {
                if ([str isEqualToString:chooseArrTemp[i]]) {
                    choosedStr = str;
                    break;
                }
            }
            if (choosedStr) {
                [self.chooseArr addObject:choosedStr];
                [chooseArrTemp removeObject:choosedStr];
            }
        }
        self.saveWeekInfoBlock(self.chooseArr);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YWPCChooseWeekTableViewCell * weekCell = [tableView cellForRowAtIndexPath:indexPath];
    weekCell.isChoosed = !weekCell.isChoosed;
    if (weekCell.isChoosed) {
        [self.chooseArr addObject:self.dataArr[indexPath.row]];
    }else{
        [self.chooseArr removeObject:self.dataArr[indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWPCChooseWeekTableViewCell * weekCell = [tableView dequeueReusableCellWithIdentifier:@"YWPCChooseWeekTableViewCell"];
    weekCell.nameLabel.text = self.dataArr[indexPath.row];
    return weekCell;
}

@end
