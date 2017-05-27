//
//  JWHttpManger.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "YWload.h"
@interface JWHttpManger : AFHTTPRequestOperationManager<MBProgressHUDDelegate>
//@property(nonatomic,strong)MBProgressHUD*HUD;
@property(nonatomic,strong)YWload*HUD;
//没有HUD 的get 请求
-(void)getDatasNoHudWithUrl:(NSString*)urlStr withParams:(NSDictionary*)params compliation:(resultBlock)newBlock;
//有HUD 的get 请求
-(void)getDatasWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params compliation:(resultBlock)newBlock;
//没有 HUD  post 请求
-(void)postDatasNoHudWithUrl:(NSString*)urlStr withParams:(NSDictionary*)params compliation:(resultBlock)newBlock;
//有HUD  post 请求
-(void)postDatasWithUrl:(NSString*)urlStr withParams:(NSDictionary*)params compliation:(resultBlock)newBlock;

-(void)postUpdatePohotoWithUrl:(NSString*)urlStr withParams:(NSDictionary*)params withPhoto:(NSData*)data compliation:(resultBlock)newBlock;

-(void)postNoHudUpdatePohotoWithUrl:(NSString*)urlStr withParams:(NSDictionary*)params withPhoto:(NSData*)data compliation:(resultBlock)newBlock;

#pragma mark - Singleton
+ (id)shareManager;

@end
