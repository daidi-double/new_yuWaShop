//
//  YWOderDetaleViewController.m
//  YuWaShop
//
//  Created by double on 17/4/1.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWOderDetaleViewController.h"
#import "OrderDetailModel.h"
#import "YWLoginViewController.h"
@interface YWOderDetaleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *OrderDetaleTableView;
@property (nonatomic,strong)NSMutableArray * dataAry;
@end

@implementation YWOderDetaleViewController

- (NSMutableArray*)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
        
    }
    return _dataAry;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   self.OrderDetaleTableView.backgroundColor = RGBCOLOR(234, 234, 234, 1);
    if (self.status == 0) {
        [self getDatas];//近期账单详情
        
        self.title = @"账单明细";
    }else{
        [self getPayListDatas];//闪付详情
        self.title = @"订单详情";
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderDetailModel * model;
    if (self.dataAry.count > 0) {
        model = self.dataAry[0];
        
    }
    if (section == 0) {
        return 3;
    }else{
        if (model.is_coupon == 0) {
        if (self.status == 0) {
                return 8;
        }else{
            return 7;
        }
        }else{
            if (self.status == 1) {
                return 11;
            }else{
                return 10;
        }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            return 80;
        }
    }
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 15;
    }
    return 0.01f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell0"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"orderCell0"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = RGBCOLOR(114, 115, 114, 1);
    cell.detailTextLabel.textColor = RGBCOLOR(114, 115, 114, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    if (self.dataAry.count>0) {
        OrderDetailModel * model = self.dataAry[0];
    if (indexPath.section == 0) {
        cell.textLabel.textColor = RGBCOLOR(95, 96, 98, 1);
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (indexPath.row == 0) {
            if (self.status == 0) {
                cell.textLabel.text = @"款额类型:";
                cell.detailTextLabel.text = model.type;
                
            }else{
                cell.textLabel.text = @"订单号:";
                cell.detailTextLabel.text = model.order_sn;
            }
        }else if (indexPath.row == 1){
            if (self.status == 0) {
                
                cell.textLabel.text = @"交易状态:";
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"待结算:%@天%@小时%@分",];
                cell.detailTextLabel.text = model.account_status;
            }else{
                cell.textLabel.text = @"订单状态:";
                cell.detailTextLabel.text = model.order_type;

            }
        }else{
             if (self.status == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"￥%@",model.seller_money];
                 if ([model.type containsString:@"介绍分红"] || [model.type containsString:@"介绍积分"]) {
                     cell.textLabel.text = [NSString stringWithFormat:@"%@",model.money];
                 }
            cell.textLabel.textColor = RGBCOLOR(249, 207, 112, 1);
            cell.textLabel.font = [UIFont systemFontOfSize:35];
            
            cell.detailTextLabel.text = @"实际收款额";
             }else{
                 cell.textLabel.text = [NSString stringWithFormat:@"￥%@",model.total_money];
                 cell.textLabel.textColor = RGBCOLOR(229, 193, 64, 1);
                 cell.textLabel.font = [UIFont systemFontOfSize:35];
                 
                 cell.detailTextLabel.text = @"(订单总额)";
             }
        }
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = RGBCOLOR(132, 132 ,132, 1);
        cell.detailTextLabel.textColor = RGBCOLOR(182, 182 ,182, 1);
        if (indexPath.row == 0) {
            cell.textLabel.text = @"明细";
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(16, 29.5, cell.width-32, 0.5)];
            line.backgroundColor = RGBCOLOR(240, 242, 240, 1);
            [cell.contentView addSubview:line];
        }else{
            if (indexPath.row == 1) {
                if (self.status == 0) {
                    
                    cell.textLabel.text = @"订单号:";
                    cell.detailTextLabel.text = model.order_sn;
                }else{
                    cell.textLabel.text = @"商品:";
                    cell.detailTextLabel.text = model.order_sn;

                }
            }else if (indexPath.row == 2){
               cell.textLabel.text = @"下单时间:";
                cell.detailTextLabel.text = [self distanceTimeWithBeforeTime:model.create_time];
            }else if (indexPath.row == 3){
                if (self.status == 0) {
                    cell.textLabel.text = @"订单总额:";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",model.total_money];
                }else{
                    cell.textLabel.text = @"实际折扣:";
                    NSString * cut = [model.discount substringFromIndex:2];
                    CGFloat cutNum = [cut floatValue]/10;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f折",cutNum];
                }
            }else if (indexPath.row == 4){
                if (self.status == 0) {
                    cell.textLabel.text = @"实际折扣:";
                    NSString * cut = [model.discount substringFromIndex:2];
                    CGFloat cutNum = [cut floatValue]/10;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f折",cutNum];
                }else{
                    cell.textLabel.text = @"参与折扣金额:";
                     cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",model.discount_money];
                }
            }else if (indexPath.row == 5){
                if (self.status == 0) {
                    cell.textLabel.text = @"参与折扣金额:";
                   cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",model.discount_money];
                }else{
                    cell.textLabel.text = @"实际收款:";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",model.seller_money];
                }
            }else if (indexPath.row == 6){
                if (model.is_coupon == 0) {
                    
                    if (self.status == 0) {
                        cell.textLabel.text = @"第三方支付手续费:";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",model.counter_fee_money];
                    }else{
                        cell.textLabel.text = @"交易状态:";
                        cell.detailTextLabel.text = model.order_type;
                    }
                }else{
                        cell.textLabel.text = @"已使用优惠券";

                }
            }else if (indexPath.row == 7){
                if (model.is_coupon == 0) {
                    
                    if (self.status == 0) {
                        cell.textLabel.text = @"平台抽成:";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",model.plateform_income_money];
                    }else{
                        
                    }
                }else{
                        cell.textLabel.text = @"优惠券金额:";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",model.coupon_money] ;
                   
                }
            }else if (indexPath.row == 8){
                if (model.is_coupon == 1) {
                    cell.textLabel.text = @"优惠券类型:";
                    if (model.coupon_type ==1) {
                        
                        cell.detailTextLabel.text =@"商家自发券";
                    }else{
                        cell.detailTextLabel.text =@"平台发放券";
                    }
                }
            }else if (indexPath.row == 9){
                
                if (model.is_coupon == 1) {
                    if (self.status == 0) {
                        cell.textLabel.text = @"第三方支付手续费:";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",model.counter_fee_money];
                    }else{
                        cell.textLabel.text = @"交易状态:";
                        cell.detailTextLabel.text = model.order_type;
                    }
 
                }
            }else if (indexPath.row == 10){
                if (model.is_coupon == 1) {
                    
                    if (self.status == 0) {
                        cell.textLabel.text = @"平台抽成:";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",model.plateform_income_money ];
                    }
                }
            }
        }
    }
    
    }
    return cell;
}
- (NSString *)distanceTimeWithBeforeTime:(double)beTime
{

    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * distanceStr = [df stringFromDate:beDate];
    return distanceStr;
}

