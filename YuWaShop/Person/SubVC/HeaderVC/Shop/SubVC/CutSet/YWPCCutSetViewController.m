//
//  YWPCCutSetViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCCutSetViewController.h"
#import "YWPersonShopModel.h"

@interface YWPCCutSetViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UIPickerView * cutPicker;
@property (weak, nonatomic) IBOutlet UILabel *currentCutLabel;

@property (weak, nonatomic) IBOutlet UILabel *cutShowLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic,strong)UIPickerView * picker;
@property (nonatomic,copy)NSString * cut;
@property (nonatomic,assign)CGFloat cutInter;
@property (nonatomic,strong)NSArray * cutArr;
@property (nonatomic,strong)YWPersonShopModel * model;

@end

@implementation YWPCCutSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"折扣设置";
    self.model = [YWPersonShopModel sharePersonShop];
    [self makeUI];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
}

- (void)makeUI{
    self.sureBtn.layer.cornerRadius = 5.f;
    self.sureBtn.layer.masksToBounds = YES;
    MyLog(@"[UserSession instance].cut = %f, %f",[UserSession instance].cut,self.cutInter);
    self.currentCutLabel.text = [NSString stringWithFormat:@"当前折扣%@",([NSString stringWithFormat:@"%.1f折",[UserSession instance].cut *10])];
//    self.cutShowLabel.text = [NSString stringWithFormat:@"客服折扣%.1f+0.5=%.1f (0.5折为平台分配资金)\n\n不能低于9折,每日只能设置一次折扣",([UserSession instance].cut - 0.5),[UserSession instance].cut];
    self.cutShowLabel.text = @"最低折扣不能低于9折，每日只能设置1次折扣";
    [self makePickerView];
}

- (IBAction)sureBtnAction:(id)sender {
    [self requestSendCut];
}

- (void)makePickerView{
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 392.f, kScreen_Width, kScreen_Height - 392.f - 66.f)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    self.picker.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.picker selectRow:(10-[UserSession instance].cut >=0?(10-[UserSession instance].cut):0) inComponent:0 animated:YES];
    });
    self.cutInter = [UserSession instance].cut ;
    self.cut = [NSString stringWithFormat:@"%.1f折",self.cutInter ];
    
    NSMutableArray * cutArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 90; i >= 10; i--) {
        if (i%10 == 0) {
            [cutArr addObject:[NSString stringWithFormat:@"%zi折",(i/10)]];
        }else{
            NSString * currCut = [NSString stringWithFormat:@"%zi",i];
            CGFloat cutNum = [currCut floatValue]/10;
            [cutArr addObject:[NSString stringWithFormat:@"%.1f折",cutNum]];
        }
    }
    self.cutArr = [NSArray arrayWithArray:cutArr];
    [self.view addSubview:self.picker];
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.cut = self.cutArr[row];
    NSString * rowStr = [NSString stringWithFormat:@"%zi",row];
    CGFloat rowNum = [rowStr floatValue]/10;
    self.cutInter = 9 - rowNum;
    [self saveAvtion];
}

- (void)saveAvtion{

    self.cutShowLabel.text = @"最低折扣不能低于9折，每日只能设置1次折扣";
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

#pragma mark - Http
- (void)requestSendCut{
    NSString * cutInterStr = [NSString stringWithFormat:@"%.1f",self.cutInter*10];
    NSInteger cutInterNS = [cutInterStr integerValue]  ;
    if (cutInterNS == 0) {
        [JRToast showWithText:@"当前折扣相同或为0，请重新选择折扣" duration:2];
        return;
    }
    if (cutInterNS >= 100) {
        cutInterNS = 9;
    }
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"discount":@([[NSString stringWithFormat:@"0.%zi",cutInterNS] floatValue])};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_SetDiscount withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [UserSession instance].cut = self.cutInter;

        NSMutableArray * shopArr = [NSMutableArray arrayWithArray:self.model.dataArr[2]];
        NSString * showName = [NSString stringWithFormat:@"%.1f折",self.cutInter ];
        
        [shopArr replaceObjectAtIndex:1 withObject:showName];
        [self.model.dataArr replaceObjectAtIndex:2 withObject:shopArr];
        self.currentCutLabel.text = [NSString stringWithFormat:@"当前折扣%@",showName];
        [self showHUDWithStr:@"折扣设置成功" withSuccess:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        if ([responsObj[@"errorCode"] integerValue] == 1) {
            if (cutInterNS == 0) {
                [JRToast showWithText:@"当前折扣相同或为0，请重新选择折扣" duration:2];
            }
            [self showHUDWithStr:@"折扣设置失败,每天只能设置一次折扣哦" withSuccess:YES];
        }
    }];
}

@end
