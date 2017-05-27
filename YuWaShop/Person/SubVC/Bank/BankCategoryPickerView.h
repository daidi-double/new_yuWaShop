//
//  BankCategoryPickerView.h
//  YuWaShop
//
//  Created by double on 17/3/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCategoryPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,copy)void (^saveBlock)(NSString *,NSString *);

@property (nonatomic,strong)UIPickerView * picker;
@property (nonatomic,copy)NSString * bank;
@property (nonatomic,copy)NSString * bankCategory;
@property (nonatomic,strong)NSArray * bankAndCategoryArr;

- (void)makePickerView;
- (void)saveAvtion;

@end
