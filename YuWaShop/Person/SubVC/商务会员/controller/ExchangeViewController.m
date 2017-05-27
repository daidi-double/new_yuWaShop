//
//  ExchangeViewController.m
//  YuWa
//
//  Created by double on 17/3/22.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ExchangeViewController.h"

@interface ExchangeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *exchangeGradeTextField;
@property (nonatomic,strong)UILabel * scoreLabel;

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分兑换";
    [self setUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)setUI{
    UIButton * sureExchangeBtn = [self.view viewWithTag:8];
    sureExchangeBtn.layer.masksToBounds = YES;
    sureExchangeBtn.layer.cornerRadius = 5;
    [self.exchangeGradeTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.scoreLabel = [self.view viewWithTag:3];
    self.scoreLabel.text = [NSString stringWithFormat:@"当前兑换比例为%@,可兑换为人民币金额为:0元",self.pay_scale];
    self.exchangeGradeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    
    
    UILabel * canUseGrade = [self.view viewWithTag:6];
    canUseGrade.text = self.canUseGrade;
}
//兑换全部
- (IBAction)exchangeAllGrade:(UIButton *)sender {
    self.exchangeGradeTextField.text = self.canUseGrade;
}
//确认兑换
- (IBAction)suerExchangeBtnAction:(UIButton *)sender {
    if ([self.canUseGrade floatValue] < [self.exchangeGradeTextField.text floatValue]) {
        [JRToast showWithText:@"输入的兑换积分大于可兑换积分" duration:1];
        return;
    }else if (self.exchangeGradeTextField.text == nil || [self.exchangeGradeTextField.text floatValue]<=0.00){
        [JRToast showWithText:@"请输入兑换积分" duration:1];
        return;
    }
    [self getMoneyDatas];
}
#pragma mark - 文本框内容改变
- (void)textChange:(UITextField *)textField {
    NSString *score = textField.text;
    
    NSArray * scoreAry = [self.pay_scale componentsSeparatedByString:@":"];
    CGFloat scoreNum = [scoreAry[1] floatValue];
    NSString * money = [NSString stringWithFormat:@"%f",[score floatValue] * scoreNum];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"当前兑换比例为%@,可兑换为人民币金额为:%@元",self.pay_scale,money];
    
}
- (void)showKeyboard {
    [self.exchangeGradeTextField becomeFirstResponder];
}

- (void)hideKeyboard {
    [self.exchangeGradeTextField resignFirstResponder];
}

#pragma mark  --getDatas
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hideKeyboard];//隐藏键盘
}
-(void)getMoneyDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_POINTGETMONEY];
    
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"score":self.exchangeGradeTextField.text,@"user_type":@(2)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [JRToast showWithText:data[@"msg"]];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
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
