//
//  YWBusinessMemberViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWBusinessMemberViewController.h"
#import "BusinessMumberHeaderView.h"   //头
#import "BusinessMoneyTableViewCell.h" //3个cell
#import "MyUserCell.h"       //底部的cell

#import "JWTools.h"

#import "BusinessBaseInfoModel.h"   
#import "introduceModel.h"
//#import "BusinessMoneyModel.h"
#import "ScoreModel.h"
#import "BindingPersonModel.h"


#import "IntroduceMoneyViewController.h"   //介绍分红
//#import "BusinessMoneyViewController.h"   //商务分红
#import "PointMoneyViewController.h"     //积分分红界面
#import "SignUserViewController.h"    //我锁定的人

#import "YWShowGetMoneyViewController.h"   //展示收入界面

#define CELL0  @"BusinessMoneyTableViewCell"
#define CELL1  @"MyUserCell"


@interface YWBusinessMemberViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UITableView*tableView;


@property(nonatomic,strong)BusinessBaseInfoModel*base_infoModel;
@property(nonatomic,strong)introduceModel*introduceModel;
@property(nonatomic,strong)ScoreModel*scoreModel;
@property(nonatomic,strong)BindingPersonModel*BiningModel;

@property (nonatomic, assign) CGRect bolangImageVIewFrame;
@property (nonatomic, strong) UIImageView *bolangImageVIew;

@end

@implementation YWBusinessMemberViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:CELL1 bundle:nil] forCellReuseIdentifier:CELL1];
    
    [self setUpMJRefresh];
    

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat yoffset=scrollView.contentOffset.y;
//    if (yoffset<0) {
//        CGRect frame = self.bolangImageVIew.frame;
//        frame.origin.x = self.bolangImageVIew.origin.x +yoffset/2;
//        frame.origin.y=  yoffset ;
//        frame.size.height = -yoffset+self.bolangImageVIewFrame.size.height;
//        frame.size.width = self.bolangImageVIewFrame.size.width/self.bolangImageVIewFrame.size.height*frame.size.height;
//        //改变头部视图的fram
//        MyLog(@"~~~~~~!!!!!!!%@",NSStringFromCGRect(frame));
//        self.bolangImageVIew.frame= frame;
//    }
    

    CGFloat aa =scrollView.contentOffset.y;
    if (aa<=190) {
          [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:0];
        self.title =@"";
    }else if (190<aa&&aa<=250){
        CGFloat scale=(aa-190)/60;
        
        [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:scale];

        
    }else if (aa>250){
        [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:1];
        self.title = @"我的分红";
    }else{
        [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:0];

    }
    
}

-(void)setUpMJRefresh{

    WEAKSELF;
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [weakSelf getDatas];
        
    }];
    

    
    [self.tableView.mj_header beginRefreshing];
    
    
    
}

