//
//  SetPayPasswordViewController.m
//  YuWa
//
//  Created by double on 17/3/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SetPayPasswordViewController.h"
#import "PassWordTextView.h"
#import<CommonCrypto/CommonDigest.h>

@interface SetPayPasswordViewController ()
{
    NSString * markPassword;
}
@property (weak, nonatomic) IBOutlet UILabel *tiShiLabel;

@end

@implementation SetPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.title = @"设置支付密码";
    // Do any additional setup after loading the view from its nib.
}
- (void)makeUI{
    PassWordTextView * passWordView = [[PassWordTextView alloc] initWithFrame:CGRectMake(0, 190, kScreen_Width - 40, 40)];
    WEAKSELF;
    passWordView.elementCount = 6;
    passWordView.centerX = kScreen_Width/2;
    [self.view addSubview:passWordView];
    
    passWordView.passWordTextViewBlock= ^(NSString * password){
        weakSelf.tiShiLabel.text = @"请再次输入密码";
        static int a = 0;
        if (a == 0) {
            markPassword = nil;
            markPassword = password;
            a++;
        }else {
            
            if ([markPassword isEqualToString:password]) {
                MyLog(@"相同");
                [self setPayPassword];
            }else{
                [JRToast showWithText:@"两次密码输入不一致,请重新设置" duration:1];
                a = 0;
                markPassword = nil;
            }
        }
        
        
    };
    
}
- (void)setPayPassword{
    MyLog(@"code = %@",self.phoneCode);
    NSString * password = [self md5:markPassword];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_RESETPAYPASSWORD];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"phone":self.phone,@"user_type":@(2),@"mobile_code":self.phoneCode,@"payment_code":password};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            });
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
