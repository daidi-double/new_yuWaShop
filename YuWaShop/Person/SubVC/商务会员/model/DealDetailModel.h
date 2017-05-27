//
//  DealDetailModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
//shop_name	string	消费商铺名称
//ctime	int	打款时间
//order_id	int	关联的订单id
//type	string	类型
//user_name	string	消费者
//total_money	float	付款总价
//pay_money	float	实际付款价格
//money	float	商务分红的钱
//score	float	积分分红的积分




@interface DealDetailModel : NSObject

@property(nonatomic,strong)NSString*shop_name;
@property(nonatomic,strong)NSString*ctime;
@property(nonatomic,strong)NSString*type;
@property(nonatomic,strong)NSString*user_name;
@property(nonatomic,strong)NSString*total_money;
@property(nonatomic,strong)NSString*pay_money;
@property(nonatomic,strong)NSString*money;

@property(nonatomic,strong)NSString*pay_to_shop_time;   //一个礼拜后打款的时间

@property(nonatomic,strong)NSString*order_id;
@end
