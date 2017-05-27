//
//  YWHomeCompareViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeCompareViewController.h"
#import "YWHomeCompareViewHeaderView.h"
#import "YWHomeCompareMyTableViewCell.h"
#import "YWHomeCompareOtherTableViewCell.h"
#import "YWHomeCompareSortTableView.h"

@interface YWHomeCompareViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)YWHomeCompareViewHeaderView * headerView;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,assign)NSInteger subTypeIdx;//子类位置
@property (nonatomic,copy)NSString * typeID;//比较类型
@property (nonatomic,copy)NSString * typeName;
@property (nonatomic,strong)YWHomeCompareMyModel * myModel;

@property (nonatomic,strong)YWHomeCompareSortTableView * sortSubView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YWHomeCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"同业排行";
//    [self dataSet];
//    [self makeUI];
//    [self setupRefresh];
//    [self requestDataWithPages:0];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)dataSet{
    if ([[UserSession instance].shopTypeID isEqualToString:@"0"]){
        [UserSession userCompareType];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reFreshData];
        });
    }
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.typeID = [UserSession instance].shopTypeID;
    self.typeName = [UserSession instance].shopType;
    [self.tableView registerNib:[UINib nibWithNibName:@"YWHomeCompareMyTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWHomeCompareMyTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWHomeCompareOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWHomeCompareOtherTableViewCell"];
}

- (void)makeUI{
    WEAKSELF;
    self.headerView = [[YWHomeCompareViewHeaderView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 124.f)];
    
    self.sortSubView = [[YWHomeCompareSortTableView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.headerView.width, self.headerView.height-1.f)];
    self.sortSubView.hidden = YES;
    self.sortSubView.dataArr = [NSMutableArray arrayWithArray:[UserSession instance].shopSubTypeArr];
    self.sortSubView.choosedTypeBlock = ^(NSInteger subTypeIdx){
        weakSelf.subTypeIdx = subTypeIdx;
        NSString * typeID = [UserSession instance].shopSubTypeArr[weakSelf.subTypeIdx];
        weakSelf.typeID = typeID?typeID:@"44";
        weakSelf.sortSubView.hidden = YES;
        UIButton * btn = [weakSelf.headerView.typeSegmentedControl viewWithTag:2];
        [btn setTitle:weakSelf.sortSubView.dataArr[subTypeIdx] forState:UIControlStateNormal];
        [btn setTitle:weakSelf.sortSubView.dataArr[subTypeIdx] forState:UIControlStateSelected];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.headerView addSubview:self.sortSubView];
    
    self.headerView.showTypeBlock = ^(BOOL isShowAllType){
        if (isShowAllType) {
            weakSelf.typeID = [UserSession instance].shopTypeID;
        }else{
            NSString * typeID = [UserSession instance].shopSubTypeArr[weakSelf.subTypeIdx];
            weakSelf.typeID = typeID?typeID:@"44";
        }
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    self.headerView.changeSubTypeBlock = ^(){
        weakSelf.sortSubView.hidden = NO;
    };
    self.headerView.compareTypeBlock = ^(NSInteger compareType){
        weakSelf.status = compareType;
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0?88.f:65.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 124.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.sortSubView.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count + (self.myModel?1:0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && self.myModel) {
        YWHomeCompareMyTableViewCell * myCompareCell = [tableView dequeueReusableCellWithIdentifier:@"YWHomeCompareMyTableViewCell"];
        myCompareCell.model = self.myModel;
        return myCompareCell;
    }
    
    YWHomeCompareOtherTableViewCell * otherCompareCell = [tableView dequeueReusableCellWithIdentifier:@"YWHomeCompareOtherTableViewCell"];
    otherCompareCell.model = self.dataArr[indexPath.row - (self.myModel?1:0)];
    return otherCompareCell;
}

- (void)reFreshData{
    self.typeID = [UserSession instance].shopTypeID;
    self.sortSubView.dataArr = [NSMutableArray arrayWithArray:[UserSession instance].shopSubTypeArr];
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
    
    NSMutableDictionary * pragram = [NSMutableDictionary dictionaryWithDictionary:@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":[NSString stringWithFormat:@"%zi",(self.status+1)],@"pagen":@([self.pagens integerValue]),@"pages":@(page)}];
    if (![self.typeID isEqualToString:[UserSession instance].shopTypeID]) {
        [pragram setObject:self.typeID forKey:@"tag_id"];
        for (int i = 0; i < [UserSession instance].shopSubTypeIDArr.count; i++) {
            if ([[UserSession instance].shopSubTypeIDArr[i] isEqualToString:self.typeID]) {
                self.typeName = [UserSession instance].shopSubTypeIDArr[i];
            }
        }
    }else{
        self.typeName = [UserSession instance].shopType;
    }
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_RankLists withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSDictionary * dataDic = responsObj[@"data"];
        if (page == 0) {
            [self.dataArr removeAllObjects];
            self.myModel = [YWHomeCompareMyModel yy_modelWithDictionary:dataDic[@"shop"]];
            self.myModel.status = self.status;
            self.myModel.typeName = self.typeName;
        }
        NSArray * dataArr = dataDic[@"lists"];
        for (int i = 0; i<dataArr.count; i++) {
            YWHomeCompareOtherModel * model =[YWHomeCompareOtherModel yy_modelWithDictionary:dataArr[i]];
            model.status = self.status;
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
