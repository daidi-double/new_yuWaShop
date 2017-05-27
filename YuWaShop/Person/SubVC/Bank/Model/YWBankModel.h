//
//  YWBankModel.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWBankModel : NSObject
@property (nonatomic,copy)NSString * userName;
@property (nonatomic,copy)NSString * bankID;//卡ID
@property (nonatomic,copy)NSString * bankCard;//卡号
@property (nonatomic,copy)NSString * bankName;//银行名称
@property (nonatomic,copy)NSString * bankCategory;//银行卡类别
@property (nonatomic,copy)NSString * phoneNumber;//手机号码

+(YWBankModel*)bankModelWithDic:(NSDictionary*)dic;

@end
