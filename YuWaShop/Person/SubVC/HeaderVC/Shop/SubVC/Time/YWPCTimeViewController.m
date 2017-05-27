//
//  YWPCTimeViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCTimeViewController.h"
#import "YWPCTimeTableViewCell.h"
#import "YWPersonShopModel.h"
#import "YWPCChooseTimeViewController.h"
#import "YWPersonShopModel.h"

@interface YWPCTimeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic,strong)NSMutableArray * timeArr;
@property (nonatomic,strong)YWPersonShopModel * model;

@end

@implementation YWPCTimeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"营业时间";
    [self dataSet];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSDictionary * dataDic;
    if (self.timeArr.count>0) {
        YWPCTimeModel * model = self.timeArr[0];
        dataDic = @{@"payDays":model.payDays,@"name":(model.name?model.name:@"营业时间"),@"time":model.time};
    }else{
        dataDic = @{@"payDays":@"",@"name":@"",@"time":@""};
    }
    [YWPersonShopModel sharePersonShop].headerModel.business_time = dataDic;
    NSMutableArray * shopArr = [NSMutableArray arrayWithArray:[YWPersonShopModel sharePersonShop].dataArr[1]];
    [shopArr replaceObjectAtIndex:2 withObject:(dataDic[@"payDays"]?:@"")];
    [[YWPersonShopModel sharePersonShop].dataArr replaceObjectAtIndex:1 withObject:shopArr];
}

- (IBAction)submitBtnAction:(id)sender {
    [self addTimeAction];
}

- (void)dataSet{
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
    self.model = [YWPersonShopModel sharePersonShop];
    
    self.timeArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWPCTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWPCTimeTableViewCell"];
}

- (void)addTimeAction{
    YWPCChooseTimeViewController * vc = [[YWPCChooseTimeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YWPCTimeModel * model = self.timeArr[indexPath.row];
            [self requestDelTimeWithID:model.timeID withIndexPath:indexPath];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除经营时间?" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.timeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWPCTimeTableViewCell * timeCell = [tableView dequeueReusableCellWithIdentifier:@"YWPCTimeTableViewCell"];
    timeCell.model = self.timeArr[indexPath.row];
    return timeCell;
}

#pragma mark - Http
- (void)requestData{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_GetBusinessHours withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.timeArr removeAllObjects];
        NSArray * dataArr = responsObj[@"data"];
        for (int i = 0; i < dataArr.count; i++) {
            NSDictionary * dataDic = dataArr[i];
            YWPCTimeModel * model = [YWPCTimeModel yy_modelWithDictionary:[JWTools dictionaryWithJsonString:dataDic[@"time"]]];
            model.timeID = dataArr[i][@"id"];
            if (model)[self.timeArr addObject:model];
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

- (void)requestDelTimeWithID:(NSString *)timeID withIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":timeID};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_DelBusinessHours withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.timeArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self showHUDWithStr:@"删除成功" withSuccess:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
