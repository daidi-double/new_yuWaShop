//
//  YWPersonHelpViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonHelpViewController.h"

@interface YWPersonHelpViewController ()

@property (nonatomic,copy)NSString * phoneStr;

@end

@implementation YWPersonHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助中心";
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestPhoneNumber];
    [self callService];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
//    if (self.phoneStr) {
//        [self callService];
//    }else{
//        [self requestPhoneNumber];
//    }
}

- (void)callService{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (![UserSession instance].phone) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"客服热线:4001505599" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIWebView* callWebview =[[UIWebView alloc] init];
            NSURL * telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:4001505599"]];
            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
            [self.view addSubview:callWebview];
        }]];

    }else{
    [alertController addAction:[UIAlertAction actionWithTitle:[UserSession instance].phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIWebView* callWebview =[[UIWebView alloc] init];
        NSURL * telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneStr]];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Http
- (void)requestPhoneNumber{
    if (![UserSession instance].phone||[[UserSession instance].phone isEqualToString:@""]) {
        [self showHUDWithStr:@"如需帮助请拨打客服热线" withSuccess:NO];
        return;
    }
    self.phoneStr = [UserSession instance].phone;
}

@end
