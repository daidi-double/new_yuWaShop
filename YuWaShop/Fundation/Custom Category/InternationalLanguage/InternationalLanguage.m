//
//  InternationalLanguage.m
//  Vipxox
//
//  Created by 黄佳峰 on 16/7/13.
//  Copyright © 2016年 拥吻汇. All rights reserved.
//

#import "InternationalLanguage.h"

@implementation InternationalLanguage

static NSBundle *bundle = nil;

+ ( NSBundle * )bundle{
    
    return bundle;
    
}



+(void)initUserLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *string = [def valueForKey:@"userLanguage"];
    NSString *current=nil;
    
    if(string.length == 0){
        
        //获取系统当前语言版本(中文zh-Hans,英文en)
        
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        if ([[languages objectAtIndex:0] hasPrefix:@"en"]) {
          current  = @"en";
            [kUserDefaults setObject:@"en" forKey:KLANGUAGE];
        }else{
        current=@"zh-Hans";
            [kUserDefaults setObject:@"zh-Hans" forKey:KLANGUAGE];
        }
        
       
        
        string = current;
        
        [def setValue:current forKey:@"userLanguage"];
        
        [def synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}


+(NSString *)userLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *language = [def valueForKey:@"userLanguage"];
    
    return language;
}


+(void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    
    [def synchronize];
}


@end
