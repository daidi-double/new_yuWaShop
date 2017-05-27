//
//  YWHomeAddCouponViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeAddCouponViewController.h"
#import "YWFastivalDayPicker.h"

@interface YWHomeAddCouponViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)YWFastivalDayPicker * startDayPicker;
@property (nonatomic,strong)YWFastivalDayPicker * finishDayPicker;

@property (weak, nonatomic) IBOutlet UIButton *createCouponBtn;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UITextField *baseNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *cutNumberTextField;

@end

@implementation YWHomeAddCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
}
- (void)makeNavi{
    self.title = @"创建优惠券";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"创建" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(createCouponAction) forControlEvents:UIControlEventTouchUpInside withWidth:33.f];
}

- (void)makeUI{
    [self cornerRadiusUISet:self.createCouponBtn];
    
    WEAKSELF;
    self.startDayPicker = [[YWFastivalDayPicker alloc]initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, kScreen_Height - 64.f)];
    self.startDayPicker.hidden = YES;
    self.startDayPicker.saveBlock = ^(NSString * time){
        weakSelf.startTimeLabel.textColor = [UIColor blackColor];
        weakSelf.startTimeLabel.text = time;
    };
    [self.view addSubview:self.startDayPicker];
    
    self.finishDayPicker = [[YWFastivalDayPicker alloc]initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, kScreen_Height - 64.f)];
    self.finishDayPicker.hidden = YES;
    self.finishDayPicker.saveBlock = ^(NSString * time){
        weakSelf.finishTimeLabel.textColor = [UIColor blackColor];
        weakSelf.finishTimeLabel.text = time;
    };
    [self.view addSubview:self.finishDayPicker];
}

- (void)cornerRadiusUISet:(UIControl *)sender{
    sender.layer.cornerRadius = 5.f;
    sender.layer.masksToBounds = YES;
}

- (IBAction)startTimeBtnAction:(id)sender {
    self.startDayPicker.hidden = NO;
}
- (IBAction)finishTimeBtnAction:(id)sender {
    self.finishDayPicker.hidden = NO;
}
- (IBAction)createCouponBtnAction:(id)sender {
    [self createCouponAction];
}

- (void)createCouponAction{
    if ([self.nameTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入优惠券名称哟~" withSuccess:NO];
        return;
    }if ([self.startTimeLabel.text isEqualToString:@"请选择开始时间"]) {
        [self showHUDWithStr:@"请选择开始时间哟~" withSuccess:NO];
        return;
    }else if ([self.finishTimeLabel.text isEqualToString:@"请选择结束时间"]) {
        [self showHUDWithStr:@"请选择结束时间哟~" withSuccess:NO];
        return;
    }else if (![JWTools firstDate:[JWTools dateTimeWithStr:self.startTimeLabel.text] withCompareDate:[JWTools dateTimeWithStr:self.finishTimeLabel.text]]) {
        [self showHUDWithStr:@"结束时间不能早于开始时间哟~" withSuccess:NO];
        self.finishDayPicker.hidden = NO;
        return;
    }else if ([self.countTextField.text isEqualToString:@""]||[self.countTextField.text integerValue]<=0) {
        self.countTextField.text = @"";
        [self showHUDWithStr:@"请输入优惠券数量哟~" withSuccess:NO];
        return;
    }else if ([self.baseNumberTextField.text isEqualToString:@""]||[self.baseNumberTextField.text floatValue]<=0.f) {
        self.baseNumberTextField.text = @"";
        [self showHUDWithStr:@"请输入最低金额哟~" withSuccess:NO];
        return;
    }else if ([self.cutNumberTextField.text isEqualToString:@""]||[self.cutNumberTextField.text floatValue]<=0.f) {
        self.cutNumberTextField.text = @"";
        [self showHUDWithStr:@"请输入优惠金额哟~" withSuccess:NO];
        return;
    }
    
    if ([self.baseNumberTextField.text floatValue] < [self.cutNumberTextField.text floatValue]){
        self.cutNumberTextField.text = [NSString stringWithFormat:@"%zi",([self.baseNumberTextField.text integerValue]-1)];
    }
    
    NSString * showStr = [NSString stringWithFormat:@"确认创建%@-%@\n消费满%@减%@的%@张优惠券?",self.startTimeLabel.text,self.finishTimeLabel.text,self.baseNumberTextField.text,self.cutNumberTextField.text,self.countTextField.text];
    
    UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestCreateCoupon];
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"确认创建" message:showStr preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:cancelAction];
    [alertVC addAction:OKAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (textField.tag != 1) {
            if (![string isEqualToString:@""]&&(fmodf([textField.text floatValue]*100, 1)!=0)) {
                textField.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue]];
            }
        }else{
            textField.text = [NSString stringWithFormat:@"%zi",[textField.text integerValue]];
        }
    });
    
    return YES;
}

#pragma mark - Http
- (void)requestCreateCoupon{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"name":self.nameTextField.text,@"total_num":@([self.countTextField.text integerValue]),@"min_fee":@([self.baseNumberTextField.text floatValue]),@"discount_fee":@([self.cutNumberTextField.text floatValue]),@"content":self.nameTextField.text,@"b_time":self.startTimeLabel.text,@"e_time":self.finishTimeLabel.text};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_AddCoupon withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self showHUDWithStr:@"添加优惠券成功" withSuccess:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }]; 
}

@end
