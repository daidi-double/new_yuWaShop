//
//  UserSession.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/8/31.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "UserSession.h"
#import "HttpObject.h"
#import "JPUSHService.h"
#import "JWTools.h"
#import "VIPTabBarController.h"
#import "YWHomeViewController.h"
#import "VIPNavigationController.h"
#import "YWComfiredViewController.h"
#import "YWComfiringViewController.h"
#import "YWLoginViewController.h"

@implementation UserSession
static UserSession * user=nil;

+ (UserSession*)instance{
    if (!user) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            user=[[UserSession alloc]init];
        });
        user.token=@"";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [UserSession getDataFromUserDefault];
        });
        
          }
    
    return user;
}


+ (void)clearUser{
    [UserSession saveUserLoginWithAccount:@"" withPassword:@""];
    user = nil;
    user=[[UserSession alloc]init];
    user.token=@"";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient].options setIsAutoLogin:NO];
        
        EMError *error = [[EMClient sharedClient] logout:YES];
        if (!error)MyLog(@"环信退出成功");
        
        [UserSession getDataFromUserDefault];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        });
        
        NSMutableArray * friendsRequest = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:FRIENDSREQUEST]];
        friendsRequest = [NSMutableArray arrayWithCapacity:0];
        [KUSERDEFAULT setObject:friendsRequest forKey:FRIENDSREQUEST];
    });
}

+ (void)saveUserLoginWithAccount:(NSString *)account withPassword:(NSString *)password{
    user.account = account;
    [KUSERDEFAULT setValue:account forKey:AUTOLOGIN];
    user.password = password;
    [KUSERDEFAULT setValue:password forKey:AUTOLOGINCODE];
}


+ (void)getDataFromUserDefault{//get local saved data
    NSString * accountDefault = [KUSERDEFAULT valueForKey:AUTOLOGIN];
    NSString * passwordDefault = [KUSERDEFAULT valueForKey:AUTOLOGINCODE];
    if (accountDefault) {
        if ([accountDefault isEqualToString:@""] || passwordDefault == nil){
            [UserSession isLogion];
            return;
        }
        user.account = accountDefault;
        user.password = [KUSERDEFAULT valueForKey:AUTOLOGINCODE];
        [UserSession autoLoginRequestWithPragram:@{@"phone":user.account,@"password":user.password,@"is_md5":@1}];
    }else{
        [UserSession isLogion];
    }
}

+ (void)autoLoginRequestWithPragram:(NSDictionary *)pragram{//auto login
    [[HttpObject manager]postNoHudWithType:YuWaType_Logion withPragram:pragram success:^(id responsObj) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data is %@",responsObj);
        [UserSession saveUserInfoWithDic:responsObj[@"data"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            EMError *errorLog = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"2%@",user.account] password:user.hxPassword];
            if (!errorLog){
                [[EMClient sharedClient].options setIsAutoLogin:NO];
                [[EMClient sharedClient].chatManager getAllConversations];
                MyLog(@"环信登录成功");
            }else{
                EMError *error = [[EMClient sharedClient] registerWithUsername:[NSString stringWithFormat:@"2%@",[NSString stringWithFormat:@"2%@",user.account]] password:[NSString stringWithFormat:@"2%@",user.account]];
                if (error==nil) {
                    MyLog(@"环信注册成功");
                    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
                    if (!isAutoLogin) {
                        EMError *errorLog = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"2%@",user.account] password:[NSString stringWithFormat:@"2%@",user.account]];
                        if (errorLog==nil){
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                            MyLog(@"环信登录成功");
                        }
                    }
                }
            }
            
            [JPUSHService setAlias:user.account callbackSelector:nil object:nil];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Pragram is %@",pragram);
        MyLog(@"Data Error error is %@",responsObj);
        MyLog(@"Error is %@",error);
        [UserSession isLogion];
    }];
}


