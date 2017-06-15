//
//  ShopAccountViewController.m
//  雨掌柜
//
//  Created by double on 17/6/13.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShopAccountViewController.h"
#import "ChildAccountShopTableViewCell.h"



#define CHILDSHOPCELL  @"ChildAccountShopTableViewCell"
@interface ShopAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * shopTableView;
@property (nonatomic,strong)NSMutableArray * accountAry;//账号数据
@end

@implementation ShopAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestShopData];
    [self makeUI];
}

- (void)makeUI{
    self.title = @"我的门店";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shopTableView];
    [self.shopTableView registerNib:[UINib nibWithNibName:CHILDSHOPCELL bundle:nil] forCellReuseIdentifier:CHILDSHOPCELL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.accountAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChildAccountShopTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CHILDSHOPCELL];
    MainAccountListModel * model = self.accountAry[indexPath.row];
    cell.model = model;
    cell.accountNameLabel.hidden = NO;
    cell.managerLabel.hidden = NO;
    cell.addImageView.hidden = YES;
    cell.addLabel.hidden = YES;
    if ([model.is_current integerValue] == 1) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;//打钩标记
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainAccountListModel * model = self.accountAry[indexPath.row];
    if (self.shopBlock) {
        self.shopBlock(model.company_name,model.id);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (void)requestShopData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_MAINACCOUNTLIST];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID]};
    HttpManager * manager = [[HttpManager alloc]init];

    [manager postDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@ ~~~~ %@",pragarms,urlStr);
        MyLog(@"主账号列表%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.accountAry removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                MainAccountListModel * model = [MainAccountListModel yy_modelWithDictionary:dict];
                if (self.status == 1) {
                    
                    if ([model.isChild integerValue] == 0 && [model.is_current integerValue]==1) {
                        
                        [self.accountAry addObject:model];
                    }
                }else{
                    if ([model.isChild integerValue] == 0) {
                        
                        [self.accountAry addObject:model];
                    }

                }
            }
            
        }
        [self.shopTableView reloadData];

    }];
}
//懒加载
- (UITableView*)shopTableView{
    if (!_shopTableView) {
        _shopTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _shopTableView.delegate = self;
        _shopTableView.dataSource = self;
        
    }
    return _shopTableView;
}

- (NSMutableArray*)accountAry{
    if (!_accountAry) {
        _accountAry = [NSMutableArray array];
    }
    return _accountAry;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
