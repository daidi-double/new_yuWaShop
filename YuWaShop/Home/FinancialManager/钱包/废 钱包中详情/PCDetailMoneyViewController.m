//
//  PCDetailMoneyViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//



#import "PCDetailMoneyViewController.h"

#import "PCMoneyDetailTableViewCell.h"    //cell
#import "YJSegmentedControl.h"
#import "JWTools.h"
#import "MoneyPackModel.h"
#import "customBtn.h"
#import "YWOderDetaleViewController.h"

#import "YWLoginViewController.h"
#define CELL0  @"PCMoneyDetailTableViewCell"

@interface PCDetailMoneyViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate>
{
    
}
@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*maAllDatasModel;   //保存所有的model

@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;

@property(nonatomic,strong)customBtn * titleView;

@property(nonatomic,copy)NSString * orderID;
@end

@implementation PCDetailMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"近期账单";
    [self makeTopView];
    [self.view addSubview: self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"PCMoneyDetailTableViewCell" bundle:nil] forCellReuseIdentifier:CELL0];
    
    [self setUpMJRefresh];
 
}

#pragma mark  -- UI

-(void)makeTopView{
    
    _titleView = [[customBtn alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width/2, 44)];
    [_titleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _titleView.titleLbl.text = @"近期账单";
    
}

- (void)goRefresh:(NSInteger)type{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setUpMJRefresh];
        [self getDatas];
    });
}
-(void)setUpMJRefresh{
    self.maAllDatasModel=[NSMutableArray array];
    
    self.pagen=10;
    self.pages=0;
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.maAllDatasModel=[NSMutableArray array];
        self.pages=0;
        [self getDatas];
    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
    }];
    
    
    //立即刷新
    [self.tableView.mj_header beginRefreshing];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.maAllDatasModel.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCMoneyDetailTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    
    if (self.maAllDatasModel.count > 0) {

    MoneyPackModel*model=self.maAllDatasModel[indexPath.row];
        
    
    
    UILabel * timeLabel = [cell viewWithTag:6];
    
    timeLabel.text = [self distanceTimeWithBeforeTime:[model.ctime doubleValue]];
    

    UILabel * methodLabel = [cell viewWithTag:4];
    methodLabel.text = model.log_info;


    UILabel*moneyLabel=[cell viewWithTag:7];
    
    moneyLabel.text=[NSString stringWithFormat:@"%@",model.money];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}
- (NSString *)distanceTimeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    
    if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 01)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [self weekdayStringFromDate:beDate];
            MyLog(@"distanceStr 1 = %@",distanceStr);
            distanceStr = [df stringFromDate:beDate];
            MyLog(@"distanceStr 2 = %@",distanceStr);
        }
        
    }else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

- (NSString *)timeWithBeforeTime:(double)beTime
{
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    
    if(distanceTime <24*60*60*365){
        [df setDateFormat:@"HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    else{
        [df setDateFormat:@"HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}
//根据日期求星期几
- (NSString *)weekdayStringFromDate:(NSDate*)date{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MoneyPackModel * model;
    if (self.maAllDatasModel.count>0) {
        model = self.maAllDatasModel[indexPath.row];
        
        YWOderDetaleViewController * vc = [[YWOderDetaleViewController alloc]init];
        vc.orderID = model.id;
        vc.status = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
 
}


#pragma mark  --Datas
-(void)getDatas{
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETPAYDETAIL];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":pagen,@"pages":pages};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                MoneyPackModel*model=[MoneyPackModel yy_modelWithDictionary:dict];
                [self.maAllDatasModel addObject:model];
                
            }
            
            [self.tableView reloadData];
            
        }else if ([errorCode isEqualToString:@"9"]){
            
            [JRToast showWithText:@"身份已过期,请重新登入" duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                YWLoginViewController *vc = [[YWLoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    }];
    
}


//#pragma mark  --delegate
//-(void)segumentSelectionChange:(NSInteger)selection{
//    NSInteger aa=selection+1;
//    self.payType=(short)aa;
//    
//    //立即刷新
//    [self.tableView.mj_header beginRefreshing];
//    
//    
//}

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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end
