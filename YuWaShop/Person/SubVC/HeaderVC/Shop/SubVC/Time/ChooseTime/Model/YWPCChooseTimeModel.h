//
//  YWPCChooseTimeModel.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWPCChooseSubTimeModel.h"

@interface YWPCChooseTimeModel : NSObject

@property (nonatomic,copy)NSString * payDays;
@property (nonatomic,assign)BOOL isPayAllDay;
@property (nonatomic,strong)NSMutableArray<YWPCChooseSubTimeModel *> * payTimeArr;

@end
