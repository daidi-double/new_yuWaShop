//
//  BankCategoryPickerView.m
//  YuWaShop
//
//  Created by double on 17/3/24.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "BankCategoryPickerView.h"
@interface BankCategoryPickerView()
@property (nonatomic,strong)NSMutableArray * bankCategoryArr;
@property (nonatomic,strong)NSMutableArray * bankArr;

@end
@implementation BankCategoryPickerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
        [self makePickerView];
        [self makeToolView];
    }
    return self;
}
- (void)tapAction{
    self.hidden = YES;
}
- (void)makeToolView{
    UIView * toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    toolView.backgroundColor = [UIColor lightGrayColor];
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
-(void)makePickerView{
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, self.frame.size.height - 180.f, self.frame.size.width, 180.f)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.picker selectRow:3 inComponent:0 animated:YES];
    });
    self.bankCategory = @"储蓄卡";
    self.bank = @"中国农业银行";
    _bankArr = [NSMutableArray arrayWithObjects:@"中国工商银行",@"中国建设银行",@"中国银行",@"中国农业银行",@"招商银行",@"中国邮政银行",nil];
    _bankCategoryArr = [NSMutableArray arrayWithObjects:@"储蓄卡",@"信用卡",@"对公账户",nil];
   
    self.bankAndCategoryArr = [NSArray arrayWithObjects:_bank,_bankCategoryArr, nil];
    [self addSubview:self.picker];

}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.bank = self.bankArr[row];
    }else{
        self.bankCategory = self.bankCategoryArr[row];
    }

}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _bankArr.count;
    }else{
        return self.bankCategoryArr.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.bankArr[row];
    }else{
        return self.bankCategoryArr[row];
    }
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

-(void)saveAvtion{
    self.hidden = YES;
    self.saveBlock(self.bank,self.bankCategory);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
