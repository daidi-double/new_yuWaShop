//
//  YWRegisterViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/19.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWRegisterViewController.h"
#import "JPUSHService.h"
#import "YWComfiredViewController.h"
#import "VIPTabBarController.h"
#import "YWComfiredAgreeViewController.h"

@interface YWRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inviteTextField;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *secuirtyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordtextField;

@property (weak, nonatomic) IBOutlet UIButton *secuirtyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger time;

@end

@implementation YWRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self makeUI];
    self.time = 60;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
//    [self.accountTextField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer=nil;
}

- (void)makeUI{
    self.accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.secuirtyCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.passwordtextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.inviteTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入邀请码(选填)" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.passwordtextField.secureTextEntry = YES;
    
    
    self.passwordtextField.secureTextEntry = YES;
    self.registerBtn.layer.cornerRadius = 22.f;
    self.registerBtn.layer.masksToBounds = YES;
    
    self.secuirtyCodeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.secuirtyCodeBtn.layer.borderWidth = 1;
    self.secuirtyCodeBtn.layer.cornerRadius = 10.f;
    self.secuirtyCodeBtn.layer.masksToBounds = YES;
    [self.agreeBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.agreeBtn setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
    self.agreeBtn.selected = NO;
}

- (BOOL)canSendRequset{
    if (![JWTools checkTelNumber:self.accountTextField.text]) {
        [self showHUDWithStr:@"请输入11位手机号" withSuccess:NO];
        return NO;
    }else if ([self.secuirtyCodeTextField.text isEqualToString:@""]){
        [self showHUDWithStr:@"请输入验证码" withSuccess:NO];
        return NO;
    }else if (![JWTools isRightPassWordWithStr:self.passwordtextField.text]){
        [self showHUDWithStr:@"请输入6-16位密码" withSuccess:NO];
        return NO;
    }else if (self.agreeBtn.selected == NO){
        [self showHUDWithStr:@"请同意雨掌柜商户协议" withSuccess:NO];
        return NO;
    }
    return YES;
}

- (IBAction)securityBtnAction:(id)sender {
    if (![JWTools checkTelNumber:self.accountTextField.text]) {
        [self showHUDWithStr:@"请输入11位手机号" withSuccess:NO];
        return ;
    }
    [self requestRegisterCodeWithCount:0];
}
- (IBAction)seeAgreement:(UIButton *)sender {
    YWComfiredAgreeViewController * agreementVC = [[YWComfiredAgreeViewController alloc]init];
    agreementVC.staus = 1;
    WEAKSELF;
    agreementVC.agreeBlock = ^(){
        
        weakSelf.agreeBtn.selected = YES;
        
    };

    [self.navigationController pushViewController:agreementVC animated:YES];
}
- (IBAction)agreeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)registerBtnAction:(id)sender {
    if ([self canSendRequset]) {
        [self requestRegisterWithAccount:self.accountTextField.text withPassword:self.passwordtextField.text  withCode:self.secuirtyCodeTextField.text];
    }
}

- (void)securityCodeBtnTextSet{//重置文字
    if (self.time <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        [self.secuirtyCodeBtn setTitle:[NSString stringWithFormat:@"重获验证码"] forState:UIControlStateNormal];
        [self.secuirtyCodeBtn setUserInteractionEnabled:YES];
        return;
    }
    [self.secuirtyCodeBtn setTitle:[NSString stringWithFormat:@"获取中(%zi)s",self.time] forState:UIControlStateNormal];
    self.time--;
}

#pragma mark  - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self canSendRequset]) {
        [textField resignFirstResponder];
        [self requestRegisterWithAccount:self.accountTextField.text withPassword:self.passwordtextField.text  withCode:self.secuirtyCodeTextField.text];
    }
    return YES;
}

#pragma mark - Http
- (void)requestRegisterWithAccount:(NSString *)account withPassword:(NSString *)password withCode:(NSString *)code{
    NSDictionary * pragram = @{@"phone":account,@"password":password,@"code":code};
    
    [[HttpObject manager]postDataWithType:YuWaType_Register withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession saveUserLoginWithAccount:account withPassword:password];
        [UserSession saveUserInfoWithDic:responsObj[@"data"]];
        [self showHUDWithStr:@"注册成功" withSuccess:YES];
        EMError *error = [[EMClient sharedClient] registerWithUsername:[NSString stringWithFormat:@"2%@",account] password:account];
        if (error==nil) {
            MyLog(@"环信注册成功");
            BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
            if (!isAutoLogin) {
                EMError *errorLog = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"2%@",account] password:password];
                if (errorLog==nil){
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                    MyLog(@"环信登录成功");
                }
            }
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        rootTabBarVC.selectedIndex = 0;
        rootTabBarVC.hidesBottomBarWhenPushed = NO;
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:NO];
        self.time = 0;// 失败后重置验证码
        [self securityCodeBtnTextSet];
    }];
}
- (void)requestRegisterCodeWithCount:(NSInteger)count{
    NSDictionary * pragram = @{@"phone":self.accountTextField.text,@"tpl_id":@22490};
    [[HttpObject manager] postNoHudWithType:YuWaType_Register_Code withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.secuirtyCodeBtn setUserInteractionEnabled:NO];
        [self securityCodeBtnTextSet];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(securityCodeBtnTextSet) userInfo:nil repeats:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
