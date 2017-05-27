//
//  AgainSetPayPasswordViewController.m
//  YuWa
//
//  Created by double on 17/3/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AgainSetPayPasswordViewController.h"
#import "YWBankModel.h"
#import "ForgetViewController.h"
@interface AgainSetPayPasswordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *againTableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation AgainSetPayPasswordViewController
- (NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记支付密码";
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        
        return self.dataArr.count;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }else{
        return 2.f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40.f;
    }else{
        return 30.f;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
        bgView.backgroundColor = RGBCOLOR(240, 240, 240, 1);
        UILabel * textLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, kScreen_Width, 35)];
        textLbl.text = @"为安全起见，完成后已绑卡将自动解绑";
        textLbl.textColor = RGBCOLOR(132, 133, 135, 1);
        textLbl.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:textLbl];
        return bgView;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
    bgView.backgroundColor = RGBCOLOR(240, 240, 240, 1);
    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreen_Width/2, 30)];
    titleLbl.textColor = RGBCOLOR(132, 133, 135, 1);
    titleLbl.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:titleLbl];
    if (section == 0) {
        titleLbl.text = @"重新绑定银行卡找回";
    }else{
        titleLbl.y = 3;
        titleLbl.text = @"绑定新卡找回";
    }
    return bgView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        YWBankModel * model = self.dataArr[indexPath.row];
        ForgetViewController * vc = [[ForgetViewController alloc]init];
        NSString * bankCard = [model.bankCard substringFromIndex:15];
        vc.str = [NSString stringWithFormat:@"%@ %@ (%@)",model.bankName,model.bankCategory,bankCard];
        NSString * name = [model.userName substringFromIndex:model.userName.length-1];
        vc.user_name = [NSString stringWithFormat:@"**%@ (请输入完整姓名)",name];
        vc.phone = model.phoneNumber;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        [JRToast showWithText:@"尽请期待" duration:1];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"againCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"againCell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        if (self.dataArr.count>0) {
            
            YWBankModel * model = self.dataArr[indexPath.row];
            NSString * bankCard = [model.bankCard substringFromIndex:model.bankCard.length-4];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ (%@)",model.bankName,model.bankCategory,bankCard];
            
        }
        
    }else{
        cell.textLabel.text = @"添加银行卡";
    }
    return cell;
}

#pragma mark - Http
- (void)requestData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_MyBankList];
    NSDictionary * pragram = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_type":@(2)};
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager POST:urlStr parameters:pragram success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        MyLog(@"responseObject = %@",responseObject);
        [self.dataArr removeAllObjects];
        for (NSDictionary*dict in responseObject[@"data"]) {
            //                YWBankModel*model=[YWBankModel yy_modelWithDictionary:dict];
            YWBankModel * model = [YWBankModel bankModelWithDic:dict];
            [self.dataArr addObject:model];
            
        }
        [self.againTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
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
