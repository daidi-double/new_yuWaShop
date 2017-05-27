//
//  SignShopViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SignShopViewController.h"
#import "MybindingShopTableViewCell.h"

#import "MySignShopModel.h"

#import "JWTools.h"


#define CELL0   @"MybindingShopTableViewCell"

@interface SignShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*maMallDatas;
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@end

@implementation SignShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我签约的店铺";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MybindingShopTableViewCell" bundle:nil] forCellReuseIdentifier:CELL0];
    [self setUpMJRefresh];
    
}

#pragma mak  --UI
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.maMallDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MybindingShopTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    MySignShopModel*model=self.maMallDatas[indexPath.section];
    
    UILabel*label1=[cell viewWithTag:1];
    label1.text=model.company_name;
    
    UILabel*label2=[cell viewWithTag:2];
    NSString*time= [JWTools getTime:model.ctime];
    label2.text=[NSString stringWithFormat:@"签约时间:%@",time];
    
    UILabel*label3=[cell viewWithTag:3];
    label3.text=[NSString stringWithFormat:@"昨天成交量:%@",model.yestoday];
    
    UILabel*label4=[cell viewWithTag:4];
    label4.text=[NSString stringWithFormat:@"获得绑定会员：%@人",model.indirect_nums];
    
    UILabel*label5=[cell viewWithTag:5];
    label5.text=[NSString stringWithFormat:@"获得总积分：%@",model.score];
    
    UILabel*label6=[cell viewWithTag:6];
    label6.text=[NSString stringWithFormat:@"获得介绍分红：%@",model.indirect];
    
    UILabel*label7=[cell viewWithTag:7];
    label7.text=[NSString stringWithFormat:@"获得商务分红：%@",model.business];
    
    cell.selectionStyle=NO;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
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

#pragma mark  --getDatas
-(void)getDatas{
    
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_MY_ORDER_SHOP];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pages":pages,@"pagen":pagen};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                MySignShopModel*model=[MySignShopModel  yy_modelWithDictionary:dict];
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


#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width,kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end
