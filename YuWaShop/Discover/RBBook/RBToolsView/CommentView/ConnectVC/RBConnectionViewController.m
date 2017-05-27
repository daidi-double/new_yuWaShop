//
//  RBConnectionViewController.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/14.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBConnectionViewController.h"
#import "UIScrollView+JWGifRefresh.h"
#import "HttpObject.h"
#import "JWTools.h"

#import "RBNodeUserModel.h"

@interface RBConnectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UIView * headerView;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;

@end

@implementation RBConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataSet];
//    [self setupRefresh];
    [self requestDataWithPages:0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([[[UIApplication sharedApplication].delegate.window.subviews lastObject] isKindOfClass:[MBProgressHUD class]])[[[UIApplication sharedApplication].delegate.window.subviews lastObject] removeFromSuperview];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.pagens = @"20";
}

- (IBAction)backBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataArr.count) {
        RBNodeUserModel * model = self.dataArr[indexPath.row];
        [self dismissViewControllerAnimated:YES completion:^{
            self.connectNameBlock(model.nickname);
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 21.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.headerView) {
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 21.f)];
        self.headerView.backgroundColor = [UIColor whiteColor];
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, kScreen_Width - 20.f, 21.f)];
        nameLabel.text = @"关注的用户";
        nameLabel.textColor = [UIColor lightGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:13.f];
        [self.headerView addSubview:nameLabel];
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 20.f, kScreen_Width, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#F3F6F8"];
        [self.headerView addSubview:lineView];
    }
    return self.headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSInteger cellCountDefault = (self.tableView.height - 21.f) /44.f + 1;

    return self.dataArr.count;
//    return cellCountDefault>self.dataArr.count?cellCountDefault:self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * userCell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if (!userCell) {
        userCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"userCell"];
    }
    userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    userCell.imageView.layer.cornerRadius = 22.f;
    userCell.imageView.layer.masksToBounds = YES;
    userCell.detailTextLabel.textColor = CsubtitleColor;
    if (![userCell viewWithTag:1001] && indexPath.row!=0) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#F3F6F8"];
        lineView.tag = 1001;
        [userCell addSubview:lineView];
    }
    if (indexPath.row < self.dataArr.count) {
        RBNodeUserModel * model = self.dataArr[indexPath.row];
        [userCell.imageView sd_setImageWithURL:[NSURL URLWithString:model.images] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
        userCell.textLabel.text = model.nickname;
        userCell.detailTextLabel.text = [NSString stringWithFormat:@"%@个粉丝",model.fans_total];
    }
    
    return userCell;
}

#pragma mark - TableView Refresh
//- (void)setupRefresh{
//    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
//        [self footerRereshing];
//    }];
//}
//- (void)footerRereshing{
//    self.pages++;
//    [self requestDataWithPages:self.pages];
//}

#pragma mark - Http
- (void)requestDataWithPages:(NSInteger)page{
//    [self.tableView.mj_footer endRefreshing];
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    
    [[HttpObject manager]postDataWithType:YuWaType_RB_ATTENTION withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSArray * dataArr = responsObj[@"data"];
        for (int i = 0; i<dataArr.count; i++) {
            NSDictionary * dataDic = dataArr[i];
            NSDictionary * dicTemp = @{@"images":dataDic[@"header_img"]?dataDic[@"header_img"]:@"",@"nickname":dataDic[@"nickname"]?dataDic[@"nickname"]:@"",@"fans_total":dataDic[@"fans"]?dataDic[@"fans"]:@"0",@"userid":dataDic[@"uid"]?dataDic[@"uid"]:@"0"};
            [self.dataArr addObject:[RBNodeUserModel yy_modelWithDictionary:dicTemp]];
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
    
}


@end
