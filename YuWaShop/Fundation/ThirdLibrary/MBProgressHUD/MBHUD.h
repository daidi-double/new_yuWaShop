//
//  MBHUD.h
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/11.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MBHUD : NSObject<MBProgressHUDDelegate>
{
    MBProgressHUD*HUD;
}
// 钩  注册成功
-(void)showCustomDialog:(NSString*)str ;
@end
