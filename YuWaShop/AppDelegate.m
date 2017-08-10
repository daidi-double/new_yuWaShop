//
//  AppDelegate.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AppDelegate.h"
#import "VIPTabBarController.h"
#import "UIWindow+SettingWithVC.h"

//#import "EMSDK.h"
#import "EaseUI.h"
#import "YWStartAnimation.h"

#import "VoiceChatViewController.h"
#import "VideoViewController.h"
#import "YWMessageChatViewController.h"

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<EMContactManagerDelegate,EMChatManagerDelegate,EMGroupManagerDelegate,EMClientDelegate,JPUSHRegisterDelegate,EMCallManagerDelegate>

@end

@implementation AppDelegate
@synthesize splashView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerEMClientWithApplication:application withOptions:(NSDictionary *)launchOptions];//registerEMClient
    [self registerJPushWithOptions:launchOptions];
    [UserSession instance];
    
    self.window = [UIWindow windowInitWithRootViewController:[[VIPTabBarController alloc]init]];
#pragma mark -- 启动页动画
    [self.window makeKeyAndVisible];
    [YWStartAnimation startAnimationWithView:self.window];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //app进入后台
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //app进入前端
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - EMClient
- (void)registerEMClientWithApplication:(UIApplication *)application withOptions:(NSDictionary *)launchOptions{
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"YvWaNotificationDevelop";
#else
    apnsCertName = @"YvWaNotificationProducation";
#endif
    NSString * appkey= @"ceoshanghaidurui#duruikejiyuwa";
    
    EMOptions *options = [EMOptions optionsWithAppkey:appkey];
    options.apnsCertName = apnsCertName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];//好友代理
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];//登录代理
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    EMCallOptions *callOptions = [[EMClient sharedClient].callManager getCallOptions];
    //当对方不在线时，是否给对方发送离线消息和推送，并等待对方回应
    callOptions.isSendPushIfOffline = YES;
    [[EMClient sharedClient].callManager setCallOptions:callOptions];
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:appkey apnsCertName:apnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    //iOS10 注册APNs
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                [application registerForRemoteNotifications];
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: (UNAuthorizationOptionBadge| UNAuthorizationOptionSound| UNAuthorizationOptionAlert) categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert)];
        }
        
        
    }
#endif

}

- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername message:(NSString *)aMessage{
    NSMutableArray * friendsRequest = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:FRIENDSREQUEST]];
    NSDictionary * requestDic = @{@"hxID":aUsername,@"message":aMessage,@"status":@"0"};//0未读1未处理2同意3拒绝
    if (!friendsRequest)friendsRequest = [NSMutableArray arrayWithCapacity:0];
    [friendsRequest insertObject:requestDic atIndex:0];
    [KUSERDEFAULT setObject:friendsRequest forKey:FRIENDSREQUEST];
}
//- (void)messagesDidReceive:(NSArray *)aMessages{
- (void)didReceiveMessages:(NSArray *)aMessages{
    YWMessageChatViewController * chatVC = [[YWMessageChatViewController alloc]init];
    UIApplication * application = [UIApplication sharedApplication];
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    for(EMMessage *message in aMessages){
        BOOL needShowNotification = (message.chatType = EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
        if (needShowNotification) {
            
            [chatVC showNotificationWithMessage:message];
        }
    }
}

#pragma mark - private
- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}
// *  用户A拨打用户B，用户B会收到这个回调
- (void)callDidReceive:(EMCallSession *)aSession{

    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }

        if ( aSession.type == 0) {
            VoiceChatViewController * vc = [[VoiceChatViewController alloc]init];
            vc.callSession = aSession;
            vc.statusLabel.hidden = YES;
            vc.isHidden = NO;
            vc.status = 1;
            vc.isHidden = YES;
            vc.remoteUsername = aSession.remoteName;
            vc.conversation = [[EMClient sharedClient].chatManager getConversation:aSession.remoteName type:EMConversationTypeChat createIfNotExist:YES];
    [topRootViewController presentViewController:vc animated:YES completion:nil];
        }else{//视频
            VideoViewController * VideoVC = [[VideoViewController alloc]init];
            VideoVC.callSession = aSession;
            VideoVC.statusLabel.hidden = YES;
            VideoVC.isHidden = NO;
            VideoVC.status = 1;
            VideoVC.isHidden = YES;
            VideoVC.remoteUsername = aSession.remoteName;
            VideoVC.conversation = [[EMClient sharedClient].chatManager getConversation:aSession.remoteName type:EMConversationTypeChat createIfNotExist:YES];
    [topRootViewController presentViewController:VideoVC animated:YES completion:nil];
        }
}


- (void)didLoginFromOtherDevice{//当前登录账号在其它设备登录时会接收到该回调
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
}
- (void)didRemovedFromServer{//当前登录账号已经被从服务器端删除时会收到该回调
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
}

