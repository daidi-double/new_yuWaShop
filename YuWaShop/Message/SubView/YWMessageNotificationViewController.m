//
//  YWMessageNotificationViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageNotificationViewController.h"
#import "YWPayNotificationTableView.h"
#import "NSDictionary+Attributes.h"

#import "YWMessageNotificationCell.h"

#define MESSAGENOTICELL @"YWMessageNotificationCell"
@interface YWMessageNotificationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)YWPayNotificationTableView * payTableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;

@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)UISegmentedControl * segmentedControl;

@end

@implementation YWMessageNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
    [self dataSet];
    [self setupRefresh];
    [self headerRereshing];
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGENOTICELL bundle:nil] forCellReuseIdentifier:MESSAGENOTICELL];
}

- (void)makeUI{
    self.pagens = @"15";
    self.tableView.alwaysBounceVertical = YES;
    
    self.payTableView = [[YWPayNotificationTableView alloc]initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, kScreen_Height - 64.f) style:UITableViewStylePlain];
    self.payTableView.pagens = self.pagens;
    [self.payTableView dataSet];
    [self.view addSubview:self.payTableView];
}
- (void)makeNavi{
    self.segmentedControl = [self makeSegmentedControl];
    self.navigationItem.titleView = self.segmentedControl;
}

- (UISegmentedControl *)makeSegmentedControl{
    UISegmentedControl * segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"预约通知",@"付款通知"]];
    segmentControl.frame = CGRectMake(0.f, 0.f, ACTUAL_WIDTH(180.f), 30.f);
    segmentControl.tintColor = [UIColor whiteColor];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.layer.cornerRadius = 5.f;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentControl.layer.borderWidth = 2.f;
    [segmentControl setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    return segmentControl;
}

#pragma mark - Control Action
- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.status = sender.selectedSegmentIndex;
    self.payTableView.hidden = sender.selectedSegmentIndex == 0?YES:NO;
    if (sender.selectedSegmentIndex == 0) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self.payTableView.mj_header beginRefreshing];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMessageNotificationCell * messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGENOTICELL];
    messageCell.model = self.dataArr[indexPath.row];
    return messageCell;
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
- (void)footerRereshing{
    self.pages++;
    [self requestShopArrDataWithPages:self.pages];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestShopArrDataWithPages:0];
}

- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Http
- (void)requestShopArrDataWithPages:(NSInteger)page{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":self.pagens,@"pages":[NSString stringWithFormat:@"%zi",page]};
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    
    [[HttpObject manager]postNoHudWithType:YuWaType_NOTCCAFICATIONJ_ORDER withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page==0){
            [self.dataArr removeAllObjects];
        }
        NSArray * dataArr = responsObj[@"data"];
        if (dataArr.count>0) {
            for (int i = 0; i<dataArr.count; i++) {
                YWMessageNotificationModel * model = [YWMessageNotificationModel yy_modelWithDictionary:dataArr[i]];
                model.status = @"0";
                [self.dataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}


@end
