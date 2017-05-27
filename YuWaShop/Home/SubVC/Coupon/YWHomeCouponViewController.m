//
//  YWHomeCouponViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeCouponViewController.h"
#import "YWHomeAddCouponViewController.h"
#import "YWHomeCouponHeaderView.h"
#import "YWHomeCouponTableViewCell.h"
#import "YJSegmentedControl.h"

@interface YWHomeCouponViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)YWHomeCouponHeaderView * headerView;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)NSMutableArray * dataArr;
//@property (nonatomic,strong)NSMutableArray * imageAry;
//@property (nonatomic,strong)NSMutableArray * colorAry;
@property (nonatomic,strong)YJSegmentedControl * segmentControl;

@end

@implementation YWHomeCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优惠促销";
    [self makeUI];
    [self dataSet];
    [self setupRefresh];
}
//- (NSMutableArray *)imageAry{
//    if (!_imageAry) {
//        _imageAry = [NSMutableArray array];
//    }
//    return _imageAry;
//}
//
//- (NSMutableArray*)colorAry{
//    if (!_colorAry) {
//        _colorAry = [NSMutableArray array];
//    }
//    return _colorAry;
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
//    self.navigationController.navigationBarHidden = NO;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
}
- (void)makeUI{
    self.segmentControl = [YJSegmentedControl segmentedControlFrame:CGRectMake(0.f, 0.f, kScreen_Width, 40.f) titleDataSource:@[@"有效抵用券",@"过期抵用券"] backgroundColor:[UIColor clearColor] titleColor:CNaviColor titleFont:[UIFont boldSystemFontOfSize:15.f] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
    self.segmentControl.backgroundColor = [UIColor whiteColor];
}

- (void)dataSet{
    self.status = 1;
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
//    NSArray * youhuiquanAry = @[@"youhuiquan_03",@"youhuiquan_06",@"youhuiquan_08",@"youhuiquan_10"];
//    NSArray * colorAry = @[RGBCOLOR(255, 193, 0, 1),RGBCOLOR(54, 192, 250, 1),RGBCOLOR(7, 225, 158, 1),RGBCOLOR(255, 94, 108, 1)];
//    [self.imageAry addObjectsFromArray:youhuiquanAry];
//    [self.colorAry addObjectsFromArray:colorAry];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWHomeCouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWHomeCouponTableViewCell"];
}

- (IBAction)addCouponBtnAction:(id)sender {
    YWHomeAddCouponViewController * vc = [[YWHomeAddCouponViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - YJSegmentedControlDelegate
-(void)segumentSelectionChange:(NSInteger)selection{
    self.status = selection+1;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.segmentControl;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        YWHomeCouponModel * model = self.dataArr[indexPath.row];
        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestDelWithID:model.couponID withIndexPath:indexPath];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除这张优惠券?" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWHomeCouponTableViewCell * couponCell = [tableView dequeueReusableCellWithIdentifier:@"YWHomeCouponTableViewCell"];
    couponCell.model = self.dataArr[indexPath.row];

    return couponCell;
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
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":@(self.status),@"pagen":@([self.pagens integerValue]),@"pages":@(page)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_CouponList withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page == 0)[self.dataArr removeAllObjects];
        NSArray * dataArr = responsObj[@"data"];
        for (int i = 0; i<dataArr.count; i++) {
            [self.dataArr addObject:[YWHomeCouponModel yy_modelWithDictionary:dataArr[i]]];
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

- (void)requestDelWithID:(NSString *)couponID withIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":@([couponID integerValue])};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_DelCoupon withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self showHUDWithStr:@"删除优惠券成功" withSuccess:YES];
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        [self showHUDWithStr:@"删除优惠券失败,请重试" withSuccess:NO];
    }];
}

@end
