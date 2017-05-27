//
//  AddChildAccounViewController.m
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AddChildAccounViewController.h"
#import "YWViewController.h"


@interface AddChildAccounViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFild;
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextFild;
@property (weak, nonatomic) IBOutlet UIButton *subcommitBtn;

@end

@implementation AddChildAccounViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增账号";
    self.subcommitBtn.layer.masksToBounds = YES;
    self.subcommitBtn.layer.cornerRadius = 5;
}

//选择门店
- (IBAction)chooseShopAction:(UIButton *)sender {
    
    
}
//选择权限
- (IBAction)chooseJurisdictionAction:(UIButton *)sender {
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
