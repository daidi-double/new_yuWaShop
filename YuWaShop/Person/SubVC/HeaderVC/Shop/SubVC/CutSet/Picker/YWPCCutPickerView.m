//
//  YWPCCutPickerView.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/25.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCCutPickerView.h"

@implementation YWPCCutPickerView
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
    NSString * showName;
    if (self.cutInter%10 == 0) {
        showName = [NSString stringWithFormat:@"%zi折",((self.cutInter+5)/10)];
    }else{
        NSString * str = [NSString stringWithFormat:@"%ld",(self.cutInter + 5)];
        CGFloat currCut = [str floatValue]/10;
        showName = [NSString stringWithFormat:@"%.1f折",currCut];
    }
    self.saveBlock(self.cut,self.cutInter,showName);
    self.hidden = YES;
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
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, self.frame.size.height - 180.f, self.frame.size.width, 180.f)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.picker selectRow:9 inComponent:0 animated:YES];
    });
    self.cut = @"9折";
    self.cutInter = 9;
    NSMutableArray * cutArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 90; i >= 10; i--) {
        if (i%10 == 0) {
            [cutArr addObject:[NSString stringWithFormat:@"%zi折",(i/10)]];
        }else{
            [cutArr addObject:[NSString stringWithFormat:@"%zi折",i]];
        }
    }
    self.cutArr = [NSArray arrayWithArray:cutArr];
    [self addSubview:self.picker];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.cut = self.cutArr[row];
    self.cutInter = 90 - row;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.cutArr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.cutArr[row];
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

@end
