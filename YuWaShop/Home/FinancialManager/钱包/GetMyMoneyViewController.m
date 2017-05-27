//
//  GetMyMoneyViewController.m
//  YuWa
//
//  Created by double on 17/3/27.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "GetMyMoneyViewController.h"
#import "YWBankViewController.h"
#import "GetMoneyToBankViewController.h"
@interface GetMyMoneyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputMoneyTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseBankCardBtn;
@property (nonatomic,copy)NSString * bankName;
@property (nonatomic,copy)NSString * bankCard;
@property (nonatomic,copy)NSString * bankCardID;
@property (nonatomic,copy)NSString * userName;
@end

@implementation GetMyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.cornerRadius = 5;
    self.title = @"收益提现";
    UIView * BGView = [self.view viewWithTag:2];
    BGView.layer.masksToBounds = YES;
    BGView.layer.cornerRadius = 6;
    UILabel * moneyLabel = [self.view viewWithTag:4];
    
    moneyLabel.text = [NSString stringWithFormat:@"收益金额￥%@,",self.money];
//    if ([UserSession instance].bankName == nil || [[UserSession instance].bankCard isEqualToString:@""]) {
//        
//        [self.chooseBankCardBtn setTitle:@"请选择银行卡" forState:UIControlStateNormal];
//    }else{
//        NSString * bankStr;
//        if ([UserSession instance].bankCard.length <15) {
//            bankStr = @"";
//        }
//        bankStr = [[UserSession instance].bankCard substringFromIndex:15];
//        [self.chooseBankCardBtn setTitle:[NSString stringWithFormat:@"%@(%@)",[UserSession instance].bankName ,bankStr] forState:UIControlStateNormal];
//    }
    
}
- (IBAction)chooseBank:(UIButton *)sender {
    //选择银行卡
    
    YWBankViewController * bankVC = [[YWBankViewController alloc]init];
    WEAKSELF;
    bankVC.status = 1;
    bankVC.getBankCardBlock = ^(NSString * bankName,NSString * bankCard,NSString * bankCardID,NSString * userName){
        weakSelf.bankName = bankName;
        weakSelf.bankCard = bankCard;
        weakSelf.bankCardID = bankCardID;
        weakSelf.userName = userName;

        NSString * card = [bankCard substringFromIndex:bankCard.length - 4];
        
        [weakSelf.chooseBankCardBtn setTitle:[NSString stringWithFormat:@"%@(%@)",bankName,card] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:bankVC animated:YES];
    
}
- (IBAction)getAllMoney:(UIButton *)sender {
    self.inputMoneyTF.text = [NSString stringWithFormat:@"%@",self.money];
    
}
- (IBAction)nextAction:(UIButton *)sender {
    if (self.bankCardID == nil ||self.bankName == nil) {
        [JRToast showWithText:@"请选择银行卡" duration:1];
        return;
    }
    if (self.inputMoneyTF.text == nil || [self.inputMoneyTF.text floatValue] <=0) {
        [JRToast showWithText:@"请输入提现金额" duration:1];
        return;
    }
    if ([self.inputMoneyTF.text floatValue]>[self.money floatValue]) {
         [JRToast showWithText:@"提现金额大于账户可提现金额" duration:1];
        return;
    }
    [self requestData];

}
- (void)requestData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETMYTOBANK];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"user_type":@(2),@"token":[UserSession instance].token, @"name":self.userName,@"money":self.inputMoneyTF.text,@"bank":self.bankName,@"card":self.bankCard};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            MyLog(@"data = %@",data);
            
            [JRToast showWithText:data[@"data"] duration:1];
            GetMoneyToBankViewController * getVC = [[GetMoneyToBankViewController alloc]init];
            getVC.user_card_id = self.bankCardID;
            getVC.money = self.inputMoneyTF.text;
            getVC.bankName = self.bankName;
            getVC.bankCard = self.bankCard;
           
            [self.navigationController pushViewController:getVC animated:YES];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]duration:1];
        }
    }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
