//
//  RBPublicLocationViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RBPublicLocationViewController.h"

@interface RBPublicLocationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *locTextField;
@property (weak, nonatomic) IBOutlet UIView *locTextSearchView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * locPagens;
@property (nonatomic,assign)NSInteger locPages;

@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UIView * headerNoShowView;

@end

@implementation RBPublicLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self makeNavi];
    [self setupRefresh];
    [self dataSet];
    [self requestLocationArrDataWithPages:0];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.pagens = @"15";
    self.locPagens = @"15";
}

- (void)makeUI{
    self.locTextSearchView.layer.cornerRadius = 5.f;
    self.locTextSearchView.layer.masksToBounds = YES;
}

- (void)makeNavi{
    self.navigationItem.title = @"添加地点";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"取消" withTittleColor:[UIColor lightGrayColor] withTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside withWidth:40.f];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectLocationWithLocation:(NSString *)location{
    self.locationChooseBlock(location);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self.locTextField.text isEqualToString:@""]?(section == 0?15.f:self.dataArr.count <=0?0.001f:40.f):0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0?42.f:64.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.locTextField.text isEqualToString:@""]&&section == 0) {
        if (!self.headerNoShowView) {
            self.headerNoShowView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 15.f)];
            self.headerNoShowView.backgroundColor = [UIColor colorWithHexString:@"#f5f8fa"];
        }
        return self.headerNoShowView;
    }
    if (![self.locTextField.text isEqualToString:@""]||section == 0||self.dataArr.count <=0)return nil;
    if (!self.headerView) {
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 40.f)];
        self.headerView.backgroundColor = [UIColor colorWithHexString:@"#f5f8fa"];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15.f, 0.f, kScreen_Width - 30.f, 40.f)];
        label.text = @"当前定位地址";
        label.font = [UIFont systemFontOfSize:15.f];
        label.textColor = CsubtitleColor;
        [self.headerView addSubview:label];
    }
    return self.headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        [self selectLocationWithLocation:@""];
        return;
    }
    
    [self selectLocationWithLocation:self.dataArr[indexPath.row]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0)return [self.locTextField.text isEqualToString:@""]?1:0;
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell * locationNoCell = [tableView dequeueReusableCellWithIdentifier:@"locationNoCell"];
        if (!locationNoCell) {
            locationNoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationNoCell"];
        }
        locationNoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        locationNoCell.textLabel.textColor = CtitleColor;
        locationNoCell.detailTextLabel.textColor = CsubtitleColor;
        locationNoCell.textLabel.font = [UIFont systemFontOfSize:15.f];
        locationNoCell.textLabel.text = @"不显示地点";
        return locationNoCell;
    }
    
    UITableViewCell * locationCell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
    if (!locationCell) {
        locationCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"locationCell"];
    }
    locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
    locationCell.tintColor = CtitleColor;
    locationCell.textLabel.textColor = CtitleColor;
    locationCell.detailTextLabel.textColor = CsubtitleColor;
    locationCell.textLabel.font = [UIFont systemFontOfSize:15.f];
    if (![locationCell viewWithTag:10086]) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15.f, 63.f, kScreen_Width - 30.f, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        lineView.tag = 10086;
        [locationCell addSubview:lineView];
    }
    locationCell.textLabel.text = self.dataArr[indexPath.row];
    locationCell.detailTextLabel.text = @"3333333";
    return locationCell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.locPages = 0;
        [self.tableView scrollsToTop];
        [self requestSearchLocationArrDataWithPages:0];
    });
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text isEqualToString:@""])return NO;
    [self selectLocationWithLocation:textField.text];
    return YES;
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}
- (void)footerRereshing{
    if ([self.locTextField.text isEqualToString:@""]) {
        self.pages++;
        [self requestLocationArrDataWithPages:self.pages];
        return;
    }
    self.locPages++;
    [self requestSearchLocationArrDataWithPages:self.locPages];
}

#pragma mark - Http
- (void)requestLocationArrDataWithPages:(NSInteger)page{
    if (page>0){
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.dataArr removeAllObjects];
    }
    
    for (int i = 0; i<15; i++) {
        [self.dataArr addObject:@"上海"];
    }
    
    [self.tableView reloadData];
}

- (void)requestSearchLocationArrDataWithPages:(NSInteger)page{
    if ([self.locTextField.text isEqualToString:@""]){
        [self.tableView reloadData];
        return;
    }
    
    if (page>0){
        [self.tableView.mj_footer endRefreshing];
    }else{
        [self.dataArr removeAllObjects];
    }
    
    for (int i = 0; i<15; i++) {
        [self.dataArr addObject:self.locTextField.text];
    }
    
    [self.tableView reloadData];
}

@end
