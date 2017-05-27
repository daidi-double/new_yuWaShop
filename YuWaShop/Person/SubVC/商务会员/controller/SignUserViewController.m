//
//  SignUserViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 2016/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "SignUserViewController.h"
#import "SignUserTableViewCell.h"
#import "YJSegmentedControl.h"

#import "SignUserModel.h"

#import "JWTools.h"

#define CELL0    @"SignUserTableViewCell"

@interface SignUserViewController ()<UITableViewDelegate,UITableViewDataSource,YJSegmentedControlDelegate>
{
    UIButton * markBtn;
}
@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*maMallDatas;
@property(nonatomic,strong)NSString*type;   //0直接绑定  1间接绑定
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;

@end

@implementation SignUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"锁定会员";
    self.type=self.status;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self makeTopChooseView];
    [self setUpMJRefresh];
    
//    UILabel*label=[[UILabel alloc]init];

    
}

#pragma mark  --UI
-(void)setUpMJRefresh{
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.maMallDatas=[NSMutableArray array];
        [self getDatas];
        
    }];
    
//    //上拉刷新
//    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
//        self.pages++;
//        [self getDatas];
//        
//    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    
    
}



-(void)makeTopChooseView{
    NSArray*arrayTitle=@[@"直接锁定",@"间接锁定"];
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(20,69, kScreen_Width - 40, 30)];
    bgView.backgroundColor = CNaviColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self.view addSubview:bgView];
    for (int i = 0; i<2; i ++ ) {
        
        UIButton * segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        segmentBtn.frame = CGRectMake(2+bgView.width/2*i, 2, bgView.width/2-4, 26);
        segmentBtn.layer.borderColor = CNaviColor.CGColor;
        segmentBtn.layer.borderWidth = 2.f;
        segmentBtn.layer.cornerRadius = 5.f;
        [segmentBtn setTitle:arrayTitle[i] forState:UIControlStateNormal];
        [segmentBtn setTitleColor:CNaviColor forState:UIControlStateNormal];
        [segmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [segmentBtn setBackgroundColor:[UIColor whiteColor]];
        segmentBtn.tag = i +1;
        if ([self.status isEqualToString:@"0"]) {
            if (i == 0) {
                segmentBtn.selected = YES;
                [segmentBtn setBackgroundColor:CNaviColor];
                [markBtn setBackgroundColor:[UIColor whiteColor]];
                markBtn.selected = NO;
                markBtn = segmentBtn;
            }
        }else{
            if (i == 1) {
                segmentBtn.selected = YES;
                [segmentBtn setBackgroundColor:CNaviColor];
                [markBtn setBackgroundColor:[UIColor whiteColor]];
                markBtn.selected = NO;
                markBtn = segmentBtn;
                
            }
        }
        
        
        [segmentBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [segmentBtn addTarget:self action:@selector(segumentSelectionChangeAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:segmentBtn];
    }

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.maMallDatas.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SignUserTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    
    SignUserModel*model=self.maMallDatas[indexPath.row];
    
    UILabel*nameLabel=[cell viewWithTag:1];
    nameLabel.text=model.user_name;
    //判断是否为手机号码，是就隐藏一部分
    if (model.user_name.length >= 11 && [JWTools isNumberWithStr:model.user_name]) {
        nameLabel.text = [NSString stringWithFormat:@"%@****",[model.user_name substringToIndex:model.user_name.length - 4]];
    }
   
    UILabel*moneyLabel=[cell viewWithTag:2];
    moneyLabel.text=[NSString stringWithFormat:@"总分红金额:%@",model.money];
    if (model.money == nil || [model.money isKindOfClass:[NSNull class]]) {
        moneyLabel.text = @"0.00";
    }
    UILabel*timeLabel=[cell viewWithTag:3];
    timeLabel.text=[JWTools getTime:model.ctime];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)segumentSelectionChangeAction:(UIButton*)sender{
    if (sender.tag==1) {
        self.type=@"0";
    }else{
        self.type=@"1";
    }
    if (sender.selected == YES) {
        return;
    }
    [sender setBackgroundColor:CNaviColor];
    [markBtn setBackgroundColor:[UIColor whiteColor]];
    sender.selected = YES;
    markBtn.selected = NO;
    markBtn = sender;
    //    [self.tableView.mj_header beginRefreshing];
    [self setUpMJRefresh];
}

#pragma mark  --getDatas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_BIND_USER];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":self.type};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                SignUserModel*model=[SignUserModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
                
            }
            
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
        
    }];
    
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

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+40, kScreen_Width, kScreen_Height-64-40) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

@end
