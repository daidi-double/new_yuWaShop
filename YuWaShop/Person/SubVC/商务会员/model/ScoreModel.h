//
//  ScoreModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

//"score" = {
//    "settlement_score" = 840,
//    "total_score" = 940,
//    "my_score" = 0.00,
//    "today_score" = 840,
//},


@interface ScoreModel : NSObject

@property(nonatomic,strong)NSString*settlement_score;
@property(nonatomic,strong)NSString*total_score;
@property(nonatomic,strong)NSString*my_score;
@property(nonatomic,strong)NSString*today_score;
@property(nonatomic,strong)NSString*pay_scale;    //支付的比例

@end
