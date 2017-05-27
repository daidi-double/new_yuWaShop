//
//  FinancailBaseModel.h
//  YuWaShop
//
//  Created by 黄佳峰 on 2016/12/6.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    "pay_type" = 每日一结(隔7天),
//    "next_money" = <null>,
//    "tomorrow" = 1481040010,
//    "total_settlement" = 10.00,
//    "today_money" = 10.00,
//    "pay_time" = 7天系统自动打款,
//    },



@interface FinancailBaseModel : NSObject

@property(nonatomic,strong)NSString*total_settlement;
@property(nonatomic,strong)NSString*today_money;
@property(nonatomic,strong)NSString*next_money;
@property(nonatomic,strong)NSString*tomorrow;
@property(nonatomic,strong)NSString*pay_type;
@property(nonatomic,strong)NSString*pay_time;


@end
