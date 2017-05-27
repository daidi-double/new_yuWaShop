//
//  OrderDetailModel.h
//  YuWaShop
//
//  Created by double on 17/4/1.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject
@property (nonatomic,copy)NSString * type;//款额类型
@property (nonatomic,copy)NSString * account_status;//交易状态
@property (nonatomic,copy)NSString * pay_to_shop_time;//给店铺打款时间
@property (nonatomic,copy)NSString * money;//实际收款
@property (nonatomic,copy)NSString * pay_money;//消费者实际付款
@property (nonatomic,assign)NSInteger  ctime;
@property (nonatomic,copy)NSString * order_sn;
@property (nonatomic,copy)NSString * orderTime;//下单时间
@property (nonatomic,copy)NSString * total_money;//订单总额
@property (nonatomic,copy)NSString * discount;//实际折扣
@property (nonatomic,copy)NSString * discount_money;//参与折扣金额
@property (nonatomic,copy)NSString * counter_fee_money;//手续费
@property (nonatomic,copy)NSString * plateform_income_money;//平台抽成
@property (nonatomic,copy)NSString * seller_uid;
@property (nonatomic,copy)NSString * order_id;

//@property (nonatomic,copy)NSString * 

@property (nonatomic,copy)NSString * goods_name;
@property (nonatomic,copy)NSString * order_type;
@property (nonatomic,copy)NSString * seller_money;
@property (nonatomic,assign)NSInteger create_time;

@property (nonatomic,copy)NSString * coupon_money;//优惠券金额
@property (nonatomic,assign)NSInteger is_coupon;//是否使用优惠券 1是使用。0 未使用
@property (nonatomic,assign)NSInteger coupon_type;//优惠券类型 1商家自发券 2平台通用 3平台指定商家 4平台活动赠送

@end
