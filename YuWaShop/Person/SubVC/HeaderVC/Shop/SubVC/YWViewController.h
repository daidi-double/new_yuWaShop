//
//  YWViewController.h
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LimitChildModel.h"
#import "ChildModel.h"
@interface YWViewController : UIViewController
@property (nonatomic,assign)NSInteger status;//0增加子账号选择权限，1修改选择权限
@property(nonatomic,copy)void(^limitBlock)(NSMutableArray *);
@property (nonatomic,strong)ChildModel * childModel;
@end
