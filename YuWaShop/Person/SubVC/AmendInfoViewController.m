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


@end

@implementation AmendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    switch (self.status) {
        case 0:
            self.title = @"修改账号";
            self.passwordBGView.hidden = YES;
            self.iPhoneBGView.hidden = YES;
            break;
        
        case 1:
            self.title = @"修改密码";
            self.accountBGView.hidden = YES;
            self.iPhoneBGView.hidden = YES;
            break;
            
        default:
            self.title = @"修改手机号";
            self.passwordBGView.hidden = YES;
            self.accountBGView.hidden = YES;
            break;
    }
    
}


//获取验证码
- (IBAction)getCode:(UIButton *)sender {
}
//提交，下一步
- (IBAction)submitAction:(UIButton *)sender {
    switch (self.status) {
        case 0:

            break;
            
        case 1:

            break;
            
        default:

            break;
    }
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
