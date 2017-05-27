//
//  YWPSSellerRePlayModel.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/13.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPSSellerRePlayModel.h"

@implementation YWPSSellerRePlayModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"customer_content" : @"seller_content",@"ctime" : @"rtime"};
}

@end
