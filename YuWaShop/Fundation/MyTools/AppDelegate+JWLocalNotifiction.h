//
//  AppDelegate+JWLocalNotifiction.h
//  YuWa
//
//  Created by Tian Wei You on 16/10/21.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (JWLocalNotifiction)<UIAlertViewDelegate>

/*其他页面调用范例
 //AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
 //[appDelegate addLocalPushNotificationWithTime:secs withAlertBody:con];
 */

///本地移除
-(void)removeLocalPushNotification;

@end
