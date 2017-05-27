//
//  YWHomeAddFastivalViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeAddFastivalViewController.h"
#import "YWFastivalDayPicker.h"
#import "YWPCCutPickerView.h"
#import "JWTextView.h"

@interface YWHomeAddFastivalViewController ()

@property (nonatomic,strong)YWPCCutPickerView * cutPicker;
@property (nonatomic,strong)YWFastivalDayPicker * startDayPicker;
@property (nonatomic,strong)YWFastivalDayPicker * finishDayPicker;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet JWTextView *conTextView;

@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cutBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startTimeBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishTimeBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cutBtnWidth;

@property (nonatomic,copy)NSString * cut;
@property (nonatomic,assign)NSInteger cutInter;

@end

@implementation YWHomeAddFastivalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加节日信息";
    [self makeUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)makeUI{
    WEAKSELF;
    
    self.conTextView.placeholderColor = [UIColor colorWithHexString:@"#b3b3b3"];
    self.conTextView.placeholder = @"请输入节日主题";
    
    self.conTextView.layer.borderColor = [UIColor colorWithHexString:@"#b3b3b3"].CGColor;
    self.conTextView.layer.borderWidth = 1.5f;
    self.conTextView.layer.cornerRadius = 5.f;
    self.conTextView.layer.masksToBounds = YES;

    [self cornerRadiusUISet:self.cutBtn];
    [self cornerRadiusUISet:self.startTimeBtn];
    [self cornerRadiusUISet:self.finishTimeBtn];
    [self cornerRadiusUISet:self.submitBtn];
    
    self.cutPicker = [[YWPCCutPickerView alloc]initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, kScreen_Height - 64.f)];
    self.cutPicker.hidden = YES;
    self.cutInter = 65;
    self.cutPicker.saveBlock = ^(NSString * name,NSInteger cut,NSString * showName){
        weakSelf.cutInter = cut;
        weakSelf.cutBtnWidth.constant = 60.f;
        [weakSelf.cutBtn updateConstraints];
        [weakSelf.cutBtn setTitle:name forState:UIControlStateNormal];
    };
    [self.view addSubview:self.cutPicker];
    
    self.startDayPicker = [[YWFastivalDayPicker alloc]initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, kScreen_Height - 64.f)];
    self.startDayPicker.hidden = YES;
    self.startDayPicker.saveBlock = ^(NSString * time){
        weakSelf.startTimeBtnWidth.constant = 120.f;
        [weakSelf.startTimeBtn updateConstraints];
        [weakSelf.startTimeBtn setTitle:time forState:UIControlStateNormal];
    };
    [self.view addSubview:self.startDayPicker];
    
    self.finishDayPicker = [[YWFastivalDayPicker alloc]initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, kScreen_Height - 64.f)];
    self.finishDayPicker.hidden = YES;
    self.finishDayPicker.saveBlock = ^(NSString * time){
        weakSelf.finishTimeBtnWidth.constant = 120.f;
        [weakSelf.finishTimeBtn updateConstraints];
        [weakSelf.finishTimeBtn setTitle:time forState:UIControlStateNormal];
    };
    [self.view addSubview:self.finishDayPicker];
}

- (void)cornerRadiusUISet:(UIControl *)sender{
    sender.layer.cornerRadius = 5.f;
    sender.layer.masksToBounds = YES;
}

- (IBAction)submitBtnAction:(id)sender {
    [self requestAddFastival];
}
- (IBAction)cutBtnAction:(id)sender {
    self.cutPicker.hidden = NO;
}
- (IBAction)startTimeBtnAction:(id)sender {
    self.startDayPicker.hidden = NO;
}
- (IBAction)finishTimeBtnAction:(id)sender {
    self.finishDayPicker.hidden = NO;
}

#pragma mark - Http
- (void)requestAddFastival{
    if ([self.conTextView.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入节日主题哟~" withSuccess:NO];
        return;
    }else if ([self.cutBtn.titleLabel.text isEqualToString:@"请输入"]) {
        [self showHUDWithStr:@"请选择折扣哟~" withSuccess:NO];
        return;
    }else if ([self.startTimeBtn.titleLabel.text isEqualToString:@"请选择"]) {
        [self showHUDWithStr:@"请选择开始时间哟~" withSuccess:NO];
        return;
    }else if ([self.finishTimeBtn.titleLabel.text isEqualToString:@"请选择"]) {
        [self showHUDWithStr:@"请输入结束时间哟~" withSuccess:NO];
        return;
    }else if (![JWTools firstDate:[JWTools dateTimeWithStr:self.startTimeBtn.titleLabel.text] withCompareDate:[JWTools dateTimeWithStr:self.finishTimeBtn.titleLabel.text]]) {
        [self showHUDWithStr:@"结束时间不能早于开始时间哟~" withSuccess:NO];
        self.finishDayPicker.hidden = NO;
        return;
    }
    NSString * str = [NSString stringWithFormat:@"%ld",(self.cutInter + 5)];
    CGFloat currCut = [str floatValue]/10;

    NSString * cut = [NSString stringWithFormat:@"%.1f",currCut];
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"title":self.conTextView.text,@"rebate":@([cut floatValue]),@"btime":self.startTimeBtn.titleLabel.text,@"etime":self.finishTimeBtn.titleLabel.text};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_AddHoliday withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self showHUDWithStr:@"添加节日活动成功" withSuccess:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
