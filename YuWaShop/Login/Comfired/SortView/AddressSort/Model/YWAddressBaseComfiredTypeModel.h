//
//  YWAddressBaseComfiredTypeModel.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWAddressComfiredTypeModel.h"

@interface YWAddressBaseComfiredTypeModel : NSObject

@property (nonatomic,copy)NSString * typeID;
@property (nonatomic,copy)NSString * class_name;
@property (nonatomic,strong)NSArray * business;

@end
