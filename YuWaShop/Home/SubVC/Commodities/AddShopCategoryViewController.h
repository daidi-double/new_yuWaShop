//
//  AddShopCategoryViewController.h
//  YuWaShop
//
//  Created by double on 17/4/26.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddShopCategoryViewController : UIViewController
@property (nonatomic,strong)NSMutableArray * categoryNameAry;
@property (nonatomic,copy)NSString * categoryName;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,copy)NSString * cat_id;
@end
