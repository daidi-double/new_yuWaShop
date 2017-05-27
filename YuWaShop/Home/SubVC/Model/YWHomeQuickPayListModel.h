//
//  YWHomeQuickPayListModel.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWHomeQuickPayListModel : NSObject
/**
{
 "data" = 1 (
	{
 "order_sn" = 14911581153154,
 "order_id" = 6,
 "total_money" = 1.0000,
 "create_time" = 1491158115,
 "order_type" = 已支付,
 },
 ),
 "errorCode" = 0,
},
*/


@property (nonatomic,copy)NSString *customer_name;          //消费者名称
@property (nonatomic,copy)NSString *customer_uid;
@property (nonatomic,copy)NSString *create_time;         //下单时间，时间戳

@property (nonatomic,copy)NSString * order_sn;//订单号
@property (nonatomic,copy)NSString * order_id;//订单ID
@property (nonatomic,copy)NSString * order_type;//订单状态


@property (nonatomic,copy)NSString *total_money;          //付款总额
@property (nonatomic,copy)NSString *non_discount_money;    //不打折总额
@property (nonatomic,copy)NSString *discount;           //享受的折扣
@property (nonatomic,copy)NSString *after_discount_money;  //需要支付的钱
@property (nonatomic,copy)NSString *coupon_money;           //优惠券抵扣金额
@property (nonatomic,copy)NSString *pay_money;            //实际付款的金额
@property (nonatomic,copy)NSString *seller_money;          //商家可得到的金钱
@property (nonatomic,copy)NSString *platform_money;      //平台得到的钱     这个不用展示




@end
