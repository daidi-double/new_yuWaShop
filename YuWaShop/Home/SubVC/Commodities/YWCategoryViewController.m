//
//  YWCategoryViewController.m
//  YuWaShop
//
//  Created by double on 17/4/26.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWCategoryViewController.h"
#import "AddShopCategoryViewController.h"
#import "YWHomeCommoditiesVC.h"
#import "YWCategoryModel.h"
@interface YWCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UIButton *subCommitBtn;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,strong)NSMutableArray * dataArr;
@end

@implementation YWCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"分类管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.categoryTableView.backgroundColor = [UIColor whiteColor];
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self makeUI];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDataWithPages:0];
    [self.categoryTableView.mj_header beginRefreshing];
    
}
- (IBAction)subCommitAction:(UIButton *)sender {
    AddShopCategoryViewController * vc = [[AddShopCategoryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
 
}

- (void)makeUI{
    self.subCommitBtn.layer.cornerRadius = 5.f;
    self.subCommitBtn.layer.masksToBounds = YES;
    UIBarButtonItem * editBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(touchAction:)];
    
    self.navigationItem.rightBarButtonItem = editBtn;

}

- (void)touchAction:(UIBarButtonItem*)sender{
    self.categoryTableView.editing = !self.categoryTableView.editing;
    if (self.categoryTableView.editing == YES) {
        [sender setTitle:@"完成"];
        
    }else{
        [sender setTitle:@"编辑"];
        
    }
}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.categoryTableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    self.categoryTableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = RGBCOLOR(80, 88, 88, 1);
    YWCategoryModel * model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.cat_name;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWHomeCommoditiesVC * addVC = [[YWHomeCommoditiesVC alloc]init];
    YWCategoryModel * model = self.dataArr[indexPath.row];
    addVC.catID = model.id;
    [self.navigationController pushViewController:addVC animated:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * cancelAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            YWCategoryModel * model = self.dataArr[indexPath.row];
            [self requestDelWithID:model.id withIndexPath:indexPath];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除此分类?" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
    }];
    UITableViewRowAction * recompose = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"修改" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        AddShopCategoryViewController * vc = [[AddShopCategoryViewController alloc]init];
        vc.status = 1;
        YWCategoryModel * model = self.dataArr[indexPath.row];
        vc.categoryName = model.cat_name;
        vc.cat_id = model.id;
        self.categoryTableView.editing = !self.categoryTableView.editing;
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    return @[cancelAction,recompose];
}

//删除分类
- (void)requestDelWithID:(NSString *)commoditiesID withIndexPath:(NSIndexPath *)indexPath{
//        YWCategoryModel * model = self.dataArr[indexPath.row];
    
        NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"cat_id":@([commoditiesID integerValue])};
    
        [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_DelCategory withPragram:pragram success:^(id responsObj) {
            MyLog(@"Regieter Code pragram is %@",pragram);
            MyLog(@"Regieter Code is %@",responsObj);
            [JRToast showWithText:responsObj[@"data"] duration:1];
            [self.dataArr removeObjectAtIndex:indexPath.row];
            [self.categoryTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//            [self.tableView reloadData];
        } failur:^(id responsObj, NSError *error) {
            [JRToast showWithText:responsObj[@"errorMessage"] duration:1];
            MyLog(@"Regieter Code pragram is %@",pragram);
            MyLog(@"Regieter Code error is %@",responsObj);
            
        }];
}
#pragma mark - Http
- (void)requestDataWithPages:(NSInteger)page{

    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SHOP_SHOPADMIN_CATEGORY];
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":@([self.pagens integerValue]),@"pages":@(page)};
    
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",data);
        if (page == 0)[self.dataArr removeAllObjects];
        NSArray * dataArr = data[@"data"];
        for (int i = 0; i<dataArr.count; i++) {
            YWCategoryModel * model = [YWCategoryModel yy_modelWithDictionary:dataArr[i]];
            [self.dataArr addObject:model];
        }
        [self.categoryTableView reloadData];
        [self.categoryTableView.mj_header endRefreshing];
        [self.categoryTableView.mj_footer endRefreshing];
    }];
    
}

- (NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
