//
//  MyChildAccountViewController.m
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MyChildAccountViewController.h"
#import "ChildAccountTableViewCell.h"
#import "JWSearchView.h"
#import "UIBarButtonItem+SettingCustom.h"
#import "ChildAccountViewController.h"


#define CHILDCELL @"ChildAccountTableViewCell"
@interface MyChildAccountViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *accountTableView;
@property (nonatomic,strong)JWSearchView * searchView;

@end

@implementation MyChildAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}

- (void)makeUI{
    
    self.searchView = [[[NSBundle mainBundle]loadNibNamed:@"JWSearchView" owner:nil options:nil]firstObject];
    self.searchView.plachoderLabel.text = @"搜索门店";
    WEAKSELF;
    self.searchView.searchClik = ^(){
        [weakSelf searchBtnAction];
    };
    self.navigationItem.titleView = self.searchView;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"搜索" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside withWidth:60];
    
    [self.accountTableView registerNib:[UINib nibWithNibName:CHILDCELL bundle:nil] forCellReuseIdentifier:CHILDCELL];
    self.accountTableView.separatorStyle = NO;

}
- (void)searchBtnAction{

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChildAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CHILDCELL];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 35)];
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, kScreen_Width*0.8f, 35)];
        titleLabel.textColor = RGBCOLOR(89, 90, 91, 1);
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"所有门店";
        [bgView addSubview:titleLabel];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myAllAccount)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [bgView addGestureRecognizer:tap];
        
        UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 23, 0, 8, 15)];
        rightImageView.centerY = bgView.centerY;
        rightImageView.image = [UIImage imageNamed:@"右箭头"];
        [bgView addSubview:rightImageView];
        
        return bgView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 35.f;
    }
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.nameBlock(@"我的门店");//修改
    [self.navigationController popViewControllerAnimated:YES];
}
//返回上一级界面，刷新数据
- (void)myAllAccount{
    self.nameBlock(@"所有门店");
    [self.navigationController popViewControllerAnimated:YES];
    
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
