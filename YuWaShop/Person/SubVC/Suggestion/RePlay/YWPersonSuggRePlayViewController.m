//
//  YWPersonSuggRePlayViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonSuggRePlayViewController.h"
#import "JWChatTableViewCell.h"

@interface YWPersonSuggRePlayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;

@end

@implementation YWPersonSuggRePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见回复";
    [self dataSet];
    [self setupRefresh];
    [self requestDataWithPages:0];
}
- (void)dataSet{
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:@"JWChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"JWChatTableViewCell"];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView fd_heightForCellWithIdentifier:@"JWChatTableViewCell" configuration:^(JWChatTableViewCell * cell) {
        cell.model = self.dataArr[indexPath.row];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JWChatTableViewCell * replayCell = [tableView dequeueReusableCellWithIdentifier:@"JWChatTableViewCell"];
    replayCell.model = self.dataArr[indexPath.row];
    return replayCell;
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
}
- (void)headerRereshing{
    self.pages++;
    if (self.dataArr.count <= 0)self.pages = 0;
    [self requestDataWithPages:self.pages];
}

#pragma mark - Http
- (void)requestDataWithPages:(NSInteger)page{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":@(1),@"pagen":@([self.pagens integerValue]),@"pages":@(page)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_SuggestLists withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSArray * dataArr = responsObj[@"data"];
        if (page == 0)[self.dataArr removeAllObjects];
        for (int i = 0; i<dataArr.count; i++) {
            YWPSSellerRePlayModel * sellerModel = [YWPSSellerRePlayModel yy_modelWithDictionary:dataArr[i]];
            sellerModel.status = 0;
            YWPSRePlayModel * model = [YWPSRePlayModel yy_modelWithDictionary:dataArr[i]];
            model.status = 1;
            if (self.dataArr.count<=0) {
                if (![sellerModel.ctime isEqualToString:@"0"]&&![sellerModel.customer_content isEqualToString:@""]) {
                    [self.dataArr addObject:sellerModel];
                    [self.dataArr insertObject:model atIndex:0];
                }else{
                    [self.dataArr addObject:model];
                }
            }else{
                if (![sellerModel.ctime isEqualToString:@"0"]&&![sellerModel.customer_content isEqualToString:@""]) {
                    [self.dataArr insertObject:sellerModel atIndex:0];
                }
                
                [self.dataArr insertObject:model atIndex:0];
            }
        }
        
        [self.tableView reloadData];
        if (page == 0&&self.dataArr.count>0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.dataArr.count-1) inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }]; 
}

@end
