//
//  AddChildAccounViewController.h
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildModel.h"
@interface AddChildAccounViewController : UIViewController
@property (nonatomic,assign)NSInteger status;//0新增，1修改
@property (nonatomic,strong)ChildModel * model;

@end
