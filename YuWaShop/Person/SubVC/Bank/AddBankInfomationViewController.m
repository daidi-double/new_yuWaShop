//
//  AddBankInfomationViewController.m
//  YuWaShop
//
//  Created by double on 17/3/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AddBankInfomationViewController.h"
#import "YWBankViewController.h"
#import "AddBankCategoryViewController.h"
@interface AddBankInfomationViewController ()
{
    UIView * userView;
    UITextField * userNameTF;
    UITextField * userBankIDTF;
}
@property (nonatomic,strong)UIView * bgView;

@end

@implementation AddBankInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self userExplain];
    [self makeUI];
    self.title = @"添加银行卡";
    UIBarButtonItem * backBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToBank)];
    self.navigationItem.leftBarButtonItem = backBtn;
}
- (void)makeUI{
    userNameTF = [self.view viewWithTag:3];
    userNameTF.borderStyle = UITextBorderStyleNone;
    
    userBankIDTF = [self.view viewWithTag:5];
    userBankIDTF.borderStyle = UITextBorderStyleNone;
    
    UIButton * nextBtn = [self.view viewWithTag:6];
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = 5;
    [nextBtn addTarget:self action:@selector(touchNext) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * explain = [self.view viewWithTag:7];
    [explain addTarget:self action:@selector(addExplain) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)addExplain{
    [self userExplain];
}

- (void)touchNext{
    if ([userNameTF.text isEqualToString:@""] || userNameTF.text == nil) {
        [JRToast showWithText:@"请输入持卡人姓名" duration:1];
        return;
//    }else if (self.isPubAccount == YES){
//        if ([userBankIDTF.text isEqualToString:@""] || userBankIDTF.text == nil) {
//            [JRToast showWithText:@"请输入正确的对公账号" duration:1];
//            return;
//
//        }
//    }else if (self.isPubAccount == NO){
    }else if ([userBankIDTF.text isEqualToString:@""] || userBankIDTF.text == nil || userBankIDTF.text.length <12){
        [JRToast showWithText:@"请输入正确的银行卡号" duration:1];
        return;
        }
//    }
    AddBankCategoryViewController * addCategoryVC = [[AddBankCategoryViewController alloc]init];
    addCategoryVC.userName = userNameTF.text;
    addCategoryVC.bankNumber = userBankIDTF.text;
//    addCategoryVC.isPubAccount = self.isPubAccount;
    [self.navigationController pushViewController:addCategoryVC animated:YES];
}
- (void)backToBank{

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
- (void)userExplain{
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.alpha = 0.6;
    _bgView.backgroundColor = [UIColor lightGrayColor];
    _bgView.layer.masksToBounds= YES;
    _bgView.layer.cornerRadius = 5;
    [self.view addSubview:_bgView];
    
    userView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width * 0.8, kScreen_Height * 0.45f)];
    userView.center = _bgView.center;
    userView.layer.masksToBounds= YES;
    userView.layer.cornerRadius = 5;
    userView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userView];
    
    UILabel * explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, userView.width -30, userView.height/4)];
    explainLabel.text = @"持卡人说明";
    explainLabel.textAlignment = 1;
    explainLabel.centerX = userView.width/2;
    explainLabel.textColor = [UIColor darkGrayColor];
    explainLabel.font = [UIFont systemFontOfSize:14];
    [userView addSubview:explainLabel];
    
    UILabel * text1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10 + userView.height/4, userView.width -30,userView.height/4)];
    text1.text = @"为了你的账户资金安全,只能绑定持卡人本人的银行卡。";
    text1.textColor = [UIColor lightGrayColor];
    text1.numberOfLines = 0;
    text1.font = [UIFont systemFontOfSize:12];
    [userView addSubview:text1];
    
    UILabel * text2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15 +userView.height/2, userView.width -30,userView.height/4)];
    text2.text = @"获得更多帮助，请致电雨娃宝客服电话:4001505599";
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
