//
//  YWPersonShopHeaderModel.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWPersonShopHeaderModel : NSObject

@property (nonatomic,copy)NSString * company_name;
@property (nonatomic,copy)NSString * score;
@property (nonatomic,strong)NSArray * business_hours;
@property (nonatomic,strong)NSDictionary * business_time;
@property (nonatomic,copy)NSString * img_nums;
@property (nonatomic,copy)NSString * company_img;
@property (nonatomic,copy)NSString * discount;
@property (nonatomic,copy)NSString * is_map;
@property (nonatomic,copy)NSString * company_first_tel;
@property (nonatomic,copy)NSString * company_address;
@property (nonatomic,copy)NSString * company_second_tel;
@property (nonatomic,copy)NSString * per_capita;

@end
