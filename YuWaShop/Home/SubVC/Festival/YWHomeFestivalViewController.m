//
//  YWHomeFestivalViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeFestivalViewController.h"
#import "YWHomeFestivalTableViewCell.h"
#import "GetMyMoneyViewController.h"

@interface YWHomeFestivalViewController ()

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (weak, nonatomic) IBOutlet UIButton *addFastivalBtn;
@property (weak, nonatomic) IBOutlet UILabel *getMyMoneyLabel;


@end

@implementation YWHomeFestivalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现管理";
 
    [self dataSet];
    [self requestMyAcountMoney];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)dataSet{
    
    _addFastivalBtn.layer.masksToBounds = YES;
    _addFastivalBtn.layer.cornerRadius = 6;
}

- (IBAction)addFastivalBtnAction:(id)sender {
    GetMyMoneyViewController * vc = [[GetMyMoneyViewController alloc]init];
    vc.money = self.getMyMoneyLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}
//
//#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 110.f;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 47.f;
//}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.headerView;
//}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle ==UITableViewCellEditingStyleDelete){
//        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            YWHomeFestivalModel * model = self.dataArr[indexPath.row];
//            [self requestDelFastivalWithID:model.fastivalID withIndexPath:indexPath];
//        }];
//        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除节日活动?" preferredStyle:UIAlertControllerStyleAlert];
//        [alertVC addAction:cancelAction];
//        [alertVC addAction:OKAction];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
//    }
//}
//#pragma mark - UITableViewDataSource
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArr.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    YWHomeFestivalTableViewCell * festivalCell = [tableView dequeueReusableCellWithIdentifier:@"YWHomeFestivalTableViewCell"];
//    festivalCell.model = self.dataArr[indexPath.row];
//    festivalCell.status = self.type;
//    return festivalCell;
//}
//
//#pragma mark - TableView Refresh
//- (void)setupRefresh{
//    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
//        [self headerRereshing];
//    }];
//    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
//        [self footerRereshing];
//    }];
//}
//- (void)headerRereshing{
//    self.pages = 0;
//    [self requestDataWithPages:0];
//}
//- (void)footerRereshing{
//    self.pages++;
//    [self requestDataWithPages:self.pages];
//}
//- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
//    if (isHeader) {
//        [self.tableView.mj_header endRefreshing];
//    }else{
//        [self.tableView.mj_footer endRefreshing];
//    }
//}
//
#pragma mark - Http
- (void)requestMyAcountMoney{

    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETMYACTOUNTMONEY];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"user_type":@(2)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            if (data[@"data"] == nil || [data[@"data"] isKindOfClass:[NSNull class]]) {
                self.getMyMoneyLabel.text = @"0.00";
            }else{
                CGFloat money = [data[@"data"] floatValue];
                self.getMyMoneyLabel.text = [NSString stringWithFormat:@"%.2f",money];
            }
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
            if (number == 9) {
                
            }
        }
    }];
}
//- (void)requestDataWithPages:(NSInteger)page{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
//    });
//    NSInteger status;
//    switch (self.type) {
//        case 1:
//            status = 2;
//            break;
//        case 2:
//            status = 1;
//            break;
//        case 3:
//            status = 3;
//            break;
//            
//        default:
//            break;
//    }
//    
//    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":@(status),@"pagen":@([self.pagens integerValue]),@"pages":@(page)};
//    
//    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_HolidayLists withPragram:pragram success:^(id responsObj) {
//        MyLog(@"Regieter Code pragram is %@",pragram);
//        MyLog(@"Regieter Code is %@",responsObj);
//        if (page == 0)[self.dataArr removeAllObjects];
//        NSArray * dataArr = responsObj[@"data"];
//        for (int i = 0; i<dataArr.count; i++) {
//            [self.dataArr addObject:[YWHomeFestivalModel yy_modelWithDictionary:dataArr[i]]];
//        }
//        [self.tableView reloadData];
//    } failur:^(id responsObj, NSError *error) {
//        MyLog(@"Regieter Code pragram is %@",pragram);
//        MyLog(@"Regieter Code error is %@",responsObj);
//    }];
//}
//
//- (void)requestDelFastivalWithID:(NSString *)bankID withIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":@([bankID integerValue])};
//    
//    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_DelHoliday withPragram:pragram success:^(id responsObj) {
//        MyLog(@"Regieter Code pragram is %@",pragram);
//        MyLog(@"Regieter Code is %@",responsObj);
//        [self.dataArr removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        [self showHUDWithStr:@"删除成功" withSuccess:YES];
//    } failur:^(id responsObj, NSError *error) {
//        MyLog(@"Regieter Code pragram is %@",pragram);
//        MyLog(@"Regieter Code error is %@",responsObj);
//    }];
//}

@end
