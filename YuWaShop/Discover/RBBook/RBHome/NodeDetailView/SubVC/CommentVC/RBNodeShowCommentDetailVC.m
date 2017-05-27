//
//  RBNodeShowCommentDetailVC.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/13.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeShowCommentDetailVC.h"
#import "RBNodeDCommentTableViewCell.h"

#define COMMENTCELL @"RBNodeDCommentTableViewCell"
@interface RBNodeShowCommentDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSMutableArray * dataArr;

@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;

@end

@implementation RBNodeShowCommentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论详情";
    self.commentToolsView.hidden = NO;
    [self dataSet];
    [self setupRefresh];
    [self requestDataWithPages:0];
}

- (void)dataSet{
    self.pagens = @"15";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.tableView registerNib:[UINib nibWithNibName:COMMENTCELL bundle:nil] forCellReuseIdentifier:COMMENTCELL];
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self cancelComment];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:COMMENTCELL configuration:^(RBNodeDCommentTableViewCell * cell) {
        cell.model = self.dataArr[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RBNodeShowCommentModel * model = self.dataArr[indexPath.row];
    [self commentActionWithUserDic:@{@"nodeID":self.idd,@"userID":model.user.userid,@"userName":model.user.nickname}];
    return;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RBNodeDCommentTableViewCell * commentCell = [tableView dequeueReusableCellWithIdentifier:COMMENTCELL];
    commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    commentCell.model = self.dataArr[indexPath.row];
    return commentCell;
}

#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.tableView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestDataWithPages:0];
}
- (void)footerRereshing{
    self.pages++;
    [self requestDataWithPages:self.pages];
}
- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - Http
- (void)requestDataWithPages:(NSInteger)page{
    NSDictionary * pragram = @{@"note_id":self.idd,@"pagen":self.pagens,@"pages":[NSString stringWithFormat:@"%zi",page],@"user_type":@([UserSession instance].isVIP==3?2:1)};
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_COMMENT_LIST withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page == 0) {
            [self.dataArr removeAllObjects];
        }
        NSArray * dataArr = responsObj[@"data"];
        if (dataArr.count>0) {
            for (int i = 0; i<dataArr.count; i++) {
                [self.dataArr addObject:[RBNodeShowCommentModel yy_modelWithDictionary:[RBNodeShowCommentModel dataDicSetWithDic:dataArr[i]]]];
            }
            [self.tableView reloadData];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

- (void)requestSendComment{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"note_id":@([self.commentSendDic[@"nodeID"] integerValue]),@"customer_content":[JWTools UTF8WithStringJW:self.commentToolsView.sendTextField.text],@"user_type":@([UserSession instance].isVIP==3?2:1)};
    
    [[HttpObject manager]postDataWithType:YuWaType_RB_COMMENT withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.tableView.mj_header beginRefreshing];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
