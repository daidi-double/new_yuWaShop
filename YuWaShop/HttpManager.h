//
//  HttpManager.h
//  NewVipxox
//
//  Created by 黄佳峰 on 16/8/31.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWload.h"
typedef void(^resultBlock)(id data,NSError*error);

@interface HttpManager : NSObject<MBProgressHUDDelegate>
//@property(nonatomic,strong)MBProgressHUD*HUD;
@property(nonatomic,strong)YWload*HUD;
//@property(nonatomic,strong)resultBlock thisBlock;
//没有HUD 的get 请求
-(void)getDatasNoHudWithUrl:(NSString*)urlStr withParams:(NSDictionary*)params compliation:(resultBlock)newBlock;
//有HUD 的get 请求
-(void)getDatasWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params compliation:(resultBlock)newBlock;
//没有 HUD  post 请求
-(void)postDatasNoHudWithUrl:(NSString*)urlStr withParams:(NSDictionary*)params compliation:(resultBlock)newBlock;
//有HUD  post 请求
-(void)postDatasWithUrl:(NSString*)urlStr withParams:(NSDictionary*)params compliation:(resultBlock)newBlock;


//上传图片 post 带hud 不带 HUD 返回会终止线程？
-(void)postUpdatePohotoWithUrl:(NSString*)urlStr withParams:(NSDictionary*)params withPhoto:(NSData*)data compliation:(resultBlock)newBlock;


@end