#pragma mark  --UI
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessMoneyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    
    //图标
    UIImageView*imageView=[cell viewWithTag:1];
    //titleLabel
    UILabel*titleLabel=[cell viewWithTag:2];
    //topLabel
    UILabel*topLabel=[cell viewWithTag:4];
    //
    UILabel*subLabel=[cell viewWithTag:5];
    //
    UILabel*timeLabel=[cell viewWithTag:6];
    
    
    //
    UILabel*totailLabel=[cell viewWithTag:12];
    //
    UILabel*todayLabel=[cell viewWithTag:14];
    //
    UILabel*waitLabel=[cell viewWithTag:16];
    
    
    if (indexPath.section==0) {
        //介绍分红
        imageView.image=[UIImage imageNamed:@"介绍分红"];
        titleLabel.text=@"介绍分红";
        topLabel.text=[NSString stringWithFormat:@"%@",self.introduceModel.rose_introduce];
        subLabel.text=@"近一周涨幅";
        timeLabel.text=[JWTools currentTime];
        
        totailLabel.text=self.introduceModel.total_introduce;
        todayLabel.text=self.introduceModel.today_introduce;
        waitLabel.text=self.introduceModel.settlement_introduce;
        if (self.introduceModel.total_introduce == nil) {
            totailLabel.text = @"0.00";
        }
        if (self.introduceModel.today_introduce == nil) {
            todayLabel.text = @"0.00";
        }
        if (self.introduceModel.settlement_introduce == nil) {
            waitLabel.text = @"0.00";
        }
        
    }else if (indexPath.section==1){
        // 积分分红
         imageView.image=[UIImage imageNamed:@"积分分红"];
        titleLabel.text=@"积分分红";
        topLabel.text=[NSString stringWithFormat:@"%@",self.scoreModel.my_score];
        if (self.scoreModel.my_score==nil ||[self.scoreModel.my_score isKindOfClass:[NSNull class]]) {
            topLabel.text = @"0.00";
        }
        subLabel.text=@"当前积分";
        timeLabel.text=[JWTools currentTime];
        UILabel * totalLabel = [cell viewWithTag:11];
        totalLabel.text = @"总积分(sp)";
        UILabel * todaysLabel = [cell viewWithTag:13];
        todaysLabel.text = @"今日积分(sp)";
        UILabel * waitsLabel = [cell viewWithTag:15];
        waitsLabel.text = @"待结算积分(sp)";
        totailLabel.text=self.scoreModel.total_score;
        todayLabel.text=self.scoreModel.today_score;
        waitLabel.text=self.scoreModel.settlement_score;
        if (self.scoreModel.total_score == nil) {
            totailLabel.text = @"0.00";
        }
        if (self.scoreModel.today_score == nil) {
            todayLabel.text = @"0.00";
        }
        if (self.scoreModel.settlement_score == nil) {
            waitLabel.text = @"0.00";
        }
        
        
    }
    
    
    if (indexPath.section==2) {
        MyUserCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.selectionStyle=NO;
        
        UILabel*directBinding=[cell viewWithTag:1];   //直接锁定
        directBinding.text=[NSString stringWithFormat:@"%@人",self.BiningModel.my_direct_user_nums];
       
        UILabel*indirectBinding=[cell viewWithTag:22];  //间接锁定
        indirectBinding.text=[NSString stringWithFormat:@"%@人",self.BiningModel.my_indirect_user_nums];
        UIView * tapView = [cell viewWithTag:555];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(indirctActionTap)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [tapView addGestureRecognizer:tap];
        
        UIButton * directBtn = [cell viewWithTag:666];
        [directBtn addTarget:self action:@selector(directAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * indirectBtn = [cell viewWithTag:888];
        [indirectBtn addTarget:self action:@selector(indirectAction) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
    
    return cell;
}

- (void)directAction{
    SignUserViewController*vc=[[SignUserViewController alloc]init];
    vc.status = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)indirectAction{
    SignUserViewController*vc=[[SignUserViewController alloc]init];
    vc.status = @"1";
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)indirctActionTap{
    SignUserViewController*vc=[[SignUserViewController alloc]init];
    vc.status = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        IntroduceMoneyViewController*vc=[[IntroduceMoneyViewController alloc]init];
        vc.model=self.introduceModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section==1){
        PointMoneyViewController*vc=[[PointMoneyViewController alloc]init];
        vc.model=self.scoreModel;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.section==2){
//        SignUserViewController*vc=[[SignUserViewController alloc]init];
//        
//        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WEAKSELF;
    if (section==0) {
        BusinessMumberHeaderView*view=[[NSBundle mainBundle]loadNibNamed:@"BusinessMumberHeaderView" owner:nil options:nil].firstObject;
        if (!self.bolangImageVIew) {
            self.bolangImageVIew =  view.boliangImageView;
            self.bolangImageVIewFrame = view.boliangImageView.frame;
        }else{
            view.boliangImageView.frame = self.bolangImageVIew.frame ;
        }
        //今日收益
        UILabel*label2=[view viewWithTag:2];
        label2.text=self.base_infoModel.today_money;
        if (self.base_infoModel.today_money == nil) {
            label2.text = @"0.00";
        }
        
        //总收益
        UILabel*label4=[view viewWithTag:4];
        label4.text=self.base_infoModel.total_money;
        if (self.base_infoModel.total_money == nil) {
            label4.text = @"0.00";
        }
        
        //总待结算收益
        UILabel*label5=[view viewWithTag:5];
        label5.text=@"总待结算收益";
        
        UILabel*label6=[view viewWithTag:6];
        label6.text=self.base_infoModel.total_settlement;
        
        if (self.base_infoModel.total_settlement == nil) {
            label6.text = @"0.00";
        }
        //总共的 详情
        view.TotailBlock=^(){
            YWShowGetMoneyViewController*vc=[[YWShowGetMoneyViewController alloc]init];
            vc.time=@"4";
            vc.type=@"3";
            [weakSelf.navigationController pushViewController:vc animated:YES];

        };
        
        //总的待结算
        view.waitBlock=^(){
            YWShowGetMoneyViewController*vc=[[YWShowGetMoneyViewController alloc]init];
            vc.time=@"4";
            vc.type=@"4";
            [weakSelf.navigationController pushViewController:vc animated:YES];

            
        };
        
        
        return view;
        
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 250;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 215;
}




#pragma mark  --getDatas
-(void)getDatas{
   
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_HOME_SHAREMONEY];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            self.base_infoModel=[BusinessBaseInfoModel yy_modelWithDictionary:data[@"data"][@"base_info"]];
            self.introduceModel=[introduceModel yy_modelWithDictionary:data[@"data"][@"introduce"]];
            self.scoreModel=[ScoreModel yy_modelWithDictionary:data[@"data"][@"score"]];
            self.BiningModel=[[BindingPersonModel alloc]init];
            self.BiningModel.my_direct_user_nums=data[@"data"][@"my_direct_user_nums"];
            self.BiningModel.my_indirect_user_nums=data[@"data"][@"my_indirect_user_nums"];
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];

        
        
        
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

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end
