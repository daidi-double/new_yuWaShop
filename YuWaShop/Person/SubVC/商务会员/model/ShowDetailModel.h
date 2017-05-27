//
//  ShowDetailModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowDetailModel : NSObject
//{
//    "money" = 0.00,
//    "ctime" = 1512896056,
//    "id" = 4,
//    "type" = 直接介绍分红,
//},

@property(nonatomic,strong)NSString*money;
@property(nonatomic,strong)NSString*ctime;
@property(nonatomic,strong)NSString*id;
@property(nonatomic,strong)NSString*type;

@end
