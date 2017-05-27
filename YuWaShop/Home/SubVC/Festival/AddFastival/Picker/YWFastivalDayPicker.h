//
//  YWFastivalDayPicker.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWFastivalDayPicker : UIView

@property (nonatomic,copy)void (^saveBlock)(NSString *);

@property (nonatomic,strong)UIDatePicker * pickerView;
@property (nonatomic,copy)NSString * date;

- (void)makePickerView;
- (void)saveAvtion;
- (void)clearSeparatorWithView:(UIView * )view;


@end
