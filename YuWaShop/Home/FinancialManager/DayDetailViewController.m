//
//  DayDetailViewController.m
//  YuWaShop
//
//  Created by 黄佳峰 on 2016/12/7.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "DayDetailViewController.h"
#import "YWHomeQuickPayListTableViewCell.h"

#import "YWHomeQuickPayListModel.h"
#import "ForMoneyModel.h"

#define CELL0   @"YWHomeQuickPayListTableViewCell"

@interface DayDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign)NSInteger pagen;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,strong)NSMutableArray * allDatasList;
@property(nonatomic,strong)NSMutableArray*allDatasMoney;

@end

@implementation DayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"收入详情";
     [self dataSet];
     [self setupRefresh];
    
}

- (void)dataSet{
    self.pagen = 10;
    self.pages=0;
    self.allDatasList = [NSMutableArray arrayWithCapacity:0];
    self.allDatasMoney=[NSMutableArray arrayWithCapacity:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
         self.pages=0;
        self.allDatasList = [NSMutableArray arrayWithCapacity:0];
        self.allDatasMoney=[NSMutableArray arrayWithCapacity:0];
        [self getDatas];

        
    }];
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        self.allDatasMoney=[NSMutableArray arrayWithCapacity:0];
        [self getDatas];
        
    }];
    
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark  -- setDatas
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.allDatasMoney.count<1) {
        return 1;
    }else{
        return 2;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.allDatasMoney.count<1) {
        return self.allDatasList.count;
        
    }else{
        if (section==0) {
            return self.allDatasMoney.count;
        }else{
            return self.allDatasList.count;
        }
        
    }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWHomeQuickPayListTableViewCell * listCell = [tableView dequeueReusableCellWithIdentifier:CELL0];

    
    if (self.allDatasMoney.count<1) {
       
       listCell.model = self.allDatasList[indexPath.row];
        return listCell;

    }else{
        if (indexPath.section==0) {
            ForMoneyModel*model=self.allDatasMoney[indexPath.row];
            listCell.nameLabel.text=model.name;
            listCell.timerLabel.text=model.time;
            listCell.GetMoneyLabel.text=[NSString stringWithFormat:@"+%@",model.money];
            listCell.showLabel.text=@"";
            
            return listCell;
            
            
        }else{
            
            listCell.model = self.allDatasList[indexPath.row];
            return listCell;
            
            
        }
        
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}


#pragma mark  --setDatas
-(void)getDatas{

    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_EVERY_RECORD];
    NSString*pagen=[NSString stringWithFormat:@"%ld",(long)self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%zi",self.pages];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"ctime":self.ctime,@"pagen":pagen,@"pages":pages};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            NSArray*MoneyArray=data[@"data"][@"money"];
            NSArray*listsArray=data[@"data"][@"lists"];
            
            for (NSDictionary*dict in MoneyArray) {
                ForMoneyModel*model=[ForMoneyModel yy_modelWithDictionary:dict];
                [self.allDatasMoney addObject:model];
            }
            
            for (NSDictionary*dict in listsArray) {
                YWHomeQuickPayListModel*model=[YWHomeQuickPayListModel yy_modelWithDictionary:dict];
                [self.allDatasList addObject:model];
            }
            
            
            [self.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        
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

@end
