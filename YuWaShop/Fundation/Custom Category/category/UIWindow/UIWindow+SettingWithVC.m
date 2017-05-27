//
//  UIWindow+SettingWithVC.m
//  JW百思
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import "UIWindow+SettingWithVC.h"

@implementation UIWindow (SettingWithVC)

#pragma mark - UIWindow
/**
 *  初始化UIWindow并赋予根视图
 *
 *  @param rootViewController UIWindow的根视图
 *
 *  @return 自定义的UIWindow
 */
+ (UIWindow *)windowInitWithRootViewController:(UIViewController *)rootViewController{
    UIWindow * window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [window makeKeyAndVisible];
    window.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    window.rootViewController = rootViewController;
    
    return window;
}


@end
