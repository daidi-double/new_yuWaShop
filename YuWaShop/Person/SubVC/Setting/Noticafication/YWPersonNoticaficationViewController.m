//
//  YWPersonNoticaficationViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonNoticaficationViewController.h"

@interface YWPersonNoticaficationViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *paySwich;
@property (weak, nonatomic) IBOutlet UISwitch *orderSwich;

@end

@implementation YWPersonNoticaficationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知设置";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self noticaficationStationRefresh];
}

- (void)noticaficationStationRefresh{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        [self.paySwich setOn:UIUserNotificationTypeNone == setting.types?NO:YES];
        [self.orderSwich setOn:self.paySwich.isOn];
    }
}

- (IBAction)paySwich:(UISwitch *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    [self.orderSwich setOn:self.paySwich.isOn];
}
- (IBAction)orderSwich:(UISwitch *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    [self.paySwich setOn:self.orderSwich.isOn];
}

@end
