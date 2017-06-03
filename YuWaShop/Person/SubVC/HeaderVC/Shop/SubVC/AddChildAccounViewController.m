//
//  AddChildAccounViewController.m
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AddChildAccounViewController.h"
#import "YWViewController.h"


@interface AddChildAccounViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFild;
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextFild;
@property (weak, nonatomic) IBOutlet UIButton *subcommitBtn;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitsLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseShopBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseLimitBtn;


@end

@implementation AddChildAccounViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.subcommitBtn.layer.masksToBounds = YES;
    self.subcommitBtn.layer.cornerRadius = 5;
}
- (void)makeUI{
    if (self.status == 1) {
        self.title = @"账号详情";
        self.accountTextFiled.text = [UserSession instance].account;//修改
        self.passwordTextFild.text = @"······";
        self.iphoneTextFild.text = [UserSession instance].account;//修改;
        self.shopNameLabel.text = [UserSession instance].nickName;//修改
        self.limitsLabel.text = @"团购";
        self.chooseShopBtn.hidden = YES;
        self.chooseLimitBtn.hidden = YES;
    }else{
        self.title = @"新增账号";
    }

    
}
//选择门店
- (IBAction)chooseShopAction:(UIButton *)sender {
    
    
}
- (void)chooseShopsAction {
    
    
}
//选择权限
- (IBAction)chooseJurisdictionAction:(UIButton *)sender {
    YWViewController * vc = [[YWViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)chooselimitAction{
    YWViewController * vc = [[YWViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
//提交，保存
- (IBAction)subcommitAction:(UIButton *)sender {
    
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
