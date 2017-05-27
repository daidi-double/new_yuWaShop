//
//  YWBankModel.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWBankModel.h"

@implementation YWBankModel
//userName;
//@property (nonatomic,copy)NSString * bankID;//卡ID
//@property (nonatomic,copy)NSString * bankCard;//卡号
//@property (nonatomic,copy)NSString * bankName;//银行名称
//@property (nonatomic,copy)NSString * bankCategory;//银行卡类别
+(YWBankModel*)bankModelWithDic:(NSDictionary *)dic{
    YWBankModel * model = [[YWBankModel alloc]init];
    NSString * card_type = dic[@"card_type"];
    NSArray *array = [card_type componentsSeparatedByString:@"银行"];
    model.bankName = [NSString stringWithFormat:@"%@银行",array[0]];
    model.bankCategory = array[1];
    model.bankID = dic[@"id"];
    model.bankCard = dic[@"card"];
    model.userName = dic[@"user_name"];
    model.phoneNumber = dic[@"mobile"];
//    MyLog(@"model.bankCategory = %@,%@,%@,%@,%@,%@",model.bankCategory,model.bankName,model.userName,model.phoneNumber,model.bankID,model.bankCard);
    return model;
}

@end
