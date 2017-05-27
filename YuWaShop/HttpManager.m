//
//  HttpManager.m
//  NewVipxox
//
//  Created by 黄佳峰 on 16/8/31.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager
//0
-(void)getDatasNoHudWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params compliation:(resultBlock)newBlock{
       AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        newBlock(responseObject,nil);
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        newBlock(nil,error);
        [JRToast showWithText:@"连接超时，请检查网络" topOffset:70*kScreen_Width/320 duration:3];
        
        
    }];
}

//1
-(void)getDatasWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params compliation:(resultBlock)newBlock{
    [self.HUD show:YES];
    
    AFHTTPRequestOperationManager*manager=[AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        newBlock(responseObject,nil);
        [self.HUD hide:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        newBlock(nil,error);
        [JRToast showWithText:@"连接超时，请检查网络" topOffset:70*kScreen_Width/320 duration:3];
        [self.HUD hide:YES];
    }];
    
}

//2
-(void)postDatasNoHudWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params compliation:(resultBlock)newBlock{
    
    AFHTTPRequestOperationManager*manager=[AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
          newBlock(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        newBlock(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*kScreen_Width/320 duration:3.0f];

    }];
    
    
}
//3
-(void)postDatasWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params compliation:(resultBlock)newBlock{
    [self.HUD show:YES];
    AFHTTPRequestOperationManager*manager=[AFHTTPRequestOperationManager manager];
   
    [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
          newBlock(responseObject,nil);
        [self.HUD hide:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        newBlock(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*kScreen_Width/320 duration:3.0f];
        [self.HUD hide:YES];
        
    }];
    
}

//4
-(void)postUpdatePohotoWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params withPhoto:(NSData *)Photodata compliation:(resultBlock)newBlock{
    [self.HUD show:YES];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
            [formData appendPartWithFileData:Photodata name:@"img" fileName:fileName mimeType:@"image/png"];
            
        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
//            dispatch_sync(dispatch_get_main_queue(), ^{
            newBlock(responseObject,nil);
                [self.HUD hide:YES];
//            });
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            newBlock(nil,error);
                [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*kScreen_Width/320 duration:3.0f];
                [self.HUD hide:YES];
        }];
    });
    
    
}

//#pragma mark  --set get mothod
//-(MBProgressHUD *)HUD{
//    if (!_HUD) {
//        _HUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
//        _HUD.delegate=self;
//        _HUD.userInteractionEnabled=NO;
//        _HUD.dimBackground=NO;
//        _HUD.mode=MBProgressHUDModeAnnularDeterminate;
//      
//        _HUD.removeFromSuperViewOnHide = YES;
//        
//        
//    }
//    
//    return _HUD;
//}
-(YWload *)HUD{
    if (!_HUD) {
        _HUD=[YWload showOnView:[UIApplication sharedApplication].delegate.window];
    }
    return _HUD;
}

@end
