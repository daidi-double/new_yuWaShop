//
//  YWPersonShopViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonShopViewController.h"
#import "YWPersonShopHeaderView.h"
#import "YWPersonShopTableViewCell.h"
#import "YWPersonShopModel.h"
#import "YWPCBasicSetViewController.h"
#import "YWPCMapViewController.h"
#import "YWPCTimeViewController.h"
#import "YWPCEnvironmentViewController.h"
#import "YWPCEveryPayViewController.h"
#import "YWPCCutSetViewController.h"
#import "YWPCCounselorViewController.h"
#import "ChildAccountViewController.h"//子账号

@interface YWPersonShopViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)YWPersonShopModel * model;
@property (nonatomic,strong)YWPersonShopHeaderView * headerView;
@property (nonatomic,strong)NSMutableArray * headerArr;
@property (nonatomic,strong)NSArray * nameArr;
@property (nonatomic,strong)NSArray * subViewClassArr;

@end

@implementation YWPersonShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店管理";
    [self dataSet];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
    [self.tableView reloadData];
}

- (void)dataSet{
    NSArray * typeNameArr = @[@"",@"    基础信息",@"    子账号管理",@"    附加信息",@"    寻求帮助"];
    self.nameArr = @[@[],@[@"基本信息",@"门店地图",@"营业时间"],@[@"子账号"],@[@"人均消费",@"折扣设置",@"环境设置"],@[@"营销顾问"]];
    self.subViewClassArr = @[@[],@[[YWPCBasicSetViewController class],[YWPCMapViewController class],[YWPCTimeViewController class]],@[[ChildAccountViewController class]],@[[YWPCEveryPayViewController class],[YWPCCutSetViewController class],[YWPCEnvironmentViewController class]],@[[YWPCCounselorViewController class]]];
    self.model = [YWPersonShopModel sharePersonShop];
    self.headerArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i < typeNameArr.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15.f, 0.f, kScreen_Width - 30.f, 38.f)];
        label.font = [UIFont boldSystemFontOfSize:13.f];
        label.textColor = [UIColor colorWithHexString:@"#bebec0"];
        label.text = typeNameArr[i];
        label.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
        [self.headerArr addObject:label];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"YWPersonShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWPersonShopTableViewCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2) {
        return 1;
    }
    return [self.model.dataArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWPersonShopTableViewCell * shopCell = [tableView dequeueReusableCellWithIdentifier:@"YWPersonShopTableViewCell"];
    shopCell.nameLabel.text = self.nameArr[indexPath.section][indexPath.row];
    shopCell.detailLabel.text = self.model.dataArr[indexPath.section][indexPath.row];
    return shopCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?94.f:38.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (!self.headerView) {
            self.headerView = [[[NSBundle mainBundle]loadNibNamed:@"YWPersonShopHeaderView" owner:nil options:nil]firstObject];
            self.headerView.frame = CGRectMake(0.f, 0.f, kScreen_Width, 94.f);
            [self.headerView setNeedsLayout];
        }
        [self.headerView refreshUI];
        if (self.model.headerModel) {
            self.headerView.model = self.model.headerModel;
        }
        return self.headerView;
    }else{
        return self.headerArr[section - 1];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 0) {
        Class vcClass = self.subViewClassArr[indexPath.section][indexPath.row];
        UIViewController * vc = [[vcClass alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Http
- (void)requestData{
//    if (self.model.headerModel)return;
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    
    [[HttpObject manager]postDataWithType:YuWaType_ShopAdmin_Home withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        
        self.model.headerModel = [YWPersonShopHeaderModel yy_modelWithDictionary:responsObj[@"data"]];
        if (self.model.headerModel.business_hours) {
            if (self.model.headerModel.business_hours.count>0) {
                self.model.headerModel.business_time = [JWTools dictionaryWithJsonString:self.model.headerModel.business_hours[0][@"time"]];
            }
        }
        [UserSession instance].nickName = self.model.headerModel.company_name;


        if ((NSInteger)(([self.model.headerModel.discount floatValue]*10)>1)) {
            [UserSession instance].cut = [self.model.headerModel.discount floatValue];
        }
        [UserSession instance].logo = self.model.headerModel.company_img;
        MyLog(@"%f",[UserSession instance].cut);
        NSInteger cut = [self.model.headerModel.discount floatValue]*100;
        NSString * showCut;
        if (cut%10 == 0) {  
            showCut = [NSString stringWithFormat:@"%.0f折",[self.model.headerModel.discount floatValue]*10];
        }else{
            showCut = [NSString stringWithFormat:@"%.1f折",[self.model.headerModel.discount floatValue]*10];
        }
        self.model.dataArr = [NSMutableArray arrayWithArray:@[@[],@[[UserSession instance].nickName,([self.model.headerModel.is_map integerValue]==0?@"无地图":@"有地图"),(self.model.headerModel.business_time[@"payDays"]?:@"暂无设置")],@[@"管理子账号"],@[[NSString stringWithFormat:@"%@元",self.model.headerModel.per_capita],showCut,[UserSession instance].infrastructure],@[@""]]];
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
