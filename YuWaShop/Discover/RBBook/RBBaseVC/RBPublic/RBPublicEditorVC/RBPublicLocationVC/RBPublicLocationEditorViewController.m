//
//  RBPublicLocationEditorViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/11/2.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RBPublicLocationEditorViewController.h"

@interface RBPublicLocationEditorViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)CLGeocoder * geocoder;
@property (nonatomic,copy)NSString * locationStr;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * keyArr;

@property (nonatomic,strong)UIView * headerView;
@property (nonatomic,strong)UIView * headerNoShowView;

@end

@implementation RBPublicLocationEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self dataSet];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.keyArr = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray * placeArray = [NSMutableArray arrayWithArray:@[@"丰泽区",@"丰泽广场/丰泽街",@"大洋百货周边",@"星光不夜城及周边",@"浦西万达广场",@"泉州客运中心周边",@"永辉/现代家居广场",@"后埔浔埔/丰海路",@"美食街",@"侨乡体育馆/东湖",@"中骏世界城",@"润柏香港城",@"东海湾新华都广场",@"东海大街/宝山/宝珊",@"六灌路",@"领SHOW天地",@"华侨大学周边",@"宝洲路",@"灵山墓/郑成功公园",@"清源山180医院",@"津淮街",@"鲤城区",@"泉州酒店周边",@"涂门街",@"T淘园",@"凯德广场",@"浮桥",@"西湖公园周边",@"东街/第一医院",@"西街",@"九一路/文化宫",@"南俊路",@"北门街/中山公园",@"晋江市",@"时代广场",@"池店",@"万达广场",@"SM广场",@"阳光广场",@"泉安中路",@"安海",@"清濛开发区",@"宝龙广场",@"市标",@"东石镇",@"金井镇",@"国际机场",@"晋江市医院",@"五店市",@"英林",@"石狮市",@"德辉广场",@"泰禾广场",@"灵狮中路",@"步行街",@"龟湖公园",@"星期Yi",@"闽南理工学院",@"金汇花园",@"石城广场",@"世茂摩天城",@"南安市",@"市区",@"南安水头镇",@"官桥镇",@"梅山镇",@"洪濑镇",@"石井镇",@"霞美镇",@"康美镇",@"惠安县",@"中新花园",@"大红铺",@"东南大街",@"天山广场",@"大润发",@"东园镇",@"崇武镇",@"惠兴街",@"洛阳镇",@"洛江区",@"洛江",@"双阳",@"安溪县",@"宝龙城市广场",@"县政府",@"海峡茗城",@"龙湖",@"北石光德",@"泉港区",@"新民街",@"山腰",@"植物园",@"生活区",@"金山街",@"万星城市广场",@"中心工业区",@"永春县",@"万星文化广场",@"环城路",@"德化县",@"德化中医院",@"德化县医院",@"金门县"]];
    [self sortedArry:placeArray];
    [self getLocalSubName];
}
- (void)sortedArry:(NSMutableArray *)arr{//排序好的数组、按照首字母排
    __block NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull str, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray * arrTemp = dic[[JWTools stringWithFirstCharactor:[str substringToIndex:1]]];
        if (!arrTemp)arrTemp = [NSMutableArray arrayWithCapacity:0];
        [arrTemp addObject:str];
        [dic setObject:arrTemp forKey:[JWTools stringWithFirstCharactor:[str substringToIndex:1]]];
        
    }];//数组内模型的地点进行排序
    
    self.keyArr = [NSMutableArray arrayWithArray:[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    [self.keyArr enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArr addObject:dic[key]];
    }];
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

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (void)getLocalSubName{
    self.locationStr = @"泉州";
    [self.tableView reloadData];
    WEAKSELF;
    CLLocation * location = [[CLLocation alloc]initWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * placemark = placemarks[0];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||[CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            weakSelf.locationStr = placemark.subLocality;
            [self.tableView reloadData];
        }else{
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?15.f:24.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (!self.headerNoShowView) {
            self.headerNoShowView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 15.f)];
            self.headerNoShowView.backgroundColor = [UIColor colorWithHexString:@"#f5f8fa"];
        }
        return self.headerNoShowView;
    }
    if (section == 1){
        if (!self.headerView) {
            self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 24.f)];
            self.headerView.backgroundColor = [UIColor colorWithHexString:@"#f5f8fa"];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15.f, 0.f, kScreen_Width - 30.f, 24.f)];
            label.text = @"当前定位地址";
            label.font = [UIFont systemFontOfSize:15.f];
            label.textColor = CsubtitleColor;
            [self.headerView addSubview:label];
        }
        return self.headerView;
    }
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 24.f)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f5f8fa"];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15.f, 0.f, kScreen_Width - 30.f, 24.f)];
    label.text = self.keyArr[section - 2];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = CsubtitleColor;
    [headerView addSubview:label];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectLocationWithLocation:indexPath.section==0?@"":(indexPath.section == 1?self.locationStr:self.dataArr[indexPath.section - 2][indexPath.row])];
}

#pragma mark - UITableViewDataSource
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.keyArr;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSString *key = self.keyArr[index];
    if (key == title) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(index + 2)] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        return NSNotFound;
    }
    return index;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count + 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section <=1?1:[self.dataArr[section - 2] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * locationNoCell = [tableView dequeueReusableCellWithIdentifier:@"locationNoCell"];
    if (!locationNoCell) {
        locationNoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationNoCell"];
    }
    locationNoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    locationNoCell.textLabel.textColor = CtitleColor;
    locationNoCell.detailTextLabel.textColor = CsubtitleColor;
    locationNoCell.textLabel.font = [UIFont systemFontOfSize:15.f];
    locationNoCell.textLabel.text = indexPath.section == 0?@"不显示地点":(indexPath.section == 1?self.locationStr:self.dataArr[indexPath.section - 2][indexPath.row]);
    if (![locationNoCell viewWithTag:10086]&&indexPath.section>1) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15.f, 41.f, kScreen_Width - 30.f, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#d6d6d6"];
        lineView.tag = 10086;
        [locationNoCell addSubview:lineView];
    }
    return locationNoCell;
}

@end
