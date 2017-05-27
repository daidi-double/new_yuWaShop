//
//  ShowMoreCommitViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ShowMoreCommitViewController.h"
#import "CommentTableViewCell.h"

#import "CommentModel.h"       //就3个label的数据
#import "ShopdetailModel.h"    //每一条的评论的数据

#import "JWTools.h"
#import "UIScrollView+JWGifRefresh.h"




#define CELL0  @"CommentTableViewCell"


@interface ShowMoreCommitViewController ()<UITableViewDataSource,UITableViewDelegate,CommentTableViewCellDelegate>

@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UIView*headerView;
@property(nonatomic,strong)UISegmentedControl*typeSegmentView;
@property(nonatomic,strong)UILabel*label1;
@property(nonatomic,strong)UILabel*label2;
@property(nonatomic,strong)UILabel*label3;

@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,assign)NSInteger status;  // 1全部 2好评 3中差评
@property(nonatomic,strong)CommentModel*mainModel;
@property(nonatomic,strong)NSMutableArray*maMallDatas;

@end

@implementation ShowMoreCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"口碑管理";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self setUpMJRefresh];
    [self makeUI];
    [self makeTopHeader];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden= NO;
}
-(void)setUpMJRefresh{
    self.status=1;
    self.pagen=10;
    self.pages=0;
    self.maMallDatas=[NSMutableArray array];
    
    self.tableView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.maMallDatas=[NSMutableArray array];
        [self getDatas];

    }];
    
    //上拉刷新
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
    }];
    
    //立即刷新
    [self.tableView.mj_header beginRefreshing];
    
    
    
}

#pragma mark  -- UI

-(void)makeTopHeader{
    UIView*backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 80+50)];
    
    
    UIView*topView=[[NSBundle mainBundle]loadNibNamed:@"CommentHeadView" owner:nil options:nil].firstObject;
    topView.frame=CGRectMake(0, 0, kScreen_Width, 80);
    [backgroundView addSubview:topView];
    
    self.label1=[topView viewWithTag:1];
    self.label2=[topView viewWithTag:2];
    self.label3=[topView viewWithTag:3];
    
    [self giveValueForThreeLabel];
    
    self.headerView.frame=CGRectMake(0, 80, kScreen_Width, 50);
    [backgroundView addSubview:self.headerView];
    
    self.tableView.tableHeaderView=backgroundView;
    
}

- (void)makeUI{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 50.f)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.typeSegmentView = [[UISegmentedControl alloc]initWithItems:@[@"全部评论",@"好评",@"中差评"]];
    self.typeSegmentView.frame = CGRectMake(20.f, 10.f, kScreen_Width - 40.f, 30.f);
    self.typeSegmentView.selectedSegmentIndex = 0;
    [self.typeSegmentView setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:CNaviColor} forState:UIControlStateNormal];
    [self.typeSegmentView setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    self.typeSegmentView.tintColor = CNaviColor;
    self.typeSegmentView.layer.borderColor = CNaviColor.CGColor;
    [self.typeSegmentView setDividerImage:[UIImage imageNamed:@"segmentLine"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.typeSegmentView.layer.borderWidth = 2.f;
    self.typeSegmentView.layer.cornerRadius = 5.f;
    self.typeSegmentView.layer.masksToBounds = YES;
    [self.typeSegmentView addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.headerView addSubview:self.typeSegmentView];
    
//    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
//    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:self.tap];
}


#pragma mark  --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.maMallDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    cell.selectionStyle=NO;
    
     ShopdetailModel*model=self.maMallDatas[indexPath.section];
    cell.cellDelegate = self;
     [cell giveValueWithModel:model];

      return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点了 哪一个 跳警告框来提示
    NSInteger number=indexPath.section;
    [self makeAlertVCwithNumber:number];
    
}
//- (void)changCellHeight:(NSInteger)staus{
//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:3];
//    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
//}
-(void)makeAlertVCwithNumber:(NSInteger)number{
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"回复留言" message:@"请输入对本条留言的评价" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"请输入内容,不能少于6个字";
        textField.secureTextEntry=NO;
    }];
    UIAlertAction*OKAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField*replayTextField=alertVC.textFields.firstObject;
        if (replayTextField.text.length<6) {
            [JRToast showWithText:@"回复不能少于6个字"];
            return;
        }
        
        [self getJiekouWithNumber:number andText:replayTextField.text];
        
    }];
    
    UIAlertAction*cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:OKAction];
    [alertVC addAction:cancelAction];
    
    
    [self presentViewController:alertVC animated:YES completion:nil];
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//         return self.headerView;
//    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    ShopdetailModel*model=self.maMallDatas[indexPath.section];

    return [CommentTableViewCell getCellHeight:model];


}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return 50;
//    }
//    return 10;
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark  --touch
- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.status = sender.selectedSegmentIndex+1;
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark  --getDatas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_COMMENTLIST];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*type=[NSString stringWithFormat:@"%zi",self.status];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":type,@"pagen":pagen,@"pages":pages};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            self.mainModel=[[CommentModel alloc]init];
            self.mainModel.total_comment=data[@"data"][@"total_comment"];
            self.mainModel.totay_comment=data[@"data"][@"totay_comment"];
            self.mainModel.totay_bad_comment=data[@"data"][@"totay_bad_comment"];

            for (NSDictionary*dict in data[@"data"][@"lists"]) {
                ShopdetailModel*model=[ShopdetailModel yy_modelWithDictionary:dict];
                [self.maMallDatas addObject:model];
            }
            
            [self giveValueForThreeLabel];
            [self.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        
    }];
    
    
}


-(void)giveValueForThreeLabel{
    self.label1.text=self.mainModel.total_comment;
    self.label2.text=self.mainModel.totay_comment;
    self.label3.text=self.mainModel.totay_bad_comment;
    
}


//回复的内容
-(void)getJiekouWithNumber:(NSInteger)number andText:(NSString*)text{
    MyLog(@"111");
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_COMMENTREPLY];
    ShopdetailModel*model=self.maMallDatas[number];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":model.id,@"seller_content":text};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [JRToast showWithText:data[@"data"]];
            [self.tableView.mj_header beginRefreshing];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
              [self.tableView.mj_header beginRefreshing];
        }
        
        
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}



@end
