//
//  AddBankCategoryViewController.m
//  YuWaShop
//
//  Created by double on 17/3/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AddBankCategoryViewController.h"
#import "YWComfiredAgreeViewController.h"
#import "BankCategoryPickerView.h"
#import "CheckUpBankInfomationViewController.h"
#import "YWLoginViewController.h"
@interface AddBankCategoryViewController ()<UIGestureRecognizerDelegate>
{
    UIView * userView;
}
@property (nonatomic,strong)UIView * bgView;
@property (weak, nonatomic) IBOutlet UIButton *bankCategoryBtn;//银行名称

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;//手机号码
@property (weak, nonatomic) IBOutlet UITextField *timeTF;//有效期
@property (nonatomic,strong) BankCategoryPickerView * categoryPickerView;

@end

@implementation AddBankCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.title = @"填写银行卡信息";
   
}
- (void)makeUI{
    
    UIButton * nextBtn = [self.view viewWithTag:11];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5;
    
    UIView * touchView = [self.view viewWithTag:15];
    touchView.hidden = YES;
    UITapGestureRecognizer * tapTime = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTimeAction:)];
    tapTime.delegate = self;
    [touchView addGestureRecognizer:tapTime];
    
    _categoryPickerView = [[BankCategoryPickerView alloc]initWithFrame:CGRectMake(0, kScreen_Height * 0.7f, kScreen_Width, kScreen_Height * 0.3f)];
    WEAKSELF;
    [self.bankCategoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _categoryPickerView.saveBlock = ^(NSString*bank,NSString*bankCategory){
        [weakSelf.bankCategoryBtn setTitle:[NSString stringWithFormat:@"%@  %@",bank,bankCategory] forState:UIControlStateNormal];
    };
    _categoryPickerView.hidden = YES;
    [self.view addSubview:_categoryPickerView];
    
    UILabel * timeLabel = [self.view viewWithTag:12];
    timeLabel.hidden = YES;
    
    self.timeTF.hidden = YES;
    
    UIButton * timeTiShiBtn = [self.view viewWithTag:14];
    timeTiShiBtn.hidden = YES;
    
    UIView * view = [self.view viewWithTag:16];
    view.hidden = YES;
    
    
}

-(void)setPickerViewBGView{
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.alpha = 0.6;
    _bgView.backgroundColor = [UIColor lightGrayColor];
    _bgView.layer.masksToBounds= YES;
    _bgView.layer.cornerRadius = 5;
    [self.view addSubview:_bgView];
}
- (IBAction)chooseBankCategoryAction:(UIButton *)sender {
    self.categoryPickerView.hidden = NO;
    
}
- (void)chooseTimeAction:(UITapGestureRecognizer *)tap {
    
}

- (void)userExplain{

    [self setPickerViewBGView];
    userView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width * 0.8, kScreen_Height * 0.5f)];
    userView.center = _bgView.center;
    userView.layer.masksToBounds= YES;
    userView.layer.cornerRadius = 5;
    userView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userView];
    
    UILabel * explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, userView.width -30, userView.height/4)];
    explainLabel.text = @"手机号说明";
    explainLabel.textAlignment = 1;
    explainLabel.centerX = userView.width/2;
    explainLabel.textColor = [UIColor blackColor];
    explainLabel.font = [UIFont systemFontOfSize:16];
    [userView addSubview:explainLabel];
    
    UILabel * text1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 + userView.height/4, userView.width -30,userView.height/4)];
    text1.text = @"银行预留的手机号是办理该银行卡时所填写的手机号码。";
    text1.textColor = [UIColor lightGrayColor];
    text1.numberOfLines = 0;
    text1.font = [UIFont systemFontOfSize:12];
    [userView addSubview:text1];
    
    UILabel * text2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15 +userView.height/2, userView.width -30,userView.height/4)];
    text2.text = @"没有预留、手机号码忘记或者已停用，请联系银行客服更新处理";
    text2.textColor = [UIColor lightGrayColor];
    text2.numberOfLines = 0;
    text2.font = [UIFont systemFontOfSize:12];
    [userView addSubview:text2];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 15 + userView.height*3/4, userView.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [userView addSubview:line];
    
    UIButton * knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    knowBtn.frame = CGRectMake(0, userView.height *3/4 +10, userView.width, userView.height/4);
    [knowBtn setTitle:@"知道了" forState:UIControlStateNormal];
    knowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [knowBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
    [knowBtn addTarget:self action:@selector(removeBGView) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:knowBtn];
    
    
}
- (void)removeBGView{
    [self.bgView removeFromSuperview];
    [userView removeFromSuperview];
}
- (IBAction)timeTiShiAction:(UIButton *)sender {
    
}
- (IBAction)seeRegreementAction:(UIButton *)sender {
    YWComfiredAgreeViewController * agreementVC = [[YWComfiredAgreeViewController alloc]init];
    agreementVC.staus = 0;   
    [self.navigationController pushViewController:agreementVC animated:YES];
}
- (IBAction)touchNextAction:(UIButton *)sender {
    if ([self.bankCategoryBtn.titleLabel.text isEqualToString:@""] || self.bankCategoryBtn.titleLabel.text == nil) {
        [JRToast showWithText:@"请选择银行卡类型" duration:1];
        return;
    }else if (![JWTools checkTelNumber:self.phoneNumberTF.text]) {
        [JRToast showWithText:@"请输入有效11位手机号码" duration:1];
        return;
    }
    [self requesData];
    
    
}
- (IBAction)tiShiAction:(UIButton *)sender {
    [self userExplain];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    //取消第一响应者
    [self.phoneNumberTF resignFirstResponder];
    [self.timeTF resignFirstResponder];
    return YES;
    
}
- (void)requesData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_shopAdmin_PhoneCode];
    NSDictionary * pragram = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"phone":_phoneNumberTF.text,@"user_type":@(2)};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        MyLog(@"data = %@",data);
        MyLog(@"error = %@",error);
        
        NSInteger errorCode = [data[@"errorCode"] integerValue];
        
        if (errorCode == 0) {
            [JRToast showWithText:data[@"msg"] duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CheckUpBankInfomationViewController * checkVC = [[CheckUpBankInfomationViewController alloc]init];
                checkVC.phoneNumber = self.phoneNumberTF.text;
                checkVC.bankNumber = self.bankNumber;
                checkVC.bankCategory = _bankCategoryBtn.titleLabel.text;
                checkVC.userName = self.userName;
//                checkVC.isPubAccount = self.isPubAccount;
                [self.navigationController pushViewController:checkVC animated:YES];
                
            });
            
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
