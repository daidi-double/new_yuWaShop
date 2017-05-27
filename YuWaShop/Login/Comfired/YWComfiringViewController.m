//
//  YWComfiringViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWComfiringViewController.h"
#import "YWLoginViewController.h"
#import "VIPTabBarController.h"

@interface YWComfiringViewController ()

@end

@implementation YWComfiringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
}
- (void)makeNavi{
    self.title = @"认证中";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImageName:@"NaviBack" withSelectImage:@"NaviBack" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside withWidth:30.f];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"退出登录" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(outLogion) forControlEvents:UIControlEventTouchUpInside withWidth:66.f];
}

- (void)backAction{
    [self.navigationController popToRootViewControllerAnimated:NO];
    VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    rootTabBarVC.selectedIndex = 0;
    rootTabBarVC.hidesBottomBarWhenPushed = NO;
}

- (void)outLogion{
    [UserSession clearUser];
    YWLoginViewController * vc = [[YWLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
