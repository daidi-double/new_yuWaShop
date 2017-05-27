//
//  RBHomeSearchViewController.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/14.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBHomeSearchViewController.h"
#import "RBHomeSearchToolsView.h"
#import "RBHomeSearchDetailViewController.h"

#define Search_Node_History @"SearchNodeHistory"
@interface RBHomeSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)RBHomeSearchToolsView * searchView;
@property (nonatomic,strong)NSMutableArray * searchArr;//历史记录
@property (nonatomic,strong)NSMutableArray * tagArr;
@property (nonatomic,strong)NSMutableArray * searchResaultArr;//搜索
@property (nonatomic,assign)NSInteger type;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RBHomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self dataSet];
    [self requestdata];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![self.searchView.textField.text isEqualToString:@""]){
        [self.searchView.textField becomeFirstResponder];
    }
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.searchView.height = 30.f;
}

- (void)makeNavi{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"取消" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside withWidth:40.f];
    
    self.searchView = [[[NSBundle mainBundle]loadNibNamed:@"RBHomeSearchToolsView" owner:nil options:nil]firstObject];
    self.searchView.textField.delegate = self;
    WEAKSELF;
    self.searchView.typeChooseBlock = ^(NSInteger type){
        weakSelf.type = type;
    };
    self.navigationItem.titleView = self.searchView;
}

- (void)dataSet{
    self.searchArr = [[NSMutableArray alloc]initWithArray:[KUSERDEFAULT valueForKey:Search_Node_History]];
    if (!self.searchArr){
        self.searchArr = [NSMutableArray arrayWithCapacity:0];
        [KUSERDEFAULT setValue:self.searchArr forKey:Search_Node_History];
    }
    self.tagArr = [NSMutableArray arrayWithCapacity:0];
    self.searchResaultArr = [NSMutableArray arrayWithCapacity:0];
    
}

- (void)removeHistoryBtnAction{
    self.searchArr = [NSMutableArray arrayWithCapacity:0];
    [KUSERDEFAULT setValue:self.searchArr forKey:Search_Node_History];
    [self.tableView reloadData];
}

