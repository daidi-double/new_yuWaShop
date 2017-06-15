//
//  AddChildAccounViewController.m
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AddChildAccounViewController.h"
#import "YWViewController.h"
#import "ShopAccountViewController.h"

@interface AddChildAccounViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accountTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFild;
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextFild;
@property (weak, nonatomic) IBOutlet UIButton *subcommitBtn;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitsLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseShopBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseLimitBtn;
@property (nonatomic,strong) NSString * shopId;
@property (nonatomic,strong) NSString * limitIDStr;//权限id拼接字符串

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
        self.accountTextFiled.text = self.model.username;
        self.passwordTextFild.text = @"······";
        self.iphoneTextFild.text = self.model.phone;
        self.shopNameLabel.text = self.model.company_name;
        NSMutableArray * nameAry = [NSMutableArray array];
         NSMutableArray * limitIDAry = [NSMutableArray array];
        for (NSDictionary * dict in self.model.route) {
            if ([dict[@"enable"] integerValue] == 1) {
                [nameAry addObject:dict[@"name"]];
                [limitIDAry addObject:dict[@"id"]];
            }
        }
        NSString * limitName = [nameAry componentsJoinedByString:@","];
        
        self.limitsLabel.text = limitName;
        self.limitIDStr = [limitIDAry componentsJoinedByString:@","];
        self.chooseShopBtn.hidden = YES;
        self.chooseLimitBtn.hidden = YES;
    }else{
        self.title = @"新增账号";
    }

    
}
//选择门店
- (IBAction)chooseShopAction:(UIButton *)sender {
    ShopAccountViewController * vc = [[ShopAccountViewController alloc]init];
    vc.status = self.status;
    WEAKSELF;
    vc.shopBlock = ^(NSString * shopName,NSString *shopId){
        weakSelf.shopNameLabel.text = shopName;
        weakSelf.chooseShopBtn.hidden = YES;
        weakSelf.shopId = shopId;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)chooseShopsAction {
    ShopAccountViewController * vc = [[ShopAccountViewController alloc]init];
    WEAKSELF;
    vc.shopBlock = ^(NSString * shopName,NSString *shopId){
        weakSelf.shopNameLabel.text = shopName;
        weakSelf.chooseShopBtn.hidden = YES;
    };

    [self.navigationController pushViewController:vc animated:YES];
    
    
}


//选择权限
- (IBAction)chooseJurisdictionAction:(UIButton *)sender {
    YWViewController * vc = [[YWViewController alloc]init];
    WEAKSELF;
    NSMutableArray * limitArr = [NSMutableArray array];
    NSMutableArray * limitIDArr = [NSMutableArray array];
    if (self.status == 1) {
        
        vc.status = 1;
    }else{
        vc.status = 0;
    }
    vc.childModel = self.model;
    vc.limitBlock = ^(NSMutableArray * limitAry){
        for (int i = 0; i<limitAry.count; i++) {
            LimitChildModel* model = limitAry[i];
            [limitArr addObject:model.name];
            [limitIDArr addObject:model.id];
        }
        weakSelf.limitIDStr = [limitIDArr componentsJoinedByString:@","];
        weakSelf.limitsLabel.text = [limitArr componentsJoinedByString:@","];
        weakSelf.chooseLimitBtn.hidden = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)chooselimitAction{
    YWViewController * vc = [[YWViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
//提交，保存
- (IBAction)subcommitAction:(UIButton *)sender {
    if (self.status == 1) {
        if ([self isChangeAccount]) {
            [self changeAccountData];//修改账号信息
            
        }
    }else{
        if ([self isCommit]) {
            
            [self addAccountData];//新增账号
        }
    }
}

//判断能否提交
- (BOOL)isCommit{
    if ([self.accountTextFiled.text isEqualToString:@""]) {
        [JRToast showWithText:@"请输入设置的账号" duration:1.5];
        return NO;
    }else if ([self.passwordTextFild.text isEqualToString:@""]){
        [JRToast showWithText:@"请输入设置的密码" duration:1.5];
        return NO;
    }else if( [self isPureInt:self.accountTextFiled.text]) {
        if (self.accountTextFiled.text.length <9) {
            [JRToast showWithText:@"账号为纯数字需要9位以上" duration:1.5];
            return NO;
        }
    }else if ([self.shopNameLabel.text isEqualToString:@""]){
        [JRToast showWithText:@"请选择门店" duration:1.5];
        return NO;
    }else if ([self.limitsLabel.text isEqualToString:@""]){
        [JRToast showWithText:@"请选择权限" duration:1.5];
        return NO;
    }else if( ![self isPureInt:self.accountTextFiled.text]&&self.accountTextFiled.text.length <6) {
        [JRToast showWithText:@"请输入6位以上包含字母的账号" duration:1.5];
        return NO;
    }
    return YES;
}

- (BOOL)isChangeAccount{
    if ([self.accountTextFiled.text isEqualToString:@""]) {
        [JRToast showWithText:@"请输入修改后的账号" duration:1.5];
        return NO;
    }else if ([self.passwordTextFild.text isEqualToString:@""]){
        [JRToast showWithText:@"请输入修改后的密码" duration:1.5];
        return NO;
    }else if( [self isPureInt:self.accountTextFiled.text]) {
        if (self.accountTextFiled.text.length <9) {
            [JRToast showWithText:@"纯数字需要9位以上" duration:1.5];
            return NO;
        }
    }else if ([self.shopNameLabel.text isEqualToString:@""]){
        [JRToast showWithText:@"请选择门店" duration:1.5];
        return NO;
    }else if ([self.limitsLabel.text isEqualToString:@""]){
        [JRToast showWithText:@"请选择权限" duration:1.5];
        return NO;
    }else if( ![self isPureInt:self.accountTextFiled.text]&&self.accountTextFiled.text.length <6) {
        [JRToast showWithText:@"请输入6位以上包含字母的账号" duration:1.5];
        return NO;
    }
    return YES;
}
//判断是否为纯数字：
- (BOOL)isPureInt:(NSString*)string{
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length > 0) {
        
//        MyLog(@"不是纯数字%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]]);
        return NO;
    }else{
//        MyLog(@"纯数字！%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]]);
        return YES;
    }

}


//新增账号
- (void)addAccountData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_ADDCHILDACCOUNT];
    NSString * phone;
    if ([_iphoneTextFild.text isEqualToString:@""]) {
        phone = @"";
    }else{
        phone = _iphoneTextFild.text;
    }
    
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"username":_accountTextFiled.text,@"password":_passwordTextFild.text,@"phone":phone,@"route":self.limitIDStr,@"rela_id":self.shopId};//店铺id
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",pragarms);
        MyLog(@"增加账号%@",data);
        if ([data[@"errorCode"]integerValue] == 0) {
            [JRToast showWithText:@"添加成功" duration:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1.5];
        }
    }];
}

//修改账号信息
- (void)changeAccountData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_EDITCHILDACCOUNT];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"username":_accountTextFiled.text,@"phone":self.iphoneTextFild.text,@"route":self.limitIDStr,@"rela_id":@([UserSession instance].uid),@"account_id":@([self.model.id integerValue])};
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:pragarms];
    
    if (![self.passwordTextFild.text isEqualToString:@"······"]) {
        [dic setValue:self.passwordTextFild.text forKey:@"password"];
    }
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:dic compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",pragarms);
        MyLog(@"修改账号%@",data);
        if ([data[@"errorCode"]integerValue] == 0) {
            [JRToast showWithText:data[@"errorMessage"] duration:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:1.5];
        }
    }];
}
////修改密码
//- (void)changeAccountPassword{
//    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_CHANGECHILDACCOUNTPASSWORD];
//    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID]};
//    HttpManager * manager = [[HttpManager alloc]init];
//}
////修改手机号
//- (void)changeAccountPhone{
//    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_CHANGECHILDACCOUNTIPHONE];
//    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID]};
//    HttpManager * manager = [[HttpManager alloc]init];
//}
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
