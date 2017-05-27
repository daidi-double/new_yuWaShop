//
//  GetMoneyToBankModel.h
//  YuWa
//
//  Created by double on 17/3/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetMoneyToBankModel : NSObject
@property (nonatomic,copy)NSString * card;
@property (nonatomic,copy)NSString * card_type;//银行卡类型
@property (nonatomic,copy)NSString * money;
@property (nonatomic,copy)NSString * fee;//手续费和说明文字
@property (nonatomic,copy)NSString * remark;//备注
@property (nonatomic,copy)NSString * forecastTime;//预计到账时间

+(GetMoneyToBankModel *)modelWithdic:(NSDictionary*)dic;
@end
