//
//  YWHomeNoPayListModel.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/13.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWHomeNoPayOrderListModel.h"
#import "YWHomeNoReserveOrderListModel.h"

@interface YWHomeNoPayListModel : NSObject

@property (nonatomic,copy)NSString * status;//0未读1已读
@property (nonatomic,copy)NSString * quickPayID;
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * order_id;
@property (nonatomic,strong)YWHomeNoPayOrderListModel * order;
@property (nonatomic,strong)YWHomeNoReserveOrderListModel * reserve;

@end
