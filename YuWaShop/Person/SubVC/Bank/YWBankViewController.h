//
//  YWBankViewController.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWBasicViewController.h"
#import "SuccessViewController.h"
@interface YWBankViewController : JWBasicViewController
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,copy)void (^getBankCardBlock)(NSString * bankName,NSString * bankCard,NSString * bankCardID,NSString * userName);
@end
