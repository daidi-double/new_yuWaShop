//
//  AddBankViewController.m
//  YuWaShop
//
//  Created by double on 17/3/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AddBankViewController.h"
#import "PassWordTextView.h"
#import "AddBankInfomationViewController.h"
#import<CommonCrypto/CommonDigest.h>
#import "YWLoginViewController.h"

@interface AddBankViewController ()
{
    NSString * markPasswork;
}
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;

@end

@implementation AddBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.check == 0) {
        self.remindLabel.text = @"请输入支付密码,验证身份";
    }else if (self.check == 1){
        self.remindLabel.text = @"请设置支付密码,以确认身份";
    }
    [self makeUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)makeUI{
    PassWordTextView * passWordView = [[PassWordTextView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - 40, 40)];
    WEAKSELF;
    passWordView.elementCount = 6;
    passWordView.center = CGPointMake(kScreen_Width/2, 144);
    passWordView.passwordDidChangeBlock = ^(NSString * password){
        
    };
    
    [self.view addSubview:passWordView];
    if (self.check == 0) {
        self.remindLabel.text = @"请输入支付密码,以确认身份";
        passWordView.passWordTextViewBlock= ^(NSString * password){
            markPasswork = password;
            [self requestPassword];
        };
    }else{
        
        passWordView.passWordTextViewBlock= ^(NSString * password){
            weakSelf.remindLabel.text = @"请再次输入密码";
            static int a = 0;
            if (a == 0) {
                
                markPasswork = password;
                a++;
            }else {
                MyLog(@"%@%@",markPasswork,password);
                if ([markPasswork isEqualToString:password]) {
                    MyLog(@"相同");
                    [self updataPassword];
                }else{
                    [JRToast showWithText:@"两次密码输入不一致,请重新设置" duration:1];
                    a = 0;
                    markPasswork = nil;
                }
            }
          
        };
        
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
//验证密码是否正确
- (void)requestPassword{
   
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_CHECKPASSWORD];
    NSString * passStr = [self md5:markPasswork];
    MyLog(@"str =%@",passStr);
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"user_type":@(2),@"payment_code":passStr};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        [JRToast showWithText:data[@"errorMessage"] duration:1];

        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            WEAKSELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AddBankInfomationViewController * addVC = [[AddBankInfomationViewController alloc]init];
//                addVC.isPubAccount = weakSelf.isPubAccount;
                [weakSelf.navigationController pushViewController:addVC animated:YES];
            });
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
//            if (number == 9) {
//                YWLoginViewController * vc = [[YWLoginViewController alloc]init];
//              ;
//            }

        }
    }];
    
    
}
- (void)updataPassword{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_UPPASSWORD];
    NSString * passStr = [self md5:markPasswork];
    MyLog(@"str =%@",passStr);
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"user_type":@(2),@"payment_code":passStr};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            WEAKSELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AddBankInfomationViewController * addVC = [[AddBankInfomationViewController alloc]init];
//                addVC.isPubAccount = weakSelf.isPubAccount;
                [weakSelf.navigationController pushViewController:addVC animated:YES];
            });
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
            if (number == 9) {
                YWLoginViewController * vc = [[YWLoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
    
}

//MD5加密

- (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
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
