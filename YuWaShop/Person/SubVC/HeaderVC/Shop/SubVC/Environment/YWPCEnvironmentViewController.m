//
//  YWPCEnvironmentViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCEnvironmentViewController.h"
#import "YWPersonShopModel.h"
#import "YWPCEOnTableViewCell.h"
#import "YWPCESelTableViewCell.h"

@interface YWPCEnvironmentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)YWPersonShopModel * model;

@property (nonatomic,strong)NSMutableArray * headerArr;
@property (nonatomic,strong)NSMutableArray * nameArr;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic,assign)NSInteger parkChoose;

@end

@implementation YWPCEnvironmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self dataSet];
    [self requestData];
}

- (void)makeUI{
    self.title = @"环境配套设置";
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
}

- (void)dataSet{
    NSArray * typeNameArr = @[@"    停车信息",@"    免费WIFI",@"    环境信息",@"    更多配备设施"];
    self.nameArr = [NSMutableArray arrayWithArray:@[@[@"不显示停车信息",@"免费停车",@"付费停车",@"无停车位"],@[@"免费WIFI"],@[@"有吸烟区",@"有包厢",@"有卡座",@"有沙发位",@"有露天位",@"有景观位",@"有宝宝椅"],@[@"有表演",@"有儿童游乐区",@"有旋转餐厅"]]];
    self.parkChoose = 0;
    self.model = [YWPersonShopModel sharePersonShop];
    if (self.model.environmentDataArr) {
        [self.model.environmentDataArr[0] enumerateObjectsUsingBlock:^(NSString * _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([str isEqualToString:@"1"]) {
                self.parkChoose = idx;
            }
        }];
    }
    self.dataArr = [NSMutableArray arrayWithArray:@[@[@"1",@"0",@"0",@"0"],@[@"0"],@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"],@[@"0",@"0",@"0"]]];
    self.headerArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < typeNameArr.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15.f, 0.f, kScreen_Width - 30.f, 38.f)];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor colorWithHexString:@"#bebec0"];
        label.text = typeNameArr[i];
        label.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
        [self.headerArr addObject:label];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"YWPCESelTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWPCESelTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWPCEOnTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWPCEOnTableViewCell"];
    
    [self requestData];
}

- (IBAction)submitBtnAction:(id)sender {
    [self requestUpData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.nameArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.nameArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YWPCESelTableViewCell * selCell = [tableView dequeueReusableCellWithIdentifier:@"YWPCESelTableViewCell"];
        selCell.nameLabel.text = self.nameArr[indexPath.section][indexPath.row];
        selCell.isChoosed = [self.dataArr[indexPath.section][indexPath.row] isEqualToString:@"1"];
        return selCell;
    }
    WEAKSELF;
    YWPCEOnTableViewCell * onCell = [tableView dequeueReusableCellWithIdentifier:@"YWPCEOnTableViewCell"];
    onCell.nameLabel.text = self.nameArr[indexPath.section][indexPath.row];
    onCell.isChoosed = [self.dataArr[indexPath.section][indexPath.row] isEqualToString:@"1"];
    onCell.chooseBlock = ^(BOOL isChoosed){
        NSMutableArray * dataArr = [NSMutableArray arrayWithArray:weakSelf.dataArr[indexPath.section]];
        [dataArr replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%@",isChoosed?@"1":@"0"]];
        [weakSelf.dataArr replaceObjectAtIndex:indexPath.section withObject:dataArr];
    };
    return onCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerArr[section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSMutableArray * dataArr = [NSMutableArray arrayWithArray:self.dataArr[indexPath.section]];
        if (self.parkChoose < 4) {
            YWPCESelTableViewCell * selLastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.parkChoose inSection:0]];
            selLastCell.isChoosed = NO;
            [dataArr replaceObjectAtIndex:self.parkChoose withObject:@"0"];
        }
        YWPCESelTableViewCell * selCell = [tableView cellForRowAtIndexPath:indexPath];
        selCell.isChoosed = !selCell.isChoosed;
        
        [dataArr replaceObjectAtIndex:indexPath.row withObject:[NSString stringWithFormat:@"%@",selCell.isChoosed?@"1":@"0"]];
        self.parkChoose = indexPath.row;
        [self.dataArr replaceObjectAtIndex:indexPath.section withObject:dataArr];
    }
}

