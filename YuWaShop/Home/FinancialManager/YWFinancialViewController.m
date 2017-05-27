//
//  YWFinancialViewController.m
//  YuWaShop
//
//  Created by 黄佳峰 on 2016/12/5.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWFinancialViewController.h"
#import "FinancialTableViewCell.h"

#import "FinancailBaseModel.h"
#import "PCDetailMoneyViewController.h"

#import "UIScrollView+JWGifRefresh.h"
#import "DayDetailViewController.h"

#import "GetMyMoneyViewController.h"

#define CELL0     @"FinancialTableViewCell"
@interface YWFinancialViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
//@property(nonatomic,strong)UISegmentedControl*typeSegmentView;

@property(nonatomic,assign)NSInteger type;  //0为结算   1为记录
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)NSMutableArray*allDatasModel;
@property(nonatomic,strong)FinancailBaseModel*baseModel;
@end

@implementation YWFinancialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"结算";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"近期账单" style:UIBarButtonItemStylePlain target:self action:@selector(payList)];
    self.navigationItem.rightBarButtonItem = rightBtn;
     [self financialInfo];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)payList{
    
    PCDetailMoneyViewController * vc = [[PCDetailMoneyViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.allDatasModel=[NSMutableArray array];
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.allDatasModel=[NSMutableArray array];
        self.pagen=10;
        self.pages=0;
        [self financialInfo];
     
    }];
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pagen=10;
        self.pages++;
        [self financialInfo];

    }];
    
    [self.tableView.mj_header beginRefreshing];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        //结算
        return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        FinancialTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        
        UILabel*label2=[cell viewWithTag:2];
        label2.text=self.baseModel.pay_type;
        
         UILabel*label4=[cell viewWithTag:4];
        label4.text=self.baseModel.pay_time;
        
         UILabel*label6=[cell viewWithTag:6];
        NSString*time=[JWTools getTime:self.baseModel.tomorrow];
        label6.text=[NSString stringWithFormat:@"%@(共%@)",time,self.baseModel.next_money];
    if ([self.baseModel.next_money isKindOfClass:[NSNull class]]|| self.baseModel.next_money == nil||[self.baseModel.next_money isEqualToString:@"null"]) {
        label6.text=[NSString stringWithFormat:@"%@(共0.00)",time];
    }
        
      
        return cell;
        
   
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

        UIView*headerView=[[NSBundle mainBundle]loadNibNamed:@"FinancialHeaderView" owner:nil options:nil].firstObject;
        headerView.frame=CGRectMake(0, 0, kScreen_Width, 170);
        
        
        UILabel*moneyLabel=[headerView viewWithTag:2];
        moneyLabel.text=self.baseModel.total_settlement;
    if (self.baseModel.total_settlement == nil) {
        moneyLabel.text = @"0.00";
    }
    
        return headerView;

}
//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

        return 170;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kScreen_Height - 64-270;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-270-64)];
    bgView.backgroundColor = [UIColor whiteColor];
    
//    UIButton * getMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    getMoneyBtn.layer.masksToBounds = YES;
//    getMoneyBtn.layer.cornerRadius = 6;
//    getMoneyBtn.frame = CGRectMake(0, 0, kScreen_Width -40, 45);
//    
//    getMoneyBtn.center = bgView.center;
//    [getMoneyBtn setBackgroundColor:CNaviColor];
//    
//    [getMoneyBtn setTitle:@"提现" forState:UIControlStateNormal];
//    [getMoneyBtn addTarget:self action:@selector(getMoney) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:getMoneyBtn];
    
    
    return bgView;
}
//- (void)getMoney{
//    GetMyMoneyViewController * vc = [[GetMyMoneyViewController alloc]init];
//    vc.money = self.baseModel.total_settlement;
//    [self.navigationController pushViewController:vc animated:YES];
//
//}
//结算

-(void)financialInfo{
      NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_FINANCIALBASE];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            self.baseModel=[FinancailBaseModel yy_modelWithDictionary:data[@"data"]];
            
            
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];

        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}


@end
