//
//  YWAddressBaseComfiredTypeModel.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWAddressBaseComfiredTypeModel.h"

@implementation YWAddressBaseComfiredTypeModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"typeID":@"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"business":[YWAddressComfiredTypeModel class]};
}

@end
