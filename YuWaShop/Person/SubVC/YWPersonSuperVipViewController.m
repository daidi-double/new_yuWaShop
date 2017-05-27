//
//  YWPersonSuperVipViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonSuperVipViewController.h"

@interface YWPersonSuperVipViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *BgView;
@property (weak, nonatomic) IBOutlet UILabel *noPeopleLbl;

@end

@implementation YWPersonSuperVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系/投诉责任销售";
    [self callService];
}

- (void)callService{
    if (![UserSession instance].phone||[[UserSession instance].phone isEqualToString:@""]) {
        [self showHUDWithStr:@"暂无数据,请稍后重试" withSuccess:NO];
        return;
    }else{
        [self.noPeopleLbl removeFromSuperview];
        [self.BgView removeFromSuperview];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:[UserSession instance].phone style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIWebView* callWebview =[[UIWebView alloc] init];
        NSURL * telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[UserSession instance].phone]];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
