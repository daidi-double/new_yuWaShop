//
//  AmendInfoViewController.h
//  雨掌柜
//
//  Created by double on 17/6/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmendInfoViewController : UIViewController
@property (nonatomic,assign)NSInteger status;//0修改账号，1修改密码，2修改手机号，3添加手机号
@property (nonatomic,copy)NSString * iphone;
@end