+ (void)saveUserInfoWithDic:(NSDictionary *)dataDic{//analyse date
    user.token = dataDic[@"token"];
    user.uid = [dataDic[@"id"] integerValue];
    
    user.password = dataDic[@"password"];
    [KUSERDEFAULT setValue:user.password forKey:AUTOLOGINCODE];
    user.nickName = (dataDic[@"company_name"]&&![dataDic[@"company_name"] isKindOfClass:[NSNull class]])?dataDic[@"company_name"]:user.account;
    user.birthDay = dataDic[@"birthday"];
    user.hxPassword = [NSString stringWithFormat:@"2%@",dataDic[@"mobile"]];
    user.mobile = [NSString stringWithFormat:@"%@",dataDic[@"mobile"]];
    user.local = dataDic[@"address"];
    
    NSArray * SexArr = @[@"男",@"女",@"未知"];
    NSNumber* sexNum=dataDic[@"sex"];
    NSInteger sexInt=[sexNum integerValue];
    if (sexInt>0&&sexInt<=3)user.sex = [NSString stringWithFormat:@"%@",SexArr[sexInt-1]];
    
    user.money = dataDic[@"money"];
    user.inviteID = dataDic[@"invite_uid"];
    user.logo = (dataDic[@"company_img"]&&![dataDic[@"company_img"] isKindOfClass:[NSNull class]])?dataDic[@"company_img"]:@"";
    user.personality = (dataDic[@"company_mark"]&&![dataDic[@"company_mark"]isKindOfClass:[NSNull class]])?dataDic[@"company_mark"]:@"尚未设置门店简介哟";
    if ([user.personality isEqualToString:@""]) {
        user.personality = @"尚未设置门店简介哟";
    }
    user.aldumCount = dataDic[@"aldumcount"];
    user.collected = dataDic[@"collected"];
    user.praised = dataDic[@"praised"];
    user.attentionCount = dataDic[@"attentioncount"];
    user.fans = dataDic[@"fans"];
    user.isVIP = [dataDic[@"user_type"] integerValue];
    user.last_login_time = dataDic[@"last_login_time"];
    user.status = dataDic[@"status"];
    user.reg_time = dataDic[@"reg_time"];
    user.sale_id = dataDic[@"sale_id"];
    user.email = dataDic[@"email"];
    user.baobaoLV = [dataDic[@"level"] integerValue];
    user.baobaoEXP = [dataDic[@"energy"] integerValue];
    NSInteger needExp = [dataDic[@"update_level_energy"] integerValue];
    user.baobaoNeedEXP = needExp?needExp>0?needExp:13500:13500;
    
    user.note_nums=dataDic[@"note_nums"];
    user.album_nums=dataDic[@"album_nums"];
    user.comment_nums=dataDic[@"comment_nums"];
    user.today_money=dataDic[@"today_money"];
    
    
    NSString * isNewNoticafication = [KUSERDEFAULT valueForKey:IS_NEW_NOTICAFICATION];
    if (isNewNoticafication&&[isNewNoticafication isEqualToString:@"1"]) {
        user.isNewNoticafication = YES;
        [UserSession refreshNoticaficationWithIsNewNoticafication:YES];
    }
    if (![dataDic[@"check_status"] isKindOfClass:[NSNull class]]) {
        user.comfired_Status = [dataDic[@"check_status"] integerValue]<=0?4:[dataDic[@"check_status"] integerValue];//实名认证1待审核 2通过 3拒绝 4未提交
        if (user.comfired_Status==2)user.isVIP = 3;
    }else{
        user.comfired_Status = 4;
    }
    
    user.cut = ([((dataDic[@"company_discount"]&&![dataDic[@"company_discount"]isKindOfClass:[NSNull class]])?dataDic[@"company_discount"]:@"9") floatValue]*10);
    if (!user.cut||user.cut<0.1)user.cut = 9;
    user.serventPhone = dataDic[@"invite_phone"];
    user.star = [((dataDic[@"star"]&&![dataDic[@"star"]isKindOfClass:[NSNull class]])?dataDic[@"star"]:@"5.0") floatValue];
    NSArray * infrastructure = dataDic[@"infrastructure"];
    if (!infrastructure) infrastructure=@[];
    if (infrastructure.count>1) {
        user.infrastructure = infrastructure[1];
        for (int i = 2; i<infrastructure.count; i++) {
            if (i>3)break;
            user.infrastructure = [NSString stringWithFormat:@"%@,%@",user.infrastructure,infrastructure[i]];
        }
    }else if (infrastructure.count>0) {
        user.infrastructure = infrastructure[0];
    }else{
        user.infrastructure = @"暂无设置";
    }
    if (user.isVIP ==3||user.comfired_Status == 2){
        [UserSession userShoperSalePhone];
        [UserSession userCompareType];
    }
    
    user.isLogin = YES;
}