- (void)backAction{
    [self.searchView.textField resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rememberSearchDataWithKey:(NSString *)key withType:(NSString *)type{
    NSDictionary * dataDic = @{@"key":key,@"type":type};
    for (int i = 0; i < self.searchArr.count; i++) {//删除相同历史记录
        NSDictionary * dataDic = self.searchArr[i];
        if ([dataDic[@"key"] isEqualToString:key] && [dataDic[@"type"] isEqualToString:type]) {
            [self.searchArr removeObjectAtIndex:i];
            break;
        }
    }
    if (self.searchArr.count <= 2) {
        [self.searchArr insertObject:dataDic atIndex:0];
    }else{
        //记录数据上限为3个
        [self.searchArr removeLastObject];
        [self.searchArr insertObject:dataDic atIndex:0];
    }
    [self.searchView.textField resignFirstResponder];
    [KUSERDEFAULT setValue:self.searchArr forKey:Search_Node_History];
    [self pushToDetailVCWithKey:key withType:[type integerValue]];
}
- (void)pushToDetailVCWithKey:(NSString *)key withType:(NSInteger)type{
    RBHomeSearchDetailViewController * vc = [[RBHomeSearchDetailViewController alloc]init];
    vc.searchKey = key;
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.searchView.textField.text = key;
    });
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]) {
        [self rememberSearchDataWithKey:textField.text withType:[NSString stringWithFormat:@"%zi",self.type]];
        [textField resignFirstResponder];
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestSearchResaultData];
    });
    return YES;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((self.searchArr.count == 0 && indexPath.section == 0) || (self.searchArr.count > 0 && indexPath.section == 1)) {
        return 40.f;
    }
    if (indexPath.section == 0) {
        if (![self.searchView.textField.text isEqualToString:@""] || self.searchArr.count > 0) {
            return 40.f;
        }
    }
    return 55.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * key = @"";
    NSInteger type = self.type;
    if (![self.searchView.textField.text isEqualToString:@""] && indexPath.section == 0) {//有输入文字
        if (self.searchResaultArr.count > 0) {
            if (indexPath.row == 0)return;
            key = (indexPath.row >= self.searchResaultArr.count + 1)?self.searchView.textField.text:self.searchResaultArr[indexPath.row - 1][@"key"];
        }else{
            key = self.searchView.textField.text;
        }
    }else if (self.searchArr.count > 0 && indexPath.section == 0) {//有历史记录
        if (indexPath.row == 0)return;
        NSDictionary * searchHistoryDic = self.searchArr[indexPath.row - 1];
        key = searchHistoryDic[@"key"];
        type = [searchHistoryDic[@"type"] integerValue];
    }else{//无历史记录
        key = self.tagArr[indexPath.row];
        type = 0;
    }
    [self rememberSearchDataWithKey:key withType:[NSString stringWithFormat:@"%zi",type]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![self.searchView.textField.text isEqualToString:@""])return 3;
    return self.searchArr.count == 0?2:3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![self.searchView.textField.text isEqualToString:@""]&&section == 0)return self.searchResaultArr.count + (self.searchResaultArr.count == 0?1:2);
    
    if (self.searchArr.count == 0)return section == 0?1:self.tagArr.count;//无历史记录
    //有历史记录
    return section == 0?(self.searchArr.count + 1):section == 1?1:self.tagArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.searchView.textField.text isEqualToString:@""]&&indexPath.section == 0){//搜索
        UITableViewCell * searchResultCell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
        if (!searchResultCell) {
            searchResultCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchResultCell"];
        }
        if (![searchResultCell viewWithTag:1001]) {
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(13.f, 39.f, kScreen_Width - 26.f, 1.f)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#F3F6F8"];
            lineView.tag = 1001;
            [searchResultCell addSubview:lineView];
        }
        searchResultCell.selectionStyle = UITableViewCellSelectionStyleNone;
        searchResultCell.textLabel.textColor = [UIColor colorWithHexString:indexPath.row == 0?@"#cccccc":@"#7e7e7e"];
        searchResultCell.textLabel.font = [UIFont systemFontOfSize:14.f];
        if ((self.searchResaultArr.count == 0)||(indexPath.row == self.searchResaultArr.count + 1)) {
            searchResultCell.textLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
            searchResultCell.textLabel.text = [NSString stringWithFormat:@"查看所有叫“%@”的笔记",self.searchView.textField.text];
            searchResultCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            searchResultCell.textLabel.text = indexPath.row == 0?@"你是否想搜":self.searchResaultArr[indexPath.row - 1][@"key"];
        }
        
        return searchResultCell;
    }
    
    if (self.searchArr.count > 0 && indexPath.section == 0) {//历史记录
        UITableViewCell * searchListCell = [tableView dequeueReusableCellWithIdentifier:@"searchListCell"];
        if (!searchListCell) {
            searchListCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchListCell"];
        }
        if (![searchListCell viewWithTag:1001]) {
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(13.f, 39.f, kScreen_Width - 26.f, 1.f)];
            lineView.backgroundColor = [UIColor colorWithHexString:@"#F3F6F8"];
            lineView.tag = 1001;
            [searchListCell addSubview:lineView];
        }
        searchListCell.selectionStyle = UITableViewCellSelectionStyleNone;
        searchListCell.textLabel.textColor = [UIColor colorWithHexString:indexPath.row == 0?@"#cccccc":@"#7e7e7e"];
        searchListCell.textLabel.font = [UIFont systemFontOfSize:14.f];
        searchListCell.textLabel.text = indexPath.row == 0?@"历史记录":self.searchArr[indexPath.row - 1][@"key"];
        if (![searchListCell viewWithTag:1000] && indexPath.row == 0) {
            UIButton * deletebtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_Width -  32.f, 12.5f, 17.f, 17.f)];
            [deletebtn setBackgroundImage:[UIImage imageNamed:@"remove_history"] forState:UIControlStateNormal];
            deletebtn.tag = 1000;
            [deletebtn addTarget:self action:@selector(removeHistoryBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [searchListCell addSubview:deletebtn];
        }
        return searchListCell;
    }
    
    if ((self.searchArr.count == 0 && indexPath.section == 0) || (self.searchArr.count > 0 && indexPath.section == 1)) {//热门标签
        UITableViewCell * searchHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"searchHeaderCell"];
        if (!searchHeaderCell) {
            searchHeaderCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchHeaderCell"];
        }
        [searchHeaderCell setUserInteractionEnabled:NO];
        searchHeaderCell.backgroundColor = [UIColor colorWithHexString:@"#F3F6F8"];
        searchHeaderCell.textLabel.font = [UIFont systemFontOfSize:13.f];
        searchHeaderCell.textLabel.textColor = [UIColor colorWithHexString:@"#535353"];
        searchHeaderCell.textLabel.text = @"热门搜索";
        searchHeaderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return searchHeaderCell;
    }
    //标签
    UITableViewCell * searchTagCell = [tableView dequeueReusableCellWithIdentifier:@"searchTagCell"];
    if (!searchTagCell) {
        searchTagCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchTagCell"];
    }
    if (![searchTagCell viewWithTag:1001]) {
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(13.f, 54.f, kScreen_Width - 26.f, 1.f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#F3F6F8"];
        lineView.tag = 1001;
        [searchTagCell addSubview:lineView];
    }
    searchTagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    searchTagCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    searchTagCell.textLabel.textColor = [UIColor colorWithHexString:@"#7e7e7e"];
    searchTagCell.textLabel.font = [UIFont systemFontOfSize:14.f];
//    [searchTagCell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"quick"] completed:nil];
    searchTagCell.imageView.image = [UIImage imageNamed:@"quick"];
    searchTagCell.textLabel.text = self.tagArr[indexPath.row];
    return searchTagCell;
}

#pragma mark - Http
- (void)requestdata{
    NSDictionary * pragram = @{};
    
    [[HttpObject manager]getNoHudWithType:YuWaType_RB_SEARCH_QUICK withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSArray * dataArr = responsObj[@"data"];
        if (dataArr.count>0) {
            NSInteger count = dataArr.count>=5?5:dataArr.count;
            for (int i = 0; i<count; i++) {
                NSDictionary * dataDic = dataArr[i];
                [self.tagArr addObject:dataDic[@"title"]];//最多三个,type以后可能换（如笔记0用户1）
            }
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

- (void)requestSearchResaultData{
    NSDictionary * pragram = @{@"keyword":self.searchView.textField.text};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_SEARCH_KEY withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSArray * dataArr = responsObj[@"data"];
        [self.searchResaultArr removeAllObjects];
        if (dataArr.count>0) {
            NSInteger count = dataArr.count>=3?3:dataArr.count;
            for (int i = 0; i<count; i++) {
                [self.searchResaultArr addObject:@{@"key":dataArr[i][@"title"],@"type":@"0"}];//最多三个,type以后可能换（如笔记0用户1）
            }
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}


@end
