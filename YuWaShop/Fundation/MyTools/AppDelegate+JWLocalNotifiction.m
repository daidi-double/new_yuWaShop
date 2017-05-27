//
//  AppDelegate+JWLocalNotifiction.m
//  YuWa
//
//  Created by Tian Wei You on 16/10/21.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AppDelegate+JWLocalNotifiction.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation AppDelegate (JWLocalNotifiction)



///本地移除
- (void)removeLocalPushNotification{
    MyLog(@"%s",__FUNCTION__);
    UIApplication* app=[UIApplication sharedApplication];
    NSArray* localNotifications=[app scheduledLocalNotifications];//获取当前应用所有的通知
    
    if (localNotifications) {
        for (UILocalNotification* notification in localNotifications) {
            NSDictionary* dic= notification.userInfo;
            if (dic) {
                NSString* key=[dic objectForKey:@"YWLocalNotifiction"];
                if ([key isEqualToString:@"name"]) {
                    [app cancelLocalNotification:notification];//取消推送 （指定一个取消）
                    break;
                }
            }
        }
    }
    
    //[app cancelAllLocalNotifications];//取消当前应用所有的推送
}

@end
