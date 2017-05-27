//
//  YWHomeQuickPayListVC.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeQuickPayListVC.h"
#import "YWHomeQuickPayListTableViewCell.h"
#import "YWOderDetaleViewController.h"
@interface YWHomeQuickPayListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YWHomeQuickPayListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"闪付记录";
    [self dataSet];
    [self setupRefresh];
    [self requestDataWithPages:0];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        self.navigationController.navigationBarHidden = NO;
}
- (void)dataSet{
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YWHomeQuickPayListTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWHomeQuickPayListTableViewCell"];
    self.tableView.backgroundColor = RGBCOLOR(233, 238, 241, 1);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YWHomeQuickPayListModel*model = self.dataArr[indexPath.row];
    YWOderDetaleViewController * vc = [[YWOderDetaleViewController alloc]init];
    vc.status = 1;
    vc.orderID = model.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWHomeQuickPayListTableViewCell * listCell = [tableView dequeueReusableCellWithIdentifier:@"YWHomeQuickPayListTableViewCell"];

    listCell.model = self.dataArr[indexPath.row];
    return listCell;
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestDataWithPages:0];
}
- (void)footerRereshing{
    self.pages++;
    [self requestDataWithPages:self.pages];
}
- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Http
- (void)requestDataWithPages:(NSInteger)page{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":@([self.pagens integerValue]),@"pages":@(page)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_RecordLists withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is responsObj=%@",responsObj);
        if (page == 0)[self.dataArr removeAllObjects];
        //233333333要删
        for (int i = 0; i<[responsObj[@"data"] count]; i++) {
            YWHomeQuickPayListModel*model=[YWHomeQuickPayListModel yy_modelWithDictionary:responsObj[@"data"][i]];
            [self.dataArr addObject:model];
        }
//        233333333要删
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }]; //h33333333333333
}

@end
