//
//  YWPCChooseTimeViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCChooseTimeViewController.h"
#import "YWPCChooseWeekViewController.h"
#import "YWPCCHooseTimePickerView.h"
#import "YWPCTWeekDayTableViewCell.h"
#import "YWPCTIsAllDayTableViewCell.h"
#import "YWPCTDayTimeTableViewCell.h"
#import "YWPCTTimeNameTableViewCell.h"
#import "YWPCTDayTimeAddTableViewCell.h"

#import "YWPersonShopModel.h"
#import "YWPCChooseTimeModel.h"

@interface YWPCChooseTimeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * headerArr;
@property (nonatomic,strong)YWPCCHooseTimePickerView * timePicker;
@property (nonatomic,strong)YWPCChooseTimeModel * model;

@end

@implementation YWPCChooseTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self dataSet];
}
- (void)makeUI{
    self.title = @"添加营业时间";
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
    self.model = [[YWPCChooseTimeModel alloc]init];
    
    WEAKSELF;
    self.timePicker = [[YWPCCHooseTimePickerView alloc]initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, kScreen_Height - 64.f)];
    self.timePicker.hidden = YES;
    self.timePicker.saveBlock = ^(NSString * startTime,NSString * finishTime){
        YWPCChooseSubTimeModel * model = [weakSelf.model.payTimeArr lastObject];
        model.time = [NSString stringWithFormat:@"%@-%@",startTime,finishTime];
        weakSelf.timePicker.hidden = YES;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:(weakSelf.model.payTimeArr.count + 1)]] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.view addSubview:self.timePicker];
}

- (void)dataSet{
    NSArray * typeNameArr = @[@"    添加每周营业日",@"    添加营业时间和名称"];
    self.headerArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < typeNameArr.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15.f, 0.f, kScreen_Width - 30.f, 38.f)];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.text = typeNameArr[i];
        label.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
        [self.headerArr addObject:label];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YWPCTWeekDayTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWPCTWeekDayTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWPCTIsAllDayTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWPCTIsAllDayTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWPCTDayTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWPCTDayTimeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWPCTTimeNameTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWPCTTimeNameTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWPCTDayTimeAddTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWPCTDayTimeAddTableViewCell"];
}
- (IBAction)submitBtnAction:(id)sender {
    [self requestUpData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.isPayAllDay?2:(self.model.payTimeArr.count + 3);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section < 2?1:(section >= (self.model.payTimeArr.count + 2)?1:2);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YWPCTWeekDayTableViewCell * weekCell = [tableView dequeueReusableCellWithIdentifier:@"YWPCTWeekDayTableViewCell"];
        weekCell.nameLabel.text = [self.model.payDays isEqualToString:@""]?@"未提交":self.model.payDays;
        weekCell.nameLabel.textColor = [UIColor colorWithHexString:[self.model.payDays isEqualToString:@""]?@"#cccccc":@"#000000"];
        return weekCell;
    }else if (indexPath.section == 1){
        YWPCTIsAllDayTableViewCell * allDayCell = [tableView dequeueReusableCellWithIdentifier:@"YWPCTIsAllDayTableViewCell"];
        allDayCell.payAllDayBlock = ^(BOOL isPayAllDay){
            self.model.isPayAllDay = isPayAllDay;
            [tableView reloadData];
        };
        allDayCell.isPayAllDay = self.model.isPayAllDay;
        return allDayCell;
    }else if (!self.model.isPayAllDay && indexPath.section >= self.model.payTimeArr.count + 2){
        YWPCTDayTimeAddTableViewCell * addCell = [tableView dequeueReusableCellWithIdentifier:@"YWPCTDayTimeAddTableViewCell"];
        return addCell;
    }else{
        if (indexPath.row == 0) {
            YWPCTDayTimeTableViewCell * timeCell = [tableView dequeueReusableCellWithIdentifier:@"YWPCTDayTimeTableViewCell"];
            YWPCChooseSubTimeModel * timeModel = self.model.payTimeArr[indexPath.section - 2];
            timeCell.nameLabel.text = timeModel.time?timeModel.time:@"未提交";
            timeCell.nameLabel.textColor = [UIColor colorWithHexString:timeModel.time?@"#000000":@"#cccccc"];
            return timeCell;
        }else{
            YWPCTTimeNameTableViewCell * nameCell = [tableView dequeueReusableCellWithIdentifier:@"YWPCTTimeNameTableViewCell"];
            YWPCChooseSubTimeModel * timeModel = self.model.payTimeArr[indexPath.section - 2];
            __weak typeof(nameCell)weakNameCell = nameCell;
            nameCell.namedBlock = ^(NSString * name){
                timeModel.name = name;
                weakNameCell.nameTextField.text = name;
            };
            nameCell.nameTextField.text = timeModel.name;
            return nameCell;
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section<2?38.f:10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section < 2)return self.headerArr[section];
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YWPCChooseWeekViewController * vc = [[YWPCChooseWeekViewController alloc]init];
        vc.saveWeekInfoBlock = ^(NSMutableArray * weekDayArr){
            YWPCTWeekDayTableViewCell * weekCell = [tableView cellForRowAtIndexPath:indexPath];
            if (weekDayArr.count>=7) {
                self.model.payDays = @"全周";
            }else{
                self.model.payDays = weekDayArr[0];
                for (int i = 1; i<weekDayArr.count; i++) {
                    self.model.payDays = [NSString stringWithFormat:@"%@,%@",self.model.payDays,weekDayArr[i]];
                }
            }
            weekCell.nameLabel.text = self.model.payDays;
            weekCell.nameLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if (!self.model.isPayAllDay && indexPath.section >= self.model.payTimeArr.count + 2){
        if ([self.model.payTimeArr lastObject].time) {
            [self.model.payTimeArr addObject:[[YWPCChooseSubTimeModel alloc]init]];
            [tableView reloadData];
        }else{
            [self showHUDWithStr:@"请填写营业时间哟" withSuccess:NO];
        }
        return;
    }else if (!self.model.isPayAllDay &&indexPath.section >= 2 && indexPath.row == 0){
        self.timePicker.hidden = NO;
    }
}

#pragma mark - Http
- (void)requestUpData{
    for (int i = 0; i<self.model.payTimeArr.count; i++) {
        YWPCChooseSubTimeModel * model = self.model.payTimeArr[i];
        if (!model.time)break;
        NSDictionary * dataDic = @{@"payDays":self.model.payDays,@"name":(model.name?model.name:@"营业时间"),@"time":model.time};
        MyLog(@"%@",dataDic);
        NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"time":[JWTools dictionaryToJson:dataDic]};
        
        [[HttpObject manager]postDataWithType:YuWaType_Shoper_SetBusinessHours withPragram:pragram success:^(id responsObj) {
            MyLog(@"Regieter Code pragram is %@",pragram);
            MyLog(@"Regieter Code is %@",responsObj);
            if (i >= self.model.payTimeArr.count-1) {
                [self showHUDWithStr:@"设置成功" withSuccess:YES];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        } failur:^(id responsObj, NSError *error) {
            MyLog(@"Regieter Code pragram is %@",pragram);
            MyLog(@"Regieter Code error is %@",responsObj);
        }];
        if (self.model.isPayAllDay)break;
    }
}


@end
