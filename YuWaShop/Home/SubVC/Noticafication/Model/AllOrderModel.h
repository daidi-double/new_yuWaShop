//
//  AllOrderModel.h
//  YuWaShop
//
//  Created by double on 17/4/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllOrderModel : NSObject
@property (nonatomic,strong)NSString * status;//未读标记
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * order_id;
@property (nonatomic,copy)NSString * id;
@property (nonatomic,copy)NSString * order_type;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * total_money;
@property (nonatomic,copy)NSString * customer_name;
@property (nonatomic,copy)NSString * create_time;
@property (nonatomic,copy)NSString * customer_uid;
@property (nonatomic,copy)NSString * pay_time;
@property (nonatomic,copy)NSString * pay_money;


@end
