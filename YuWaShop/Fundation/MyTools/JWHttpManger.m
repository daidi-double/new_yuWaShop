//
//  JWHttpManger.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWHttpManger.h"

@implementation JWHttpManger

+ (id)shareManager{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static JWHttpManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
//        manager.securityPolicy.allowInvalidCertificates = YES;//AFN的HTTPS SSL的验证,若无效则启用下行
//        [manager setSecurityPolicy:[JWHttpManger customSecurityPolicy]];//HTTPS SSL的验证,在此处调用上面的代码,给这个证书验证
    });
    return manager;
}

+ (AFSecurityPolicy *)customSecurityPolicy{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"Admin" ofType:@"cer"];//先导入证书，找到证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];//AFSSLPinningModeCertificate 使用证书验证模式
    
    securityPolicy.allowInvalidCertificates = YES;//allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
//    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    NSArray *set = [[NSArray alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    return securityPolicy;
}

- (void)getDatasNoHudWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params compliation:(resultBlock)newBlock{

    [self GET:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        newBlock(responseObject,nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        newBlock(nil,error);
        [JRToast showWithText:@"连接超时，请检查网络" topOffset:70*kScreen_Width/320 duration:3];
    }];
}

- (void)getDatasWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params compliation:(resultBlock)newBlock{
    [self.HUD show:YES];

    [self GET:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        newBlock(responseObject,nil);
        [self.HUD hide:YES];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        newBlock(nil,error);
        [JRToast showWithText:@"连接超时，请检查网络" topOffset:70*kScreen_Width/320 duration:3];
        [self.HUD hide:YES];
    }];
}

- (void)postDatasNoHudWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params compliation:(resultBlock)newBlock{

    [self POST:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        newBlock(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        newBlock(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*kScreen_Width/320 duration:3.0f];
    }];
}

-(void)postDatasWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params compliation:(resultBlock)newBlock{
    [self.HUD show:YES];

    [self POST:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        newBlock(responseObject,nil);
        [self.HUD hide:YES];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        newBlock(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*kScreen_Width/320 duration:3.0f];
        [self.HUD hide:YES];
    }];
    
}

- (void)postUpdatePohotoWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params withPhoto:(NSData *)Photodata compliation:(resultBlock)newBlock{
    [self.HUD show:YES];
    
    self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    [self POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:Photodata name:@"img" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        newBlock(responseObject,nil);
            [self.HUD hide: YES];
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        newBlock(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*kScreen_Width/320 duration:3.0f];
        [self.HUD hide:YES];
    }];
}
- (void)postNoHudUpdatePohotoWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params withPhoto:(NSData *)Photodata compliation:(resultBlock)newBlock{
    self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    [self POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:Photodata name:@"img" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        newBlock(responseObject,nil);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        newBlock(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*kScreen_Width/320 duration:3.0f];
       
    }];
}
#pragma mark - HUD
//-(MBProgressHUD *)HUD{
//    if (!_HUD) {
//        _HUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
//        _HUD.delegate=self;
//        _HUD.userInteractionEnabled=NO;
////        _HUD.mode=MBProgressHUDModeAnnularDeterminate;
//        _HUD.dimBackground=NO;
//        _HUD.labelText = @"请稍等";
//        _HUD.removeFromSuperViewOnHide = YES;
//    }
//    return _HUD;
//}
-(YWload *)HUD{
    if (!_HUD) {
        _HUD=[YWload showOnView:[UIApplication sharedApplication].delegate.window];
    }
    return _HUD;
}







@end
