//
//  PointMoneyViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PointMoneyViewController.h"
#import "pointMoneyHeaderView.h"   //headerView

#import "ProgressView.h"//进度条
#import "JWTools.h"
#import "ExchangeViewController.h"

#import "YWShowGetMoneyViewController.h"

@interface PointMoneyViewController ()

@property(nonatomic,strong)UILabel*currentPointLabel;
@property(nonatomic,assign)CGFloat proportion;

@end

@implementation PointMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"商务积分";
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self addHeaderView];
    [self addBottomImageView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
}

-(void)addHeaderView{
    pointMoneyHeaderView*view=[[NSBundle mainBundle]loadNibNamed:@"pointMoneyHeaderView" owner:nil options:nil].firstObject;
    view.frame=CGRectMake(0, 0, kScreen_Width, 300);
    [self.view addSubview:view];
    
    UILabel * gradeLabel = [view viewWithTag:1];
    UILabel * pay_scaleLabel = [view viewWithTag:2];
    pay_scaleLabel.text = [NSString stringWithFormat:@"当前兑换比例为%@",self.model.pay_scale];
    self.proportion = [self.model.total_score floatValue];
    
    NSString * str;
    if (self.proportion <= 1000) {
        str = [NSString stringWithFormat:@"%f",self.proportion/1000];
        gradeLabel.text = @"商务会员";
        
    }else if (self.proportion >1000 && self.proportion <= 3000){
        str = [NSString stringWithFormat:@"%f",self.proportion/3000];
        gradeLabel.text = @"白银会员";
    }else if (self.proportion > 3000 && self.proportion <= 8000){
        str = [NSString stringWithFormat:@"%f",self.proportion/8000];
        gradeLabel.text = @"黄金会员";
    }else if (self.proportion > 8000 && self.proportion <= 15000){
        str = [NSString stringWithFormat:@"%f",self.proportion/15000];
        gradeLabel.text = @"铂金会员";
    }else if (self.proportion > 15000 && self.proportion <= 30000){
        str = [NSString stringWithFormat:@"%f",self.proportion/30000];
        gradeLabel.text = @"荣誉懂事";
    }else if (self.proportion >3000){
        str = @"1.000";
        gradeLabel.text = @"荣誉懂事";
    }
    
    CGFloat proporton = [str floatValue];
    
    ProgressView * gressView = [[ProgressView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width/3, kScreen_Width/3) backColor:CNaviColor color:CNaviColor proportion:proporton];
    
    gressView.center = view.center;
     gressView.centerY = view.centerY+10;
    //如果需要内容数据时使用
    gressView.data = [NSString stringWithFormat:@"%@",self.model.total_score];//当前积分
    if (self.model.total_score == nil || [self.model.total_score isKindOfClass:[NSNull class]]) {
        gressView.data = @"0.0000";
    }
    gressView.dataName  = @"sp";
    [gressView showContentData];
    
    
    [view addSubview:gressView];
    //    UILabel*label3=[view viewWithTag:3];
    //    label3.text=[NSString stringWithFormat:@"%@",self.model.my_score];//当前积分
    //    self.currentPointLabel=label3;
    //
    
    UIButton*button5=[view viewWithTag:5];
    //    label5.text=[NSString stringWithFormat:@"历史总积分：%@",self.model.total_score];
    [button5 setTitle:[NSString stringWithFormat:@"待结算积分：%@",self.model.settlement_score] forState:UIControlStateNormal];
    if (self.model.settlement_score == nil || [self.model.settlement_score isKindOfClass:[NSNull class]]) {
        [button5 setTitle:@"待结算积分:0.0000" forState:UIControlStateNormal];
    }
    UIButton*button6=[view viewWithTag:6];
    //    label6.text=[NSString stringWithFormat:@"待结算积分：%@",self.model.settlement_score];
    [button6 setTitle:[NSString stringWithFormat:@"可兑换积分：%@",self.model.my_score] forState:UIControlStateNormal];
    if (self.model.my_score == nil || [self.model.my_score isKindOfClass:[NSNull class]]) {
        [button6 setTitle:@"可兑换积分:0.0000" forState:UIControlStateNormal];
    }
  
}

-(void)addBottomImageView{
    UIImageView*bottomImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kScreen_Height-ACTUAL_HEIGHT(234) -40, kScreen_Width, ACTUAL_HEIGHT(234))];
    bottomImageView.image=[UIImage imageNamed:@"pointBottom"];
    [self.view addSubview:bottomImageView];
    UIButton * exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeBtn.frame= CGRectMake(0, 0, kScreen_Width - 40, 30);
    exchangeBtn.center = CGPointMake(kScreen_Width/2, kScreen_Height - 25);
    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeBtn setBackgroundColor:CNaviColor];
    exchangeBtn.layer.masksToBounds = YES;
    exchangeBtn.layer.cornerRadius = 5;
    
    [exchangeBtn addTarget:self action:@selector(exchangeJifen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeBtn];
}

- (void)exchangeJifen{
    MyLog(@"兑换积分");
    ExchangeViewController * exchangeVC = [[ExchangeViewController alloc]initWithNibName:@"ExchangeViewController" bundle:[NSBundle mainBundle]];
    exchangeVC.canUseGrade = self.model.my_score;
    exchangeVC.pay_scale = self.model.pay_scale;
    [self.navigationController pushViewController:exchangeVC animated:YES];
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

@end
