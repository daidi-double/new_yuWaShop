//
//  BindingPersonModel.h
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

//"my_direct_user_nums" = 1,
//"my_indirect_user_nums" = 0,

@interface BindingPersonModel : NSObject
//这个就能用 yy model了 要一个一个加
@property(nonatomic,strong)NSNumber*my_direct_user_nums;
@property(nonatomic,strong)NSNumber*my_indirect_user_nums;

@end
