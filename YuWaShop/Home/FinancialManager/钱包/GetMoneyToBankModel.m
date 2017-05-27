//
//  GetMoneyToBankModel.m
//  YuWa
//
//  Created by double on 17/3/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "GetMoneyToBankModel.h"

@implementation GetMoneyToBankModel
+(GetMoneyToBankModel *)modelWithdic:(NSDictionary *)dic{
    GetMoneyToBankModel *getModel = [[GetMoneyToBankModel alloc]init];
    getModel.remark = dic[@"remark"];
    getModel.money = dic[@"money"];
    getModel.forecastTime = dic[@"forecastTime"];
    getModel.card = dic[@"card"];
    getModel.card_type = dic[@"card_type"];
    getModel.fee = dic[@"fee"];
    
    return getModel;
}
@end
