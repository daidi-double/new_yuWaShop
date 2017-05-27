//
//  YWHomePayBillViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomePayBillViewController.h"

@interface YWHomePayBillViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cutShowBtn;
@property (weak, nonatomic) IBOutlet UILabel *cutLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cutSwitchBtn;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UITextField *cutTextField;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;

@property (nonatomic,assign)BOOL isCut;
@property (nonatomic,assign)CGFloat cut;
@property (nonatomic,assign)CGFloat cutNumber;//消费总额
@property (nonatomic,assign)CGFloat costNumber;//不打折金额
@property (nonatomic,assign)CGFloat payNumber;

@end

@implementation YWHomePayBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"买单收银";
    [self dataSet];
    [self makeUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if ([self getCurrentVC] == self) {
        self.navigationController.navigationBarHidden = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
- (void)dataSet{
    self.cut = [UserSession instance].cut;
}
- (void)makeUI{
    NSString * cutStr = [NSString stringWithFormat:@"%.0f",[UserSession instance].cut*10];
    NSInteger cutInter = [cutStr integerValue];
    if (cutInter%10 == 0) {

           self.cutLabel.text = cutInter== 100?@"不打折":[NSString stringWithFormat:@"%.0f折",[UserSession instance].cut];

    }else{

        self.cutLabel.text = [NSString stringWithFormat:@"%.1f折",[UserSession instance].cut];

    }
    self.cutSwitchBtn.on = YES;
    self.isCut = self.cutSwitchBtn.on;
    self.cutShowBtn.layer.cornerRadius = 3.f;
    self.cutShowBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
}

- (IBAction)cutUseSwichAction:(UISwitch *)sender {
    self.isCut = sender.isOn;
    [self payMoneySet];
}
- (IBAction)submitBtnAction:(id)sender {
    [self payMoneySet];
    [self requestCreateQRCode];
}

- (void)payMoneySet{
    if (self.costNumber >= 999999999) {
        [self showHUDWithStr:@"支付金额太大,请多次支付哟" withSuccess:NO];
        return;
    }
    if (self.costNumber <= self.cutNumber) {
        [self showHUDWithStr:@"不打折金额不能大于消费总额哟" withSuccess:NO];
        return;
    }
    
    if (self.costNumber<=0.f)self.costTextField.text = @"";
    if (self.cutNumber<=0.f)self.cutTextField.text = @"";
    
    self.payNumber = (self.costNumber - self.cutNumber)*(self.isCut?self.cut:100) /100 + self.cutNumber;
    self.payLabel.text = [NSString stringWithFormat:@"￥%.2f",self.payNumber];
    self.QRCodeImageView.image = nil;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![string isEqualToString:@""]&&(fmodf([textField.text floatValue]*100, 1)!=0)) {
            textField.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
        }
        if (textField.tag == 1) {
            self.costNumber = [textField.text floatValue];
        }else{
            self.cutNumber = [textField.text floatValue];
        }
        [self payMoneySet];
    });
    
    return YES;
}

#pragma mark - Http
- (void)requestCreateQRCode{
    self.costTextField.text = [NSString stringWithFormat:@"%.2f",[self.costTextField.text floatValue]];
    if (self.cutNumber<=0.f){
        self.cutTextField.text = @"";
    }else{
        self.cutTextField.text = [NSString stringWithFormat:@"%.2f",[self.cutTextField.text floatValue]];
    }
    if (self.payNumber<= 0) {
        [self showHUDWithStr:@"付款不能小于0元哟~" withSuccess:NO];
        return;
    }
    NSString * noDiscountMoney = [NSString stringWithFormat:@"%.2f",self.cutNumber];
    CGFloat cut = self.isCut?self.cut:100.f;
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"total_money":@(self.costNumber),@"non_discount_money":noDiscountMoney,@"discount":@(cut/100)};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_AddRecord withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.QRCodeImageView sd_setImageWithURL:[NSURL URLWithString:responsObj[@"data"][@"url"]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:nil];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
