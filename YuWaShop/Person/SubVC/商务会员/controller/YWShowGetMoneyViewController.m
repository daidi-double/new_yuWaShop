//
//  YWShowGetMoneyViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWShowGetMoneyViewController.h"
#import "YJSegmentedControl.h"
#import "ShowGetMoneyTableViewCell.h"

#import "ShowDetailModel.h"

#import "JWTools.h"



#import "MoneyDetailViewController.h"   //详情

#define CELL0    @"ShowGetMoneyTableViewCell"

@interface YWShowGetMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*maMallDatas;
@property(nonatomic,strong)NSString*total_money;       //总的钱
@property(nonatomic,strong)NSString*total_settlement;   //总的待结算
@property (nonatomic, strong) UIView *headerView;
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;

@end

@implementation YWShowGetMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"收入详情";
    
    [self makeTopSelectedView];
    [self.view addSubview:self.tableView];
    [self setUpMJRefresh];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
}


-(void)makeTopSelectedView{
    NSArray*array= @[@"昨天",@"今天",@"近周",@"近月",@"全部"];
   YJSegmentedControl*view=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 64, kScreen_Width, 40) titleDataSource:array backgroundColor:[UIColor whiteColor] titleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:14] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
    [self.view addSubview:view];
    
  
    NSInteger number=[self.time integerValue];
    [view selectTheSegument:number];

    
}

-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.maMallDatas=[NSMutableArray array];
        [self getDatas];
        
    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
    
}

#pragma mark  -- UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.maMallDatas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowGetMoneyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    
    if (self.maMallDatas.count<1) {
       
        return cell;
    }
    ShowDetailModel*model=self.maMallDatas[indexPath.row];
    
    
    UILabel*timeLabel=[cell viewWithTag:1];
    timeLabel.text=[JWTools getTime:model.ctime];
    
    UILabel*categoryLabel=[cell viewWithTag:2];
    categoryLabel.text=model.type;
    
    UILabel*moneyLabel=[cell viewWithTag:3];
    moneyLabel.text= [NSString stringWithFormat:@"%.4f",[model.money floatValue]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      ShowDetailModel*model=self.maMallDatas[indexPath.row];
    MoneyDetailViewController*vc=[[MoneyDetailViewController alloc]init];
    vc.idd=model.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {

        UILabel*label1=[self.headerView viewWithTag:1];
        label1.text= [NSString stringWithFormat:@"%@",self.total_money];
        
        UILabel*label3=[self.headerView viewWithTag:3];
        label3.text= [NSString stringWithFormat:@"%@",self.total_settlement];
        
        UILabel*label5=[self.headerView viewWithTag:5];
        label5.text=@"时间";
        
        UILabel*label6=[self.headerView viewWithTag:6];
        label6.text=@"款项类型";
        
        UILabel*label7=[self.headerView viewWithTag:7];
        if ([self.type isEqualToString:@"2"]) {
            label7.text=@"积分";
        }else{
            label7.text=@"金额";

        }

        return self.headerView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark  --getDatas
-(void)getDatas{
    
   
             //商务会员
            [self businesserDatas];
            
    
    
}


-(void)businesserDatas{
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_Filter_LIST];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages,@"time":self.time,@"type":self.type};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
            self.total_money=data[@"data"][@"total_money"];
            self.total_settlement=data[@"data"][@"total_settlement"];
            
            for (NSDictionary*dict in data[@"data"][@"lists"]) {
                ShowDetailModel*model=[ShowDetailModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
               
                
            }
            
             [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];

    
}


#pragma mark  --touch
//-(void)touchRightButton{
//    
//}

#pragma mark  --delegate
-(void)segumentSelectionChange:(NSInteger)selection{
    MyLog(@"%lu",selection);
    switch (selection) {
        case 0:
            self.time=@"0";
            break;
        case 1:
            self.time=@"1";
            break;
        case 2:
            self.time=@"2";
            break;
        case 3:
            self.time=@"3";
            break;
        case 4:
            self.time=@"4";
            break;

        default:
            break;
    }
    
    [self.tableView.mj_header beginRefreshing];
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
    // Pass the selected object tosd the new view controller.
}
*/

#pragma mark   - -set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+40, kScreen_Width, kScreen_Height-64-40) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return  _tableView;
}
-(UIView *)headerView{
    if (!_headerView) {
           _headerView=[[NSBundle mainBundle]loadNibNamed:@"IncomeDetailView" owner:nil options:nil].firstObject;
    }
    return _headerView;
}
@end
