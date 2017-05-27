//
//  YWPersonNewsDetailModel.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWPersonNewsDetailModel : NSObject

@property (nonatomic,copy)NSString * shop_nums;
@property (nonatomic,assign)NSInteger * bad_comment_nums;
@property (nonatomic,assign)NSInteger * all_comment_nums;
@property (nonatomic,assign)NSInteger my_star;
@property (nonatomic,copy)NSString * today_log;
@property (nonatomic,copy)NSString * buzz;
@property (nonatomic,copy)NSString * ranking_change;
@property (nonatomic,copy)NSString * my_star_buzz;
@property (nonatomic,assign)NSInteger good_comment_nums;


@end
