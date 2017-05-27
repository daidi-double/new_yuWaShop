//
//  YWHomeNoPayOrderListModel.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/13.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWHomeNoPayOrderListModel : NSObject

@property (nonatomic,copy)NSString * orderID;
@property (nonatomic,copy)NSString * total_money;
@property (nonatomic,copy)NSString * order_sn;
@property (nonatomic,copy)NSString * seller_uid;
@property (nonatomic,copy)NSString * discount;
@property (nonatomic,copy)NSString * is_coupon;
@property (nonatomic,copy)NSString * memo;
@property (nonatomic,copy)NSString * is_paid;
@property (nonatomic,copy)NSString * non_discount_money;
@property (nonatomic,copy)NSString * coupon_id;
@property (nonatomic,copy)NSString * customer_uid;
@property (nonatomic,copy)NSString * coupon_money;
@property (nonatomic,copy)NSString * pay_money;
@property (nonatomic,copy)NSString * is_comment;
@property (nonatomic,copy)NSString * create_time;
@property (nonatomic,copy)NSString * pay_time;
@property (nonatomic,copy)NSString * customer_name;
@property (nonatomic,copy)NSString * seller_money;
@property (nonatomic,copy)NSString * balance_momey;
@property (nonatomic,copy)NSString * third_pay_money;
@property (nonatomic,copy)NSString * after_discount_money;
@property (nonatomic,copy)NSString * platform_money;


@end