#pragma mark - JPush
- (void)saveJupshNotificationDicWithDic:(NSDictionary *)dic{
    NSMutableArray * jpushArr = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:JPush_Notification_DicArr]];
    if (!jpushArr)jpushArr = [NSMutableArray arrayWithCapacity:0];
    [jpushArr insertObject:dic atIndex:0];
    [KUSERDEFAULT setObject:jpushArr forKey:JPush_Notification_DicArr];
}

- (void)registerJPushWithOptions:(NSDictionary *)launchOptions{
    //    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {//可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    
    NSString * appKey = @"980bbea59e896101b75d4286";
    BOOL isProduction = NO;
   
#if DEBUG
    isProduction = NO;

#else
    isProduction = YES;
#endif
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:@"App Store" apsForProduction:isProduction advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            MyLog(@"registrationID获取成功：%@",registrationID);
        }else{
            MyLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    [JPUSHService setLogOFF];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {/// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {//Optional
    MyLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UserSession instance].isNewNoticafication = YES;
    [UserSession refreshNoticaficationWithIsNewNoticafication:YES];
    [JPUSHService handleRemoteNotification:userInfo];
    MyLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        [self saveJupshNotificationDicWithDic:userInfo];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    
#else
    //    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
#endif
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    [UserSession instance].isNewNoticafication = YES;
    [UserSession refreshNoticaficationWithIsNewNoticafication:YES];
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        MyLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        if ([body isEqualToString:@"用户买单"]) {
            
            EMError *error = [[EMClient sharedClient].contactManager addContact:title message:@"我想加您为好友"];
            if (!error) {
                MyLog(@"自动申请成功");
            }
        }
        [self saveJupshNotificationDicWithDic:userInfo];
        
    }else {// 判断为本地通知
        MyLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        if ([body isEqualToString:@"用户买单"]) {
            
            EMError *error = [[EMClient sharedClient].contactManager addContact:title message:@"我想加您为好友"];
            if (!error) {
                MyLog(@"自动申请成功");
            }
        }
        [self saveJupshNotificationDicWithDic:userInfo];
        
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString * filePath1 = [NSString stringWithFormat:@"%@/isPush.plist",documentPath];
        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath1];
        if ([dic objectForKey:@"ispush"]) {
            //表示存在这个key，
            [dic setValue:@"1" forKey:@"ispush"];
        }else{
            [dic setValue:@"1" forKey:@"ispush"];
        }
        [dic writeToFile:filePath1 atomically:YES];
            self.window = [UIWindow windowInitWithRootViewController:[[VIPTabBarController alloc]init]];
    }else {
        // 判断为本地通知
        NSLog(@"iOS10    收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count])return nil;
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}


//本地添加
- (void)addLocalPushNotificationWithTime:(NSTimeInterval)secs withAlertBody:(NSString *)con{
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    //    center.delegate = self;
    content.title = @"雨掌柜";// 标题
    content.subtitle = @"";// 子标题
    content.body = con;// 内容
    content.badge = @0;// 标记个数
    content.sound = [UNNotificationSound defaultSound];// 推送提示音
    // content.sound = [UNNotificationSound soundNamed:@"音频文件名"];// 指定音频文件
    //    content.launchImageName = @"Default";// 启动图片(好像不起作用)
    content.userInfo = @{@"name":@"YWLocalNotifiction"};// 附加信息
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"puff.jpg" ofType:nil];// 添加附件
    //    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"mazy" URL:[NSURL fileURLWithPath:filePath] options:0 error:nil];
    //    content.attachments = @[attachment];
    
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:secs+0.1 repeats:NO];// 通过时间差，多少秒后推送本地推送
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"YWLocalNotifiction" content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            MyLog(@"推送添加成功");
        }
    }];
    
    
#else
    UILocalNotification *notification = [[UILocalNotification alloc] init];// 创建一个本地推送
    NSDate * nowDate = [NSDate dateWithTimeIntervalSinceNow:secs];// secs 秒 后 推送一条消息
    
    if (notification != nil) {
        notification.fireDate = nowDate;// 设置推送时间
        notification.timeZone = [NSTimeZone defaultTimeZone];// 设置时区
        notification.repeatInterval = 0;// 设置重复间隔
        notification.soundName =UILocalNotificationDefaultSoundName;// 推送声音
        notification.alertBody = con;// 推送内容
        //        notification.applicationIconBadgeNumber = 1;//显示在icon上的红色圈中的数子
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name" forKey:@"YWLocalNotifiction"];
        notification.userInfo = info;//设置userinfo 方便在之后需要撤销的时候使用
        UIApplication *app = [UIApplication sharedApplication];//添加推送到UIApplication
        [app scheduleLocalNotification:notification];
    }
#endif
}

//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"雨娃" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//
//    [alert show];
////    application.applicationIconBadgeNumber -= 1;// 图标上的数字减1
//    MyLog(@"didReceiveLocalNotification");
//
//}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(buttonIndex == 1){
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://fir.im/XXXX"]];
//    }
//}

@end
