//
//  YWPayNotificationTableView.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPayNotificationTableView.h"
#import "UIScrollView+JWGifRefresh.h"
#import "HttpObject.h"
#import "JWTools.h"

#import "YWMessageNotificationCell.h"

#define MESSAGENOTICELL @"YWMessageNotificationCell"
@implementation YWPayNotificationTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.hidden = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self registerNib:[UINib nibWithNibName:MESSAGENOTICELL bundle:nil] forCellReuseIdentifier:MESSAGENOTICELL];
    self.dataSource = self;
    self.delegate = self;
    [self setupRefresh];
    [self headerRereshing];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMessageNotificationCell * messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGENOTICELL];
    messageCell.model = self.dataArr[indexPath.row];
    return messageCell;
}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    self.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}
- (void)footerRereshing{
    self.pages++;
    [self requestShopArrDataWithPages:self.pages];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestShopArrDataWithPages:0];
}
- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.mj_header endRefreshing];
    }else{
        [self.mj_footer endRefreshing];
    }
}
#pragma mark - Http
- (void)requestShopArrDataWithPages:(NSInteger)page{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"pagen":self.pagens,@"pages":[NSString stringWithFormat:@"%zi",page]};
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    
    [[HttpObject manager]postNoHudWithType:YuWaType_NOTCCAFICATIONJ_PAY withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page==0){
            [self.dataArr removeAllObjects];
        }
        NSArray * dataArr = responsObj[@"data"];
        if (dataArr.count>0) {
            for (int i = 0; i<dataArr.count; i++) {
                YWMessageNotificationModel * model = [YWMessageNotificationModel yy_modelWithDictionary:dataArr[i]];
                model.status = @"1";
                [self.dataArr addObject:model];
            }
            [self reloadData];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}


@end
