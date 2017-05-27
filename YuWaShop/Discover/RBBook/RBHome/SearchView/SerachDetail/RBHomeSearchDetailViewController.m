//
//  RBHomeSearchDetailViewController.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/18.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBHomeSearchDetailViewController.h"
#import "RBHomeSearchToolsView.h"
#import "RBNodeShowViewController.h"

#import "MDHotelRightBtn.h"
#import "RBNodeDRecommendTableViewCell.h"

#define RECOMMENDCELL @"RBNodeDRecommendTableViewCell"
@interface RBHomeSearchDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)RBHomeSearchToolsView * searchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;//collectionView数据
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger states;
@property (nonatomic,strong)RBNodeDRecommendTableViewCell * recommendCell;
@property (nonatomic,strong)UIView * sortHeaderView;
@property (nonatomic,strong)MDHotelRightBtn * sortBarBtn;

@end

@implementation RBHomeSearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self setupRefresh];
    [self dataSet];
    [self requestDataWithPages:0];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.searchView.height = 30.f;
    self.searchView.width = kScreen_Width - 40.f;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.sortBarBtn.isOn)[self.sortBarBtn tapAction];
}

- (void)makeNavi{
    self.searchView = [[[NSBundle mainBundle]loadNibNamed:@"RBHomeSearchToolsView" owner:nil options:nil]firstObject];
    [self.searchView.textField setUserInteractionEnabled:NO];
    self.searchView.searchKey = [NSString stringWithFormat:@" %@  x",self.searchKey];
    WEAKSELF;
    self.searchView.typeChooseBlock = ^(NSInteger type){
        weakSelf.type = type;
    };
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.searchView addGestureRecognizer:tap];
    self.navigationItem.titleView = self.searchView;
}

- (void)tapAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dataSet{
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:RECOMMENDCELL bundle:nil] forCellReuseIdentifier:RECOMMENDCELL];
    
    self.recommendCell = [self.tableView dequeueReusableCellWithIdentifier:RECOMMENDCELL];
    self.recommendCell.selectionStyle = UITableViewCellSelectionStyleNone;
    WEAKSELF;
    self.recommendCell.selectNodeBlock = ^(NSInteger nodeIndex){
        RBNodeShowViewController * vc = [[RBNodeShowViewController alloc]init];
        vc.model = weakSelf.dataArr[nodeIndex];
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArr.count<=0)return 1.f;
    self.recommendCell.dataArr = self.dataArr;
    return self.recommendCell.cellHeight + 20.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.sortHeaderView) {
        self.sortHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 30.f)];
        self.sortHeaderView.backgroundColor = [UIColor whiteColor];
        self.sortBarBtn = [[[NSBundle mainBundle]loadNibNamed:@"MDHotelRightBtn" owner:nil options:nil]firstObject];
        self.sortBarBtn.frame = CGRectMake(0.f, 3.f, kScreen_Width, 24.f);
        WEAKSELF;
        self.sortBarBtn.chooseTypeBlock = ^(NSString * chooseType){
            weakSelf.states = [chooseType integerValue];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [self.sortHeaderView addSubview:self.sortBarBtn];
    }
    return self.sortHeaderView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.recommendCell.dataArr = self.dataArr;
    return self.recommendCell;
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
    NSDictionary * pragram = @{@"keyword":self.searchKey,@"pagen":self.pagens,@"pages":[NSString stringWithFormat:@"%zi",page],@"sort":@(self.states),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    
    [[HttpObject manager]postDataWithType:YuWaType_RB_SEARCH_RESULT withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page == 0) {
            [self.dataArr removeAllObjects];
        }
        NSArray * dataArr = responsObj[@"data"];
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary * dataDic = [RBHomeModel dataDicSetWithDic:dic];
            [self.dataArr addObject:[RBHomeModel yy_modelWithDictionary:dataDic]];
        }];
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
