//
//  YWPersonShopModel.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWPersonShopHeaderModel.h"

@interface YWPersonShopModel : NSObject

//首页
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)YWPersonShopHeaderModel * headerModel;

//环境
@property (nonatomic,strong)NSMutableArray * environmentDataArr;

+ (YWPersonShopModel *)sharePersonShop;

@end
