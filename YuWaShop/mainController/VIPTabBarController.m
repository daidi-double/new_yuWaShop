//
//  VIPTabBarController.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/9/1.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "VIPTabBarController.h"
#import "VIPTabBar.h"
#import "VIPNavigationController.h"

#import "YWPersonViewController.h"
#import "YWHomeViewController.h"
#import "YWDataAnalyseViewController.h"
#import "RBHomeViewController.h"
#import "YWMessageViewController.h"

@implementation VIPTabBarController

-(void)viewDidLoad{
    [super viewDidLoad];
    // tabBar 必定是灰色的  下面方法 可以改变选中时候的颜色
    [UITabBar appearance].tintColor=CNaviColor;
    [self addChildViewControllers];
}

-(void)addChildViewControllers{
   
    YWHomeViewController * vc = [[YWHomeViewController alloc]init];
    [self addChildVC:vc withTitle:@"首页" withImage:@"TabBar_Home" withSelectedImage:@"TabBar_Home"];
    
    RBHomeViewController * rbVC=[[RBHomeViewController alloc]init];
    [self addChildVC:rbVC withTitle:@"发现" withImage:@"home_1_nomal" withSelectedImage:@"home_1_selected"];
    
    YWDataAnalyseViewController * vcDiscover = [[YWDataAnalyseViewController alloc]init];
    [self addChildVC:vcDiscover withTitle:@"数据分析" withImage:@"TabBar_Data" withSelectedImage:@"TabBar_Data"];
    
    YWMessageViewController*vcMessage=[[YWMessageViewController alloc]init];
    [self addChildVC:vcMessage withTitle:@"消息" withImage:@"home_3_nomal" withSelectedImage:@"home_3_selected"];
    
    YWPersonViewController * vcPerson = [[YWPersonViewController alloc]init];
    [self addChildVC:vcPerson withTitle:@"个人中心" withImage:@"TabBar_Person" withSelectedImage:@"TabBar_Person"];
}


-(void)addChildVC:(UIViewController*)vc withTitle:(NSString*)title withImage:(NSString*)imageName withSelectedImage:(NSString*)selectedImageName{
    vc.tabBarItem.title=title;
    vc.title=title;
    vc.tabBarItem.image=[UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage=[UIImage imageNamed:selectedImageName];
    
    VIPNavigationController*navi=[[VIPNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:navi];
    
}


@end
