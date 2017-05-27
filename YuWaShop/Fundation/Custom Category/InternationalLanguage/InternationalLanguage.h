//
//  InternationalLanguage.h
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/13.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//


/**

 [InternationalLanguage initUserLanguage];//初始化应用语言
 
 */

/**
 //重启 系统
 NSString *lan = [InternationalLanguage userLanguage];
 
 if([lan isEqualToString:@"en"]){//判断当前的语言，进行改变
 
 [InternationalLanguage setUserlanguage:@"zh-Hans"];
 
 }else{
 
 [InternationalLanguage setUserlanguage:@"en"];
 }
 
 YLWTabBarController*vc=[[YLWTabBarController alloc]init];
 [UIApplication sharedApplication].keyWindow.rootViewController=vc;


 */


/**
 用法
  NSBundle *bundle=[InternationalLanguage bundle];
 UIImageView*imageView0=[cell viewWithTag:1];
 imageView0.image=[UIImage imageNamed:[bundle
 localizedStringForKey:@"zh_mall" value:nil table:@"NewLanguage"]];

 
 */


#import <Foundation/Foundation.h>

#define KLANGUAGE       @"whichLanguage"     // 那种语言 @"en" 或者 @"zh-Hans"

@interface InternationalLanguage : NSObject



+(void)initUserLanguage;//初始化语言文件      1

+(NSBundle *)bundle;//获取当前资源文件      2

+(NSString *)userLanguage;//获取应用当前语言    2

+(void)setUserlanguage:(NSString *)language;//设置当前语言   3


@end
