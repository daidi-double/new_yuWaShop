//
//  YWHomeCommoditiesVC.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeCommoditiesVC.h"
#import "YWHomeAddCommoditiesVC.h"
#import "YWHomeCommoditiesTableViewCell.h"

@interface YWHomeCommoditiesVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addCommoditiesBtn;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation YWHomeCommoditiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品管理";
    [self makeUI];
    [self dataSet];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    [self.navigationController setNavigationBarHidden:NO     animated:YES];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}
- (void)makeUI{
    self.addCommoditiesBtn.layer.cornerRadius = 5.f;
    self.addCommoditiesBtn.layer.masksToBounds = YES;
    UIBarButtonItem * editBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(touchAction:)];
    
    self.navigationItem.rightBarButtonItem = editBtn;
}
- (void)touchAction:(UIBarButtonItem*)sender{
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing == YES) {
        [sender setTitle:@"完成"];
       
    }else{
        [sender setTitle:@"编辑"];

    }
}
- (void)dataSet{
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWHomeCommoditiesTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWHomeCommoditiesTableViewCell"];
}

- (IBAction)addCommoditiesBtnAction:(id)sender {
    YWHomeAddCommoditiesVC * vc = [[YWHomeAddCommoditiesVC alloc]init];
    vc.staues = 0;
    vc.catID = self.catID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * cancelAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YWHomeCommoditiesModel * model = self.dataArr[indexPath.row];
            [self requestDelWithID:model.commoditiesID withIndexPath:indexPath];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除此商品?" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
    }];
    UITableViewRowAction * recompose = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        YWHomeAddCommoditiesVC * vc = [[YWHomeAddCommoditiesVC alloc]init];
        vc.shopDataArr = self.dataArr;
        vc.row = indexPath.row;
        vc.staues = 1;
        self.tableView.editing = !self.tableView.editing;
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    return @[cancelAction,recompose];
}
//- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle ==UITableViewCellEditingStyleDelete){
//        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            YWHomeCommoditiesModel * model = self.dataArr[indexPath.row];
//            [self requestDelWithID:model.commoditiesID withIndexPath:indexPath];
//        }];
//        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除此商品?" preferredStyle:UIAlertControllerStyleAlert];
//        [alertVC addAction:cancelAction];
//        [alertVC addAction:OKAction];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
//    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWHomeCommoditiesTableViewCell * commoditiesCell = [tableView dequeueReusableCellWithIdentifier:@"YWHomeCommoditiesTableViewCell"];
    commoditiesCell.model = self.dataArr[indexPath.row];
    return commoditiesCell;
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestDataWithPages:0];
}

- (void)footerRereshing{
    self.pages++;
    [self requestDataWithPages:self.pages];
}

- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Http
- (void)requestDataWithPages:(NSInteger)page{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":@([self.pagens integerValue]),@"pages":@(page),@"goods_cat_id":self.catID};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_GoodsLists withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page == 0)[self.dataArr removeAllObjects];
        NSArray * dataArr = responsObj[@"data"];
        for (int i = 0; i<dataArr.count; i++) {
            YWHomeCommoditiesModel * model = [YWHomeCommoditiesModel yy_modelWithDictionary:dataArr[i]];
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}
//删除商品
- (void)requestDelWithID:(NSString *)commoditiesID withIndexPath:(NSIndexPath *)indexPath{
    YWHomeCommoditiesModel * model = self.dataArr[indexPath.row];
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"goods_id":@([model.commoditiesID integerValue])};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_DelGoods withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
