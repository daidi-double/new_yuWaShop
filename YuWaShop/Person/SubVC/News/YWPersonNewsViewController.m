//
//  YWPersonNewsViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonNewsViewController.h"
#import "YWBasicTableViewCell.h"
#import "YWPersonNewsModel.h"
#import "YWPersonNewsDetailViewController.h"

@interface YWPersonNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation YWPersonNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"经营日报";
    [self dataSet];
    [self requestData];
}
- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YWBasicTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWBasicTableViewCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWBasicTableViewCell * newsCell = [tableView dequeueReusableCellWithIdentifier:@"YWBasicTableViewCell"];
    YWPersonNewsModel * model = self.dataArr[indexPath.row];
    newsCell.nameLabel.text = model.newsTime;
    return newsCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YWPersonNewsModel * model = self.dataArr[indexPath.row];
    YWPersonNewsDetailViewController * vc = [[YWPersonNewsDetailViewController alloc]init];
    vc.newsTime = model.newsTime;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Http
- (void)requestData{
    NSInteger timeCount = [[JWTools dateWithTodayYearMonthDayNumberStr] integerValue];
    NSInteger regCount = [[UserSession instance].reg_time integerValue] + 86400*7;
    for (int i = 0; i<7; i++) {
        timeCount -= 86400;
        if (timeCount<regCount)break;
        YWPersonNewsModel * model = [[YWPersonNewsModel alloc]init];
        model.newsTime = [JWTools dateWithYearMonthDayStr:[NSString stringWithFormat:@"%zi",timeCount]];
        [self.dataArr addObject:model];
    }
    if (self.dataArr.count<=0){
        [self showHUDWithStr:@"经营时间一周后才有日报哟" withSuccess:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    [self.tableView reloadData];
}

@end
