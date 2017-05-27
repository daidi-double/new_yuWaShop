//
//  MySignShopModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

//{
//    "company_name" = 美食商家2,
//    "ctime" = 0,
//    "score" = <null>,
//    "id" = 4,
//    "yestoday" = 0,
//    "indirect_nums" = 1,
//    "business" = 0.00,
//    "indirect" = <null>,
//    }, 


@interface MySignShopModel : NSObject

@property(nonatomic,strong)NSString*company_name;
@property(nonatomic,strong)NSString*ctime;
@property(nonatomic,strong)NSString*score;
@property(nonatomic,strong)NSString*id;
@property(nonatomic,strong)NSString*yestoday;
@property(nonatomic,strong)NSString*indirect_nums;
@property(nonatomic,strong)NSString*business;
@property(nonatomic,strong)NSString*indirect;
@end
