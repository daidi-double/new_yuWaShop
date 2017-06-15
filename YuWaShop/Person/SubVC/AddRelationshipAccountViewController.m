//
//  AddRelationshipAccountViewController.m
//  雨掌柜
//
//  Created by double on 17/6/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AddRelationshipAccountViewController.h"

@interface AddRelationshipAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextFild;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFild;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation AddRelationshipAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加关联账号";
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    
}
- (IBAction)accountAction:(UITextField *)sender {
    [sender becomeFirstResponder];
}
- (IBAction)passwordAction:(UITextField *)sender {
    [sender becomeFirstResponder];
    
}
//保存
- (IBAction)submitBtnAction:(UIButton *)sender {
    if ([self.accountTextFild.text isEqualToString:@""]) {
        [JRToast showWithText:@"请输入账号" duration:2];
        return;
    }else if ([self.passwordTextFild.text isEqualToString:@""]){
        [JRToast showWithText:@"请输入密码" duration:2];
        return;
    }
    [self addRequestAccountData];
}

- (void)addRequestAccountData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_ADDRELATIONACCOUNT];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"phone":self.accountTextFild.text,@"password":self.passwordTextFild.text};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"参数%@~~~~%@",pragrams,urlStr);
        MyLog(@"添加关联账号%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [JRToast showWithText:data[@"errorMessage"] duration:2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:2];
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
