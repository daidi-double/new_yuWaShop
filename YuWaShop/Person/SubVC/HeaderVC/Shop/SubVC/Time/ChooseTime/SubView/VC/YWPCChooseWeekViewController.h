//
//  YWPCChooseWeekViewController.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWBasicViewController.h"

@interface YWPCChooseWeekViewController : JWBasicViewController

@property (nonatomic,copy)void (^saveWeekInfoBlock)(NSMutableArray *);

@end