+ (void)userShoperSalePhone{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":user.token,@"user_id":@(user.uid)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_GetSalePhone withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is pragram = %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        user.phone = responsObj[@"data"][@"phone"];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

+ (void)userCompareType{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":user.token,@"user_id":@(user.uid)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_GetCatTag withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSDictionary * dataDic = responsObj[@"data"];
        user.shopType = dataDic[@"cat"][@"name"]?dataDic[@"cat"][@"name"]:@"美食";
        user.shopTypeID = dataDic[@"cat"][@"id"]?dataDic[@"cat"][@"id"]:@"1";
        NSArray * dataArr = dataDic[@"tag"];
        if (dataArr.count <= 0) {
            user.shopSubTypeArr = @[@"火锅",@"生日蛋糕",@"自助餐",@"西餐"];
            user.shopSubTypeIDArr = @[@"44",@"45",@"47",@"50"];
        }else{
            NSMutableArray * typeArr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray * typeIDArr = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < dataArr.count;i++) {
                [typeArr addObject:dataArr[i][@"tag_name"]?dataArr[i][@"tag_name"]:@"生日蛋糕"];
                [typeIDArr addObject:dataArr[i][@"tag_name"]?dataArr[i][@"tag_id"]:@"45"];
            }
            user.shopSubTypeArr = [NSArray arrayWithArray:typeArr];
            user.shopSubTypeIDArr = [NSArray arrayWithArray:typeIDArr];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        user.shopType = @"美食";
        user.shopTypeID = @"0";
        user.shopSubTypeArr = @[@"火锅",@"生日蛋糕",@"自助餐",@"西餐"];
        user.shopSubTypeIDArr = @[@"44",@"45",@"47",@"50"];
    }];
}

+ (BOOL)userToComfired{
    if (user.isVIP ==3||user.comfired_Status == 2){
        return YES;
    }else{
        VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController * vc;
        if (user.comfired_Status == 1) {
            vc = [[YWComfiringViewController alloc]init];
        }else{
            vc = [[YWComfiredViewController alloc]init];
        }
        [rootTabBarVC.selectedViewController pushViewController:vc animated:YES];
        return NO;
    }
}

+ (void)isLogion{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!user.isLogin) {
            VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            YWLoginViewController * vc = [[YWLoginViewController alloc]init];
            [rootTabBarVC.selectedViewController pushViewController:vc animated:NO];
        }else if (user.isVIP != 3){
            [UserSession userToComfired];
        }
    });
    
    
}

+ (void)refreshNoticaficationWithIsNewNoticafication:(BOOL)isNewNoticafication{
    [KUSERDEFAULT setValue:[NSString stringWithFormat:@"%@",isNewNoticafication?@"1":@"0"] forKey:IS_NEW_NOTICAFICATION];
    user.isNewNoticafication = isNewNoticafication;
    VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    VIPNavigationController * navigationView = rootTabBarVC.viewControllers[0];
    if ([navigationView.viewControllers[0] isKindOfClass:[YWHomeViewController class]]) {
        YWHomeViewController * vc = (YWHomeViewController *)navigationView.viewControllers[0];
        [vc isNewNotification:isNewNoticafication];
    }
}

@end
