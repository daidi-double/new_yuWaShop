//
//  BusinessBaseInfoModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessBaseInfoModel : NSObject
//"total_money" = 30.00,
//"total_settlement" = 10.00,
//"today_money" = 10.00,

@property(nonatomic,strong)NSString*total_money;
@property(nonatomic,strong)NSString*total_settlement;
@property(nonatomic,strong)NSString*today_money;

@end
