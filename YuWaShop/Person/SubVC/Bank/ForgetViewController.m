//
//  ForgetViewController.m
//  YuWa
//
//  Created by double on 17/3/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ForgetViewController.h"
#import "ForgetPayPasswordTableViewCell.h"
#import "CheckPhoneCodeViewController.h"
#define FORGETCELL  @"ForgetPayPasswordTableViewCell"
@interface ForgetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *forgetTableView;
@property (nonatomic,copy)NSString * phoneStr;
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记支付密码";
    [self.forgetTableView registerNib:[UINib nibWithNibName:@"ForgetPayPasswordTableViewCell" bundle:nil] forCellReuseIdentifier:FORGETCELL];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        
        return 50;
    }
    return 0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, kScreen_Width-40, 45);
        btn.center = bgView.center;
        [btn setTitle:@"下一步" forState:UIControlStateNormal];
        [btn setBackgroundColor:CNaviColor];
        btn.layer.cornerRadius =5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btn];
        
        return bgView;
    }else{
        return nil;
    }
}
-(void)nextAction{
    
    if ([self.phoneStr isEqualToString:self.phone]) {
        [self requestPhoneCode];
        
    }else{
        [JRToast showWithText:@"您输入的电话号码与绑定的号码不一致" duration:1];
        return;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForgetPayPasswordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:FORGETCELL];
    if (!cell) {
        cell = [[ForgetPayPasswordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FORGETCELL];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.bankCardLabel.text = @"卡号";
        cell.status = 0;
        cell.infoTextfiled.placeholder = self.str;
    }else{
        if (indexPath.row == 0) {
            cell.bankCardLabel.text = @"姓名";
            cell.status = 1;
            cell.infoTextfiled.placeholder = self.user_name;
        }else{
            cell.bankCardLabel.text = @"手机号";
            cell.status = 2;
            cell.infoTextfiled.placeholder = @"请输入绑定时的手机号码";
            WEAKSELF;
            cell.phoneTextViewBlock = ^(NSString * phone){
                
                weakSelf.phoneStr = phone;
            };
        }
        
    }
    
    return cell;
}
- (void)requestPhoneCode{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_SENDPHONECODE];
    NSDictionary * pragrays = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"phone":self.phone,@"user_type":@(2)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrays compliation:^(id data, NSError *error) {
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                CheckPhoneCodeViewController * vc = [[CheckPhoneCodeViewController alloc]init];
                vc.phone = self.phone;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
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
