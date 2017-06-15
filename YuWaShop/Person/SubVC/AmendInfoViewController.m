//
//  AmendInfoViewController.m
//  雨掌柜
//
//  Created by double on 17/6/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AmendInfoViewController.h"

@interface AmendInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


/* 修改手机号 */
@property (weak, nonatomic) IBOutlet UIView *iPhoneBGView;
@property (weak, nonatomic) IBOutlet UITextField *IphoneNumberTextFild;
@property (weak, nonatomic) IBOutlet UILabel *oldIphoneNumberLabel;//原手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTextFild;//验证码
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;


/* 修改密码 */
@property (weak, nonatomic) IBOutlet UIView *passwordBGView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextFild;
@property (weak, nonatomic) IBOutlet UITextField *nePasswordTextFild;
@property (weak, nonatomic) IBOutlet UITextField *againNewPasswordTextFild;


/* 修改账号 */
@property (weak, nonatomic) IBOutlet UIView *accountBGView;
@property (weak, nonatomic) IBOutlet UITextField *accountTextFild;
/* 添加手机号  */
@property (weak, nonatomic) IBOutlet UIView *addIphoneBGView;
@property (weak, nonatomic) IBOutlet UITextField *addiphonePassword;
@property (weak, nonatomic) IBOutlet UITextField *addIphoneTextFild;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger time;

@end

@implementation AmendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    self.time = 60;
    switch (self.status) {
        case 0:
            self.title = @"修改账号";
            self.passwordBGView.hidden = YES;
            self.iPhoneBGView.hidden = YES;
            self.addIphoneBGView.hidden = YES;
            break;
            
        case 1:
            self.title = @"修改密码";
            self.accountBGView.hidden = YES;
            self.iPhoneBGView.hidden = YES;
            self.addIphoneBGView.hidden = YES;
            break;
        case 2:
            self.title = @"修改手机号";
            self.passwordBGView.hidden = YES;
            self.accountBGView.hidden = YES;
            self.addIphoneBGView.hidden = YES;
            break;
        default:
            self.title = @"添加手机号";
            self.passwordBGView.hidden = YES;
            self.accountBGView.hidden = YES;
            self.iPhoneBGView.hidden = YES;
            break;
    }
    self.oldIphoneNumberLabel.text = self.iphone;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer=nil;
}

- (void)securityCodeBtnTextSet{//重置文字
    if (self.time <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重获验证码"] forState:UIControlStateNormal];
        [self.getCodeBtn setUserInteractionEnabled:YES];
        return;
    }
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"获取中(%zi)s",self.time] forState:UIControlStateNormal];
    
    self.time--;
}

//判断两次密码是否一致
- (IBAction)juagePassword:(UITextField *)sender {
    
}


//获取验证码
- (IBAction)getCode:(UIButton *)sender {
    [self requestRegisterCodeWithCount:0];
}
//提交，下一步
- (IBAction)submitAction:(UIButton *)sender {
    switch (self.status) {
        case 0:
            [self changeAccountData];
            break;
            
        case 1:
            [self changeAccountPassword];
            break;
            
        case 2:
            [self changeAccountPhone];
            break;
            
        default:
            [self addAccountPhone];
            break;
    }
}
//获取验证码
- (void)requestRegisterCodeWithCount:(NSInteger)count{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGION_CODE];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"tpl_id":@(22490),@"phone":self.iphone};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@~~~%@",pragarms,urlStr);
        MyLog(@"获取验证码%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            [self.getCodeBtn setUserInteractionEnabled:NO];
            [self securityCodeBtnTextSet];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(securityCodeBtnTextSet) userInfo:nil repeats:YES];
            
        }else{
            
            [JRToast showWithText:data[@"errorMessage"] duration:1];
            
        }
        
    }];
}

//修改账号信息
- (void)changeAccountData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_CHANGECHILDACCOUNTNAME];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"edit_name":_accountTextFild.text};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@~~~%@",pragarms,urlStr);
        MyLog(@"修改账号%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [JRToast showWithText:data[@"errorMessage"] duration:1];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
}
//修改密码
- (void)changeAccountPassword{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_CHANGECHILDACCOUNTPASSWORD];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"password":self.oldPasswordTextFild.text,@"new_password":self.nePasswordTextFild.text,@"re_password":self.againNewPasswordTextFild.text};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@~~~%@",pragarms,urlStr);
        MyLog(@"修改密码%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [JRToast showWithText:data[@"errorMessage"] duration:1];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
}
//修改手机号
- (void)changeAccountPhone{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_CHANGECHILDACCOUNTIPHONE];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"phone":self.oldIphoneNumberLabel.text,@"edit_phone":self.IphoneNumberTextFild.text,@"code":self.codeTextFild.text};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@~~~%@",pragarms,urlStr);
        MyLog(@"修改手机号%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [JRToast showWithText:data[@"errorMessage"] duration:1];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
}
//添加手机号
- (void)addAccountPhone{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_ADDIPHONEACCOUNT];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"password":self.addiphonePassword.text,@"add_phone":self.addIphoneTextFild.text};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@~~~%@",pragarms,urlStr);
        MyLog(@"添加手机号%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [JRToast showWithText:data[@"errorMessage"] duration:1];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
