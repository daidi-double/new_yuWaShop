//
//  YWPCCHooseTimePickerView.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPCCHooseTimePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,copy)void (^saveBlock)(NSString *,NSString *);

@property (nonatomic,strong)UIPickerView * startPicker;
@property (nonatomic,strong)UIPickerView * finishPicker;
@property (nonatomic,strong)UIView * showView;
@property (nonatomic,copy)NSString * startTime;
@property (nonatomic,copy)NSString * finishTime;
@property (nonatomic,copy)NSString * startSubTime;
@property (nonatomic,copy)NSString * finishSubTime;
@property (nonatomic,strong)NSArray * timeArr;
@property (nonatomic,strong)NSArray * timeSubArr;

- (void)saveAvtion;

@end
