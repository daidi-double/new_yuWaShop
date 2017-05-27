//
//  CheckPhoneCodeViewController.m
//  YuWa
//
//  Created by double on 17/3/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "CheckPhoneCodeViewController.h"
#import "SetPayPasswordViewController.h"
@interface CheckPhoneCodeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,strong)NSTimer * timer;
@end

@implementation CheckPhoneCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证手机号";
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5;
    NSString * qianStr = [self.phone substringToIndex:3];
    NSString * houStr = [self.phone substringFromIndex:7];
    self.titleLabel.text = [NSString stringWithFormat:@"绑定银行卡需要短信验证,验证码已发送至手机:%@****%@请按提示操作",qianStr,houStr];
    
}
- (void)securityCodeBtnTextSet{//重置文字
    if (self.time <= 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.time = 60;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重获验证码"] forState:UIControlStateNormal];
        [self.getCodeBtn setBackgroundColor:[UIColor whiteColor]];
        [self.getCodeBtn setUserInteractionEnabled:YES];
        return;
    }
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"获取中(%zi)s",self.time] forState:UIControlStateNormal];
    self.time--;
}

- (IBAction)getCodeAction:(id)sender {
    [self requesData];
}
- (IBAction)nextAction:(UIButton *)sender {
    if (self.codeTF.text.length<1) {
        [JRToast showWithText:@"请输入验证码" duration:1];
        return;
    }
    SetPayPasswordViewController * vc = [[SetPayPasswordViewController alloc]init];
    
    vc.phoneCode = self.codeTF.text;
    vc.phone = self.phone;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)requesData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_SENDPHONECODE];
    NSDictionary * pragram = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"phone":self.phone,@"user_type":@(2)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        MyLog(@"error = %@",error);
        
        NSInteger errorCode = [data[@"errorCode"] integerValue];
        
        if (errorCode == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            [self.getCodeBtn setUserInteractionEnabled:NO];
            self.getCodeBtn.backgroundColor = [UIColor grayColor];
            [self securityCodeBtnTextSet];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(securityCodeBtnTextSet) userInfo:nil repeats:YES];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
        
        
    }];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
