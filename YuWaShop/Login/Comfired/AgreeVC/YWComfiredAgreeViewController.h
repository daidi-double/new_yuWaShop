//
//  YWComfiredAgreeViewController.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWBasicViewController.h"

@interface YWComfiredAgreeViewController : JWBasicViewController

@property (nonatomic,copy)void (^agreeBlock)();
@property (nonatomic,assign) NSInteger staus;

@end
