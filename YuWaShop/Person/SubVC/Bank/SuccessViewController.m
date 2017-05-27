//
//  SuccessViewController.m
//  YuWaShop
//
//  Created by double on 17/3/30.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SuccessViewController.h"

@interface SuccessViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UILabel *todayMoneyMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *everyMoneyMaxLabel;
@property (nonatomic,strong)NSString * phoneCode;
@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyLog(@"phoneNumber = %@",self.phoneNumber);
        [self setTitle];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
-(void)touchAction{

    if (self.state == 1 ) {
        UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * relieve = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestPhoneCode];
        }];
        [alerVC addAction:relieve];
        [alerVC addAction:cancel];
        [self presentViewController:alerVC animated:YES completion:nil];
    }

}
-(void)setTitle{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 20, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"NaviBack"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAtion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    UIImageView * imageView = [self.view viewWithTag:1];
    imageView.image = [UIImage imageNamed:self.bankName];

    UILabel * bankNameLabel = [self.view viewWithTag:2];
    bankNameLabel.text = [NSString stringWithFormat:@"%@%@",self.bankName,self.bankCategory];

//    if (self.bankCard.length<19) {
//        self.bankCard = @"";
//    }else{
     self.bankCard =  [self.bankCard substringFromIndex:self.bankCard.length-4];
//    }
    UILabel * bankNumberLabel = [self.view viewWithTag:3];
    bankNumberLabel.text = [NSString stringWithFormat:@"**** ******* **** %@",self.bankCard];

    self.BGView.layer.cornerRadius =5;
    self.BGView.layer.masksToBounds = YES;

    UIView * touchView = [self.view viewWithTag:13];

    UITapGestureRecognizer * touchTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAction)];
    touchTap.delegate = self;
    touchTap.numberOfTapsRequired = 1;
    touchTap.numberOfTouchesRequired = 1;
    [touchView addGestureRecognizer:touchTap];
}

-(void)relieveBankCard{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_RELIEVEBANK];
    if (self.phoneCode == nil || [self.phoneCode isEqualToString:@""]) {
        [JRToast showWithText:@"请输入验证码" duration:1];
        return;
    }
    NSDictionary * pragram = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_type":@(2),@"id":self.bank_id,@"moible_code":self.phoneCode};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        MyLog(@"data2 %@",data);
        NSInteger errorCode = [data[@"errorCode"] integerValue];

        if (errorCode == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }
    }];
}
- (void)requestPhoneCode{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_SENDPHONECODE];
    
    NSDictionary * pragram = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"phone":self.phoneNumber,@"user_type":@(2)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        MyLog(@"error = %@",error);

        NSInteger errorCode = [data[@"errorCode"] integerValue];

        if (errorCode == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            UIAlertController * alerVC = [UIAlertController alertControllerWithTitle:@"请输入验证码" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alerVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"请输入验证码";

                    }];
            UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction * relieve = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *userEmail = alerVC.textFields.firstObject;
                self.phoneCode = userEmail.text;
                [self relieveBankCard];
            }];
            [alerVC addAction:relieve];
            [alerVC addAction:cancel];

            [self presentViewController:alerVC animated:YES completion:nil];


        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1];
        }


    }];


}

- (void)backAtion:(UIButton *)sender {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
