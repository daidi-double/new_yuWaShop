//
//  JWBasicViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/19.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWBasicViewController.h"
#import "AppDelegate.h"
#import "JWLocalNotificationShowView.h"
#import "YWLoginViewController.h"
#import "YWComfiredViewController.h"

@interface JWBasicViewController ()

@end

@implementation JWBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
#pragma mark - Notice
- (void)makeNoticeWithTime:(NSTimeInterval)secs withAlertBody:(NSString *)con{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate addLocalPushNotificationWithTime:secs withAlertBody:con];
    JWLocalNotificationShowView * showView = [[[NSBundle mainBundle]loadNibNamed:@"JWLocalNotificationShowView" owner:self options:nil]firstObject];
    showView.conLabel.text = con;
    [[UIApplication sharedApplication].keyWindow addSubview:showView];
    [UIView animateWithDuration:2.f animations:^{
        showView.alpha = 0.3f;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
}

#pragma mark - MBProgressHUD
- (void)showHUDWithStr:(NSString *)showHud withSuccess:(BOOL)isSuccess{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = showHud;
    if (isSuccess) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }
    hud.alpha = 0.6;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.8];
}

- (void)backBarAction{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