#pragma mark - Http
- (void)requestData{
    if (self.model.environmentDataArr){
        self.dataArr = [NSMutableArray arrayWithArray:self.model.environmentDataArr];
        [self.tableView reloadData];
        return;
    }
    
    NSMutableDictionary * pragram = [NSMutableDictionary dictionaryWithDictionary:@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)}];
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_GetEnvironment withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSDictionary * dataDic = responsObj[@"data"];
        NSMutableArray * dataArrTemp = [NSMutableArray arrayWithArray:@[@[@"wifi"],@[@"smoke",@"payroom",@"cassette",@"sofa",@"outdoor",@"sight",@"baby"],@[@"perform",@"playground",@"revolving"]]];
        
        for (int i = 0; i<dataArrTemp.count; i++) {
            NSMutableArray * tagSubArr = [NSMutableArray arrayWithArray:dataArrTemp[i]];
            for (int j = 0; j<tagSubArr.count; j++) {
                [tagSubArr replaceObjectAtIndex:j withObject:dataDic[tagSubArr[j]]?dataDic[tagSubArr[j]]:@"0"];
            }
            [dataArrTemp replaceObjectAtIndex:i withObject:tagSubArr];
        }
        self.parkChoose = [(dataDic[@"park"]&&![dataDic[@"park"] isKindOfClass:[NSNull class]]?dataDic[@"park"]:@"0") integerValue];
        NSMutableArray * parkArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<4; i++) {
            [parkArr addObject:(self.parkChoose==i?@"1":@"0")];
        }
        [dataArrTemp insertObject:parkArr atIndex:0];
        self.dataArr = dataArrTemp;
        self.model.environmentDataArr = [NSMutableArray arrayWithArray:dataArrTemp];
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}
- (void)requestUpData{
    NSArray * dataTagArr = @[@[@"wifi"],@[@"smoke",@"payroom",@"cassette",@"sofa",@"outdoor",@"sight",@"baby"],@[@"perform",@"playground",@"revolving"]];
    
    NSMutableDictionary * pragram = [NSMutableDictionary dictionaryWithDictionary:@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"park":@(self.parkChoose)}];
    for (int i = 0; i<dataTagArr.count; i++) {
        NSArray * tagSubArr = dataTagArr[i];
        for (int j = 0; j<tagSubArr.count; j++) {
            [pragram setObject:@([self.dataArr[i+1][j] integerValue]) forKey:tagSubArr[j]];
        }
    }
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_SetEnvironment withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        self.model.environmentDataArr = self.dataArr;
        NSArray * nameArr = @[@[@"免费WIFI"],@[@"有吸烟区",@"有包厢",@"有卡座",@"有沙发位",@"有露天位",@"有景观位",@"有宝宝椅"],@[@"有表演",@"有儿童游乐区",@"有旋转餐厅"]];
        NSMutableArray * nameAddArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 1; i < self.dataArr.count; i++) {
            NSArray * dataSubArr = self.dataArr[i];
            for (int j = 0; j<dataSubArr.count; j++) {
                if ([dataSubArr[j] isEqualToString:@"1"]) {
                    [nameAddArr addObject:nameArr[i-1][j]];
                }
            }
        }
        
        if (nameAddArr.count>1) {
            [UserSession instance].infrastructure = nameAddArr[0];
            for (int i = 1; i<nameAddArr.count; i++) {
                if (i>2)break;
                [UserSession instance].infrastructure = [NSString stringWithFormat:@"%@,%@",[UserSession instance].infrastructure,nameAddArr[i]];
            }
        }else if (nameAddArr.count == 1){
            [UserSession instance].infrastructure = nameAddArr[0];
        }else if(self.parkChoose > 0){
            NSArray * parkNameArr = @[@"不显示停车信息",@"免费停车",@"付费停车",@"无停车位"];
            [UserSession instance].infrastructure = parkNameArr[self.parkChoose];
        }else{
            [UserSession instance].infrastructure = @"暂无设置";
        }
        
        NSMutableArray * shopArr = [NSMutableArray arrayWithArray:self.model.dataArr[2]];
        [shopArr replaceObjectAtIndex:2 withObject:[UserSession instance].infrastructure];
        [self.model.dataArr replaceObjectAtIndex:2 withObject:shopArr];
        [self showHUDWithStr:@"环境配套设置成功" withSuccess:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        [self showHUDWithStr:responsObj[@"errorMessage"] withSuccess:NO];
    }];
}

@end