#pragma mark  --Datas
-(void)getDatas{
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETDETAIL];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":self.orderID};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
                OrderDetailModel*model=[OrderDetailModel yy_modelWithDictionary:data[@"data"]];
                [self.dataAry addObject:model];

            
            [self.OrderDetaleTableView reloadData];
            
        }else if ([errorCode isEqualToString:@"9"]){
            
            [JRToast showWithText:@"身份已过期,请重新登入" duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                YWLoginViewController *vc = [[YWLoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
//        [self.OrderDetaleTableView.mj_header endRefreshing];
//        [self.OrderDetaleTableView.mj_footer endRefreshing];
//        
        
    }];
    
}
-(void)getPayListDatas{
    
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_ORDERDTEAIL];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"order_id":self.orderID};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            
            OrderDetailModel*model=[OrderDetailModel yy_modelWithDictionary:data[@"data"]];
                [self.dataAry addObject:model];
            
            
            [self.OrderDetaleTableView reloadData];
            
        }else if ([errorCode isEqualToString:@"9"]){
            
            [JRToast showWithText:@"身份已过期,请重新登入" duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                YWLoginViewController *vc = [[YWLoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            });
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        
        //        [self.OrderDetaleTableView.mj_header endRefreshing];
        //        [self.OrderDetaleTableView.mj_footer endRefreshing];
        //        
        
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

@end
