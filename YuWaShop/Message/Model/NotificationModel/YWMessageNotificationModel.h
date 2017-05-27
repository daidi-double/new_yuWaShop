//
//  YWMessageNotificationModel.h
//  YuWa
//
//  Created by Tian Wei You on 16/9/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWMessageNotificationModel : NSObject

@property (nonatomic,copy)NSString * status;//0预定通知1付款通知
@property (nonatomic,copy)NSString * title;
@property (nonatomic,copy)NSString * content;
@property (nonatomic,copy)NSString * ctime;


@end
