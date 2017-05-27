//
//  YWHomeRefundVC.m
//  YuWaShop
//
//  Created by TianWei You on 16/12/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeRefundVC.h"
#import "YWHomeRefundTableViewCell.h"
#import "NSDictionary+Attributes.h"

@interface YWHomeRefundVC ()

<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UISegmentedControl * typeSegmentView;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation YWHomeRefundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款管理";
    [self makeUI];
    [self dataSet];
    [self setupRefresh];
    [self requestDataWithPages:0];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden= NO;
}
- (void)makeUI{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 50.f)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.typeSegmentView = [[UISegmentedControl alloc]initWithItems:@[@"待处理",@"已同意"]];
    self.typeSegmentView.frame = CGRectMake(20.f, 10.f, kScreen_Width - 40.f, 30.f);
    self.typeSegmentView.selectedSegmentIndex = 0;
    [self.typeSegmentView setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor colorWithHexString:@"#3c8cd9"]] forState:UIControlStateNormal];
    [self.typeSegmentView setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    self.typeSegmentView.tintColor = CNaviColor;
    self.typeSegmentView.layer.borderColor = CNaviColor.CGColor;
    [self.typeSegmentView setDividerImage:[UIImage imageNamed:@"segmentLine"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.typeSegmentView.layer.borderWidth = 2.f;
    self.typeSegmentView.layer.cornerRadius = 5.f;
    self.typeSegmentView.layer.masksToBounds = YES;
    [self.typeSegmentView addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.headerView addSubview:self.typeSegmentView];
}

- (void)dataSet{
    self.status = 1;
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YWHomeRefundTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWHomeRefundTableViewCell"];
}

- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.status = sender.selectedSegmentIndex+1;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWHomeRefundTableViewCell * reFundOrderCell = [tableView dequeueReusableCellWithIdentifier:@"YWHomeRefundTableViewCell"];
    reFundOrderCell.status = self.status;
    reFundOrderCell.model = self.dataArr[indexPath.row];
    if (self.status <= 1) {
        reFundOrderCell.rePlayBlock = ^(NSString * orderID){
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"Hello Boss" message:@"确认同意退款吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestAgreeOrderWithIndexPath:indexPath withID:orderID];
            }];
            
            UIAlertAction * delAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:delAction];
            [alertVC addAction:OKAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        };
    }
    return reFundOrderCell;
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
    
    //23333333333333333333
    if (page == 0)[self.dataArr removeAllObjects];
//    for (int i = 0; i<3; i++) {
//        //233333333
//        YWHomeRefundModel * model =[[YWHomeRefundModel alloc]init];
//        model.orderID = @"1";
//        [self.dataArr addObject:model];
//    }
    //23333333333333333333
    
    
//    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":@(self.status),@"pagen":@([self.pagens integerValue]),@"pages":@(page)};
    
//    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_BookLists withPragram:pragram success:^(id responsObj) {
//        MyLog(@"Regieter Code pragram is %@",pragram);
//        MyLog(@"Regieter Code is %@",responsObj);
//        if (page == 0)[self.dataArr removeAllObjects];
//        NSArray * dataArr = responsObj[@"data"];
//        for (int i = 0; i<dataArr.count; i++) {
//            YWHomeAdvanceOrderModel * model =[YWHomeAdvanceOrderModel yy_modelWithDictionary:dataArr[i]];
//            model.customer_time = [model.customer_time integerValue]>0?model.customer_time:[JWTools dateWithTodayYearMonthDayNumberStr];
//            [self.dataArr addObject:model];
//        }
        [self.tableView reloadData];
//    } failur:^(id responsObj, NSError *error) {
//        MyLog(@"Regieter Code pragram is %@",pragram);
//        MyLog(@"Regieter Code error is %@",responsObj);
//    }];
}
- (void)requestAgreeOrderWithIndexPath:(NSIndexPath *)indexPath withID:(NSString *)orderID{
    //    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":@([model.orderID integerValue]),@"seller_message":rePlay,@"status":@(type),@"push_title":[NSString stringWithFormat:@"%@的订单%@",[UserSession instance].nickName,(type==2?@"预定成功":@"已被取消")],@"push_content":rePlay};
    
//    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_BookReply withPragram:pragram success:^(id responsObj) {
//        MyLog(@"Regieter Code pragram is %@",pragram);
//        MyLog(@"Regieter Code is %@",responsObj);
        [self.dataArr removeObjectAtIndex:indexPath.row];
//        [self showHUDWithStr:@"回复成功" withSuccess:YES];
        [self.tableView reloadData];
//    } failur:^(id responsObj, NSError *error) {
//        MyLog(@"Regieter Code pragram is %@",pragram);
//        MyLog(@"Regieter Code error is %@",responsObj);
//    }];
}



@end
