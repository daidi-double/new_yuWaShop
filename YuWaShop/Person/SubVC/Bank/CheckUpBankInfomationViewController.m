//
//  CheckUpBankInfomationViewController.m
//  YuWaShop
//
//  Created by double on 17/3/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CheckUpBankInfomationViewController.h"
#import "SuccessViewController.h"

@interface CheckUpBankInfomationViewController ()
{
    UITextField * securityCodeTF;//验证码
    
}
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic,strong)UIButton * sendSecurityBtn;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger time;

@end

@implementation CheckUpBankInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUIInfo];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer=nil;
}
- (void)setUIInfo{
    
    UILabel * explainLabel = [self.view viewWithTag:1];
   NSString * phoneFourStr = [self.phoneNumber substringFromIndex:7];
    NSString * phoneThreeStr = [self.phoneNumber substringToIndex:3];
    explainLabel.text = [NSString stringWithFormat:@"绑定银行卡需要短信验证,验证码已发送至手机:%@****%@请按提示操作",phoneThreeStr,phoneFourStr];
    securityCodeTF = [self.view viewWithTag:2];
    securityCodeTF.layer.cornerRadius = 5;
    securityCodeTF.layer.masksToBounds = YES;
    securityCodeTF.layer.borderColor= CNaviColor.CGColor;
    
    securityCodeTF.layer.borderWidth= 1.0f;
    
    _sendSecurityBtn = [self.view viewWithTag:3];
    
    _sendSecurityBtn.layer.masksToBounds = YES;
    _sendSecurityBtn.layer.cornerRadius = 6;
    
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 6;
    

}

- (IBAction)touchToNextAction:(UIButton *)sender {
    [self requestBankCode];
    
}

//获取验证码
- (IBAction)getSecurityAction:(UIButton *)sender {
    [self requesData];
  
}

- (void)securityCodeBtnTextSet{//重置文字
    if (self.time <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        [self.sendSecurityBtn setTitle:[NSString stringWithFormat:@"重获验证码"] forState:UIControlStateNormal];
        self.sendSecurityBtn.backgroundColor = CNaviColor;
        [self.sendSecurityBtn setUserInteractionEnabled:YES];
        return;
    }
    [self.sendSecurityBtn setTitle:[NSString stringWithFormat:@"获取中(%zi)s",self.time] forState:UIControlStateNormal];
    self.time--;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    //取消第一响应者
    [securityCodeTF resignFirstResponder];

    return YES;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//请求验证码
- (void)requesData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_shopAdmin_PhoneCode];
    NSDictionary * pragram = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"phone":self.phoneNumber,@"user_type":@(2)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        MyLog(@"error = %@",error);
        
        NSInteger errorCode = [data[@"errorCode"] integerValue];
        
        if (errorCode == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            [self.sendSecurityBtn setUserInteractionEnabled:NO];
            self.sendSecurityBtn.backgroundColor = [UIColor grayColor];
            [self securityCodeBtnTextSet];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(securityCodeBtnTextSet) userInfo:nil repeats:YES];
            
        }
        
        
    }];
    
    
}


- (void)requestBankCode{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_AddMyBank];
//6217231408000667428
//    MyLog(@"card:_bankNumber= %@",_bankNumber);
//    MyLog(@"card_type = %@",_bankCategory);
//    MyLog(@"mobile = %@",_phoneNumber);
//    MyLog(@"moible_code = %@",securityCodeTF.text);
//    MyLog(@"user_name = %@",_userName);
//    MyLog(@"user_id = %ld",(long)[UserSession instance].uid);
//    MyLog(@"device_id = %@",[JWTools getUUID]);
//    MyLog(@"token = %@",[UserSession instance].token);
//    MyLog(@"ispubuaccount = %d",self.isPubAccount);
    NSDictionary * pragram = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_type":@(2),@"card":_bankNumber,@"card_type":_bankCategory,@"phone":_phoneNumber,@"moible_code":securityCodeTF.text,@"user_name":_userName};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        NSInteger errorCode = [data[@"errorCode"] integerValue];
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",data);
        if (errorCode == 0) {
            SuccessViewController * successVC = [[SuccessViewController alloc]init];
            NSArray *array = [self.bankCategory componentsSeparatedByString:@"银行"];
            successVC.bankName = [NSString stringWithFormat:@"%@银行",array[0]];
            successVC.bankCategory = array[1];
            successVC.bankCard = self.bankNumber;
            [self.navigationController pushViewController:successVC animated:YES];
        }else{
            [JRToast showWithText:data[@"errorMessage"]duration:1];
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
