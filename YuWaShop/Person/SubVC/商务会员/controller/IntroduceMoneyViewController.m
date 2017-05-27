//
//  IntroduceMoneyViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "IntroduceMoneyViewController.h"
#import "BusinessMoneyTableViewCell.h"
#import "IntroduceMoneyTableViewCell.h"

#import "JWTools.h"

#import "YWShowGetMoneyViewController.h"

#define CELL0    @"BusinessMoneyTableViewCell"
#define CELL1    @"IntroduceMoneyTableViewCell"

@interface IntroduceMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
@end

@implementation IntroduceMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"介绍分红";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:CELL0];
    [self.tableView registerNib:[UINib nibWithNibName:@"IntroduceMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:CELL1];

    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return 3;
    }
   
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section==0&&indexPath.row==0) {
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

        UIImageView*imageV=[cell viewWithTag:3];
        imageV.hidden=YES;
        //介绍分红
        imageView.image=[UIImage imageNamed:@"介绍分红"];
        titleLabel.text=@"介绍分红";
        topLabel.text=[NSString stringWithFormat:@"%@",self.model.rose_introduce];
        subLabel.text=@"近一周涨幅";
        timeLabel.text=[JWTools currentTime];
        
        totailLabel.text=self.model.total_introduce;
        todayLabel.text=self.model.today_introduce;
        waitLabel.text=self.model.settlement_introduce;
        if (self.model.total_introduce == nil) {
            totailLabel.text = @"0.00";
        }
        if (self.model.today_introduce == nil) {
            todayLabel.text = @"0.00";
        }
        if (self.model.settlement_introduce == nil) {
            waitLabel.text = @"0.00";
        }
        
        return cell;
        
    }else{

    
    IntroduceMoneyTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL1];
        cell.selectionStyle=NO;

    
        UILabel*titleLabel=[cell viewWithTag:1];
        UILabel*detailLabel=[cell viewWithTag:2];
        detailLabel.hidden=YES;
        
        if (indexPath.row==0) {
            titleLabel.text=@"介绍分红详情";
        }else if (indexPath.row==1){
            titleLabel.text=@"直接介绍分红详情";
        }else if (indexPath.row==2){
            titleLabel.text=@"间接介绍分红详情";
        }
        return cell;
    }
   
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1&&indexPath.row==0) {
        //总的详情
        YWShowGetMoneyViewController*vc=[[YWShowGetMoneyViewController alloc]init];
        vc.time=@"4";
        vc.type=@"0";
      
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section==1&&indexPath.row==1){
        YWShowGetMoneyViewController*vc=[[YWShowGetMoneyViewController alloc]init];
        vc.time=@"4";
        vc.type=@"5";
   
        [self.navigationController pushViewController:vc animated:YES];

        
    }else if (indexPath.section==1&&indexPath.row==2){
        YWShowGetMoneyViewController*vc=[[YWShowGetMoneyViewController alloc]init];
        vc.time=@"4";
        vc.type=@"6";

        [self.navigationController pushViewController:vc animated:YES];

        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        return 215;
    }else{
        return 44;
    }
    
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

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}



@end
