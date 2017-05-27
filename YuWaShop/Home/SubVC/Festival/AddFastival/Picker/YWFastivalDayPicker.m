//
//  YWFastivalDayPicker.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWFastivalDayPicker.h"

@implementation YWFastivalDayPicker

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        
        [self makeToolView];
        [self makePickerView];
    }
    return self;
}

- (void)tapAction{
    self.hidden = YES;
}

- (void)saveAvtion{
    self.saveBlock(self.date);
    self.hidden = YES;
}

- (void)dateViewAction:(id)sender{
    UIDatePicker * picker = (UIDatePicker *)sender;
    [self getSelectedDateWithDate:picker.date];
}
- (void)getSelectedDateWithDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.date = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
}

- (void)makeToolView{
    UIView * toolView = [[UIView alloc]initWithFrame:CGRectMake(0.f, self.frame.size.height - 220.f, self.frame.size.width, 40.f)];
    toolView.backgroundColor = CNaviColor;
    [self addSubview:toolView];
    
    UIButton * cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.f, 0.f, 50.f, 40.f)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:cancelBtn];
    
    UIButton * sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width -  60.f, 0.f, 50.f, 40.f)];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [sureBtn setTitle:@"保存" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(saveAvtion) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:sureBtn];
}

- (void)makePickerView{
    self.pickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0.f, self.frame.size.height - 180.f, self.frame.size.width, 180.f)];
    self.pickerView.datePickerMode = UIDatePickerModeDate;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.pickerView addTarget:self action:@selector(dateViewAction:) forControlEvents:UIControlEventValueChanged];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    self.pickerView.locale = locale;
    [self clearSeparatorWithView:self.pickerView];
    self.pickerView.minimumDate = [NSDate date];
    [self getSelectedDateWithDate:[NSDate date]];
    
    [self addSubview:self.pickerView];
}

- (void)clearSeparatorWithView:(UIView * )view{
    if(view.subviews != 0  ){
        if(view.bounds.size.height < 5)view.backgroundColor = [UIColor clearColor];
        
        [view.subviews enumerateObjectsUsingBlock:^( UIView *  obj, NSUInteger idx, BOOL *  stop) {
            [self clearSeparatorWithView:obj];
        }];
    }
}

@end
