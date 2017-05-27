//
//  YWHomeAdvanceOrderViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/1.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeAdvanceOrderViewController.h"
#import "YWHomeAdvanceOrderTableViewCell.h"
#import "NSDictionary+Attributes.h"

@interface YWHomeAdvanceOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UISegmentedControl * typeSegmentView;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)UIAlertController * alertVC;
@property (nonatomic,strong)UITapGestureRecognizer * tap;

@end

@implementation YWHomeAdvanceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约订单";
    [self makeUI];
    [self dataSet];
    [self setupRefresh];
    [self requestDataWithPages:0];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden= NO;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:self.tap];
}

- (void)makeUI{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 50.f)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.typeSegmentView = [[UISegmentedControl alloc]initWithItems:@[@"待处理",@"已接受",@"已取消"]];
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
    
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:self.tap];
}

- (void)dataSet{
    self.status = 1;
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YWHomeAdvanceOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWHomeAdvanceOrderTableViewCell"];
}

- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.status = sender.selectedSegmentIndex+1;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.status == 1?155.f:177.f;
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
    YWHomeAdvanceOrderTableViewCell * advanceOrderCell = [tableView dequeueReusableCellWithIdentifier:@"YWHomeAdvanceOrderTableViewCell"];
    advanceOrderCell.status = self.status;
    advanceOrderCell.model = self.dataArr[indexPath.row];
    WEAKSELF;
    if (self.status <= 1) {
        advanceOrderCell.rePlayBlock = ^(){
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"Hello Boss" message:@"请接收您的订单" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.placeholder = @"请输入您对客户的回复";
                textField.secureTextEntry = NO;
            
            }];
            UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField * replayTextField = alertVC.textFields.firstObject;
                [weakSelf requestDelOrderWithReplay:replayTextField.text withIndexPath:indexPath withType:2];
            }];
            
            UIAlertAction * delAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }];
            [alertVC addAction:delAction];
            [alertVC addAction:OKAction];
            weakSelf.alertVC = alertVC;
            [weakSelf presentViewController:weakSelf.alertVC animated:YES completion:nil];
        };
        advanceOrderCell.rejectBlock = ^(){
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"Hello Boss" message:@"请输入拒绝的理由" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.placeholder = @"请输入您拒绝的理由";
                textField.secureTextEntry = NO;
            }];
                UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField * rejectTextField = alertVC.textFields.firstObject;
                [weakSelf requestDelOrderWithReplay:rejectTextField.text withIndexPath:indexPath withType:3];
            }];
            
            UIAlertAction * delAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }];
            [alertVC addAction:delAction];
            [alertVC addAction:OKAction];
            weakSelf.alertVC = alertVC;
            [weakSelf presentViewController:weakSelf.alertVC animated:YES completion:nil];

        };
    }
    return advanceOrderCell;
}
- (void)tapAction{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.alertVC dismissViewControllerAnimated:NO completion:nil];
    });
}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    WEAKSELF;
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [weakSelf headerRereshing];
    }];
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [weakSelf footerRereshing];
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
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":@(self.status),@"pagen":@([self.pagens integerValue]),@"pages":@(page)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_BookLists withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page == 0)[self.dataArr removeAllObjects];
        NSArray * dataArr = responsObj[@"data"];
        
        for (int i = 0; i<dataArr.count; i++) {
            YWHomeAdvanceOrderModel * model =[YWHomeAdvanceOrderModel yy_modelWithDictionary:dataArr[i]];
            model.customer_time = [model.customer_time integerValue]>0?model.customer_time:[JWTools dateWithTodayYearMonthDayNumberStr];

            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}
- (void)requestDelOrderWithReplay:(NSString *)rePlay withIndexPath:(NSIndexPath *)indexPath withType:(NSInteger)type{
    YWHomeAdvanceOrderModel * model = self.dataArr[indexPath.row];
    if (rePlay == nil) {
        rePlay = @"";
    }
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":@([model.orderID integerValue]),@"seller_message":rePlay,@"status":@(type),@"push_title":[NSString stringWithFormat:@"%@的订单%@",[UserSession instance].nickName,(type==2?@"预定成功":@"已被取消")],@"push_content":rePlay};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_BookReply withPragram:pragram success:^(id responsObj) {
        // json数据或者NSDictionary转为NSData，responseObject为json数据或者NSDictionary
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:pragram options:NSJSONWritingPrettyPrinted error:nil];
        // NSData转为NSString
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"!!!!!!!!!%@", jsonStr);
        MyLog(@"！！！Regieter Code pragram is %@",pragram);
        MyLog(@"！！！Regieter Code is %@",jsonStr);
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self showHUDWithStr:@"回复成功" withSuccess:YES];
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
