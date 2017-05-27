//
//  CheckUpBankInfomationViewController.h
//  YuWaShop
//
//  Created by double on 17/3/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckUpBankInfomationViewController : UIViewController

@property (nonatomic,copy)NSString * phoneNumber;
@property (nonatomic,copy)NSString * bankNumber;//卡号
@property (nonatomic,copy)NSString * userName;//持卡人
@property (nonatomic,copy)NSString * bankCategory;//银行名称
@property (nonatomic,assign)BOOL isPubAccount;//对公账户

@end
