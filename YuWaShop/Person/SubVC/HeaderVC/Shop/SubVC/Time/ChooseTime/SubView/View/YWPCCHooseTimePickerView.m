//
//  YWPCCHooseTimePickerView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCCHooseTimePickerView.h"

@implementation YWPCCHooseTimePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView * BGView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, frame.size.height)];
        BGView.backgroundColor = [UIColor blackColor];
        BGView.alpha = 0.3f;
        [self addSubview:BGView];
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
//    if ([self.startTime integerValue] > [self.finishTime integerValue] || ([self.startTime integerValue] == [self.finishTime integerValue] && [self.startSubTime integerValue] >= [self.finishSubTime integerValue])) {
//        [self showHUDWithStr:@"开始时间比结束时间早哟" withSuccess:NO];
//        return;
//    }
    
    self.saveBlock([NSString stringWithFormat:@"%@:%@",self.startTime,self.startSubTime],[NSString stringWithFormat:@"%@:%@",self.finishTime,self.finishSubTime]);
    self.hidden = YES;
}

- (void)makeToolView{
    self.showView = [[UIView alloc]initWithFrame:CGRectMake(8.f, self.frame.size.height - 382.f, self.frame.size.width - 16.f, 372.f)];
    self.showView.backgroundColor = [UIColor whiteColor];
    self.showView.layer.cornerRadius = 5.f;
    self.showView.layer.masksToBounds = YES;
    [self addSubview:self.showView];
    
    UILabel * startLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 12.f, self.showView.width/2, 32.f)];
    startLabel.font = [UIFont systemFontOfSize:14.f];
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.text = @"开始时间";
    [self.showView addSubview:startLabel];
    
    UILabel * finishLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(startLabel.frame), startLabel.y, startLabel.width, startLabel.height)];
    finishLabel.font = [UIFont systemFontOfSize:14.f];
    finishLabel.textAlignment = NSTextAlignmentCenter;
    finishLabel.text = @"结束时间";
    [self.showView addSubview:finishLabel];
    
    
    UIButton * sureBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.showView.width - 180.f)/2, self.showView.height - 45.f, 180.f, 35.f)];
    sureBtn.backgroundColor = CNaviColor;
    sureBtn.layer.cornerRadius = 5.f;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(saveAvtion) forControlEvents:UIControlEventTouchUpInside];
    [self.showView addSubview:sureBtn];
}

- (void)makePickerView{
    NSMutableArray * timeArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 24; i++) {
        [timeArr addObject:i<10?[NSString stringWithFormat:@"0%zi",i]:[NSString stringWithFormat:@"%zi",i]];
    }
    self.timeArr = [NSArray arrayWithArray:timeArr];
    self.timeSubArr = @[@"00",@"30"];
    
    self.startPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(19.f, 44.f, (self.showView.width - 76.f)/2, 265.f)];
    self.startPicker.delegate = self;
    self.startPicker.dataSource = self;
    self.startPicker.tag = 1;
    self.startPicker.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    [self.showView addSubview:self.startPicker];
    
    self.finishPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(self.showView.width/2 + self.startPicker.x, self.startPicker.y, self.startPicker.width, self.startPicker.height)];
    self.finishPicker.delegate = self;
    self.finishPicker.dataSource = self;
    self.finishPicker.tag = 2;
    self.finishPicker.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    [self.showView addSubview:self.finishPicker];
    
    self.startTime = @"08";
    self.startSubTime = @"00";
    self.finishTime = @"21";
    self.finishSubTime = @"00";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.startPicker selectRow:8 inComponent:0 animated:YES];
        [self.finishPicker selectRow:21 inComponent:0 animated:YES];
    });
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        if (component == 0) {
            self.startTime = self.timeArr[row];
        }else{
            self.startSubTime = self.timeSubArr[row];
        }
    }else{
        if (component == 0) {
            self.finishTime = self.timeArr[row];
        }else{
            self.finishSubTime = self.timeSubArr[row];
        }
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return component==0?self.timeArr.count:self.timeSubArr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return component==0?self.timeArr[row]:self.timeSubArr[row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font=[UIFont systemFontOfSize:24];
        pickerLabel.textColor=[UIColor blackColor];
        pickerLabel.textAlignment= NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    return pickerLabel;
}

#pragma mark - MBProgressHUD
- (void)showHUDWithStr:(NSString *)showHud withSuccess:(BOOL)isSuccess{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = showHud;
    if (isSuccess) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.8];
}

@end
