//
//  RBNodeShowViewController.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeShowViewController.h"
//#import "YWOtherSeePersonCenterViewController.h"
#import "YWNodeAddAldumViewController.h"
#import "YWLoginViewController.h"
#import "RBNodeCollectionToAldumView.h"
#import "RBNodeShowModel.h"
#import "RBNodeAddToAldumModel.h"

#import "RBNodeShowCommentDetailVC.h"
#import "RBNodeDetailBottomView.h"
#import "RBNodeDetailHeader.h"
#import "RBNodeDetailImageHeader.h"
#import "RBNodeDetailCommentHeader.h"
#import "RBNodeDetailRecommendHeader.h"
#import "RBNodeDetailCommendFooter.h"

#import "RBNodeDetailTableViewCell.h"
#import "RBNodeDCommentTableViewCell.h"
#import "RBNodeDRecommendTableViewCell.h"

#define DETAILCELL @"RBNodeDetailTableViewCell"
#define COMMENTCELL @"RBNodeDCommentTableViewCell"
#define RECOMMENDCELL @"RBNodeDRecommendTableViewCell"
@interface RBNodeShowViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataArr;//collectionView数据
@property (nonatomic,strong)RBNodeShowModel * dataModel;
@property (nonatomic,strong)RBNodeDetailBottomView * toolsBottomView;
@property (nonatomic,strong)RBNodeDetailHeader * authorHeader;
@property (nonatomic,strong)RBNodeDetailImageHeader * imageHeader;
@property (nonatomic,strong)RBNodeDetailCommentHeader * commentHeader;
@property (nonatomic,strong)RBNodeDetailRecommendHeader * recommendHeader;
@property (nonatomic,strong)RBNodeDetailCommendFooter * commentFooter;

@property (nonatomic,strong)RBNodeCollectionToAldumView * addToAldumView;

@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger failedCount;

@property (nonatomic,strong)RBNodeDRecommendTableViewCell * recommendCell;
@property (nonatomic,assign)CGFloat scrollImageHeight;
@property (nonatomic,assign)CGFloat scrollToolsHeight;
@property (nonatomic,assign)CGFloat bottomToolsHeight;

@end

@implementation RBNodeShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记详情";
    [self setupRefresh];
    [self makeNavi];
    [self dataSet];
    [self makeUI];
    [self requestData];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:@"123" object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
    if (self.addToAldumView && [[UserSession instance].aldumCount integerValue]!=self.addToAldumView.dataArr.count) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [self.addToAldumView aldumReload];
        });
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.addToAldumView){
        [self.addToAldumView removeFromSuperview];
        self.addToAldumView = nil;
    }
    if ([[[UIApplication sharedApplication].delegate.window.subviews lastObject] isKindOfClass:[MBProgressHUD class]])[[[UIApplication sharedApplication].delegate.window.subviews lastObject] removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"123" object:nil];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.toolsBottomView.frame = CGRectMake(0.f, kScreen_Height - 44.f, kScreen_Width, 44.f);
}
- (void)makeNavi{
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:@"activity-content-btn-share" withSelectImage:@"activity-content-btn-share" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTarget:self action:@selector(sharedAction) forControlEvents:UIControlEventTouchUpInside withWidth:32.f];
}

- (void)sharedAction{
    [self.commentToolsView.sendTextField resignFirstResponder];
    if (![UserSession instance].isLogin) {
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
//    [self makeShareView];
}

- (void)dataSet{
    self.pagens = @"10";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.scrollToolsHeight = kScreen_Height;
    
    [self.tableView registerNib:[UINib nibWithNibName:DETAILCELL bundle:nil] forCellReuseIdentifier:DETAILCELL];
    [self.tableView registerNib:[UINib nibWithNibName:COMMENTCELL bundle:nil] forCellReuseIdentifier:COMMENTCELL];
    [self.tableView registerNib:[UINib nibWithNibName:RECOMMENDCELL bundle:nil] forCellReuseIdentifier:RECOMMENDCELL];

    self.recommendCell = [self.tableView dequeueReusableCellWithIdentifier:RECOMMENDCELL];
    self.recommendCell.selectionStyle = UITableViewCellSelectionStyleNone;
    WEAKSELF;
    self.recommendCell.selectNodeBlock = ^(NSInteger nodeIndex){
        RBNodeShowViewController * vc = [[RBNodeShowViewController alloc]init];
        vc.model = weakSelf.dataArr[nodeIndex];
        [weakSelf.navigationController pushViewController:vc animated:NO];
    };
}

#pragma mark - UI Make
- (void)makeUI{
    self.toolsBottomView = [[[NSBundle mainBundle]loadNibNamed:@"RBNodeDetailBottomView" owner:nil options:nil] firstObject];
    WEAKSELF;
    self.toolsBottomView.nodeID = self.model.homeID;
    self.toolsBottomView.auser_type = self.model.user.user_type;
    self.toolsBottomView.likeBlock = ^(BOOL isLike){
        if ([weakSelf isLogin]) {
            weakSelf.dataModel.inlikes = [NSString stringWithFormat:@"%zi",isLike];
            weakSelf.dataModel.likes = [NSString stringWithFormat:@"%zi",isLike == YES?([weakSelf.dataModel.likes integerValue] + 1):([weakSelf.dataModel.likes integerValue] -1)];
            [weakSelf reSetBottomToolsView];
        }
    };

    self.toolsBottomView.commentBlock = ^(){
        [weakSelf commentActionWithNodeDic:@{@"nodeID":weakSelf.model.homeID}];
    };
    self.toolsBottomView.collectionBlock = ^(BOOL isCollection){
        if ([weakSelf isLogin]){
            if (isCollection) {
                [weakSelf requestCancelToAldum];
            }else{
                [weakSelf addToAldumViewmake];
            }
        }
    };
    [self addToAldumViewmake];
    [self.view addSubview:self.toolsBottomView];
}
- (void)reSetBottomToolsView{
    RBNodeDetailTableViewCell * detailCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    detailCell.likeLabel.text = [NSString stringWithFormat:@"%@次赞",self.dataModel.likes];
    detailCell.collectionLabel.text = [NSString stringWithFormat:@"%@次收藏",self.dataModel.fav_count];
    
    self.toolsBottomView.isCollection = [self.dataModel.infavs isEqualToString:@"0"]?NO:YES;
    self.toolsBottomView.isLike = [self.dataModel.inlikes isEqualToString:@"0"]?NO:YES;
    [self.toolsBottomView.likeBtn setTitle:self.dataModel.likes forState:UIControlStateNormal];
    [self.toolsBottomView.commentBtn setTitle:self.dataModel.comments forState:UIControlStateNormal];
}

- (void)addToAldumViewmake{
    if (![UserSession instance].aldumCount||[[UserSession instance].aldumCount integerValue]<=0) {
        if (self.addToAldumView){
            [self.addToAldumView setUserInteractionEnabled:NO];
            [self requestAddToAldumWithIdx:@"0"];
        }
    }
    WEAKSELF;
    if (!self.addToAldumView) {
        self.addToAldumView = [[[NSBundle mainBundle]loadNibNamed:@"RBNodeCollectionToAldumView" owner:nil options:nil]firstObject];
        self.addToAldumView.auser_type = self.model.user.user_type;
        self.addToAldumView.cancelBlock = ^(){
            [weakSelf.addToAldumView removeFromSuperview];
        };
        self.addToAldumView.frame = CGRectMake(0.f, 0.f, kScreen_Width, kScreen_Height);
        self.addToAldumView.addToAlbumBlock = ^(NSInteger aldumIdx){
            [weakSelf.addToAldumView setUserInteractionEnabled:NO];
            [weakSelf requestAddToAldumWithIdx:[NSString stringWithFormat:@"%zi",aldumIdx]];
        };
        self.addToAldumView.newAlbumBlock = ^(){
            YWNodeAddAldumViewController * vc = [[YWNodeAddAldumViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        [self.addToAldumView aldumReload];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.addToAldumView];
    }
}

- (RBNodeDetailHeader *)authorHeaderMake{
    if (!self.authorHeader) {
        self.authorHeader = [[[NSBundle mainBundle]loadNibNamed:@"RBNodeDetailHeader" owner:nil options:nil] firstObject];
        WEAKSELF;
        self.authorHeader.node_id = self.model.homeID;
        self.authorHeader.careBlock = ^(){
            [weakSelf isLogin];
        };
        self.authorHeader.popBlock = ^(){
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        self.authorHeader.backToLoginBlock = ^(){
            [weakSelf promptView];
        };
        self.authorHeader.otherBlock = ^(){
            if ([weakSelf isLogin]&& !weakSelf.authorHeader.isUser) {
                if ([weakSelf isLogin]) {
//                    YWOtherSeePersonCenterViewController * vc = [[YWOtherSeePersonCenterViewController alloc]init];查看他人个人中心
//                    vc.uid = weakSelf.dataModel.user.userid;
//                    vc.nickName = weakSelf.dataModel.user.nickname;
//                    vc.otherIcon = weakSelf.dataModel.user.images;
//                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            }
        };
    }
    if (self.dataModel&&!self.authorHeader.model){
        self.authorHeader.isUser = [self.dataModel.user.userid integerValue]==([UserSession instance].uid?[UserSession instance].uid:0)?YES:NO;
        self.authorHeader.is_fans = self.dataModel.is_fans;
        self.authorHeader.model = self.dataModel.user;
    }
    return self.authorHeader;
}
- (void)promptView{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提醒" message:@"您的身份已过期，请重新登入" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
}

- (RBNodeDetailImageHeader *)imageHeaderMake{
    if (!self.imageHeader) {
        self.imageHeader = [[RBNodeDetailImageHeader alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, kScreen_Height)];
        self.imageHeader.scrollImageView.delegate = self;
    }
    if (self.dataModel){
        if (!self.imageHeader.imageList)self.imageHeader.imageList = self.dataModel.images_list;
        self.imageHeader.tagArr = self.dataModel.tags_info_2;
        [self.imageHeader refreshWithHeight:_scrollImageHeight];
    }
    return self.imageHeader;
}

- (RBNodeDetailCommentHeader *)commentHeaderMake{
    if (!self.commentHeader) {
        self.commentHeader = [[[NSBundle mainBundle]loadNibNamed:@"RBNodeDetailCommentHeader" owner:nil options:nil] firstObject];
        WEAKSELF;
        self.commentHeader.commentBlock = ^(){
            [weakSelf commentActionWithNodeDic:@{@"nodeID":weakSelf.model.homeID}];
        };
    }
    if (self.dataModel&&!self.commentHeader.iconURL){
        self.commentHeader.commentCount = self.dataModel.comments_list.count;
        self.commentHeader.iconURL = self.dataModel.user.images;
    }
    return self.commentHeader;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 10086 && self.dataModel) {//滑动图片
        self.scrollImageHeight = [self scrollImageCountHeightWithX:scrollView.contentOffset.x];
        return;
    }
    if (self.commentToolsView.hidden == NO) {
        [self cancelComment];
        self.commentToolsView.hidden = YES;
    }
    [UIView animateWithDuration:1 animations:^{
        if (scrollView.contentOffset.y <= self.bottomToolsHeight) {
            self.toolsBottomView.alpha = 1;
        }else{
            self.toolsBottomView.alpha = 0;
        }
    }];
//    self.toolsBottomView.hidden = scrollView.contentOffset.y <= self.bottomToolsHeight ?NO:YES;
}

#pragma mark - Set ScrollImageView Height
- (void)setScrollImageHeight:(CGFloat)scrollImageHeight{
    if (scrollImageHeight == _scrollImageHeight || !self.dataModel)return;
    _scrollImageHeight = scrollImageHeight;//重置高度
    [self tableView:self.tableView heightForHeaderInSection:1];
    [self tableView:self.tableView viewForHeaderInSection:1];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.y = scrollImageHeight + 54.f;//重置位置
    
    [UIView performWithoutAnimation:^{//重置位置取消动画
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (CGFloat)scrollImageCountHeightWithX:(CGFloat)contentX{
    NSInteger index = contentX / kScreen_Width;
    if (index + 1 >= self.dataModel.images_list.count)return _scrollImageHeight;
    CGFloat scrale = (contentX - index * kScreen_Width)/kScreen_Width;
    RBHomeListImagesModel * orginalModel = self.dataModel.images_list[index];
    CGFloat orginalHeigh = kScreen_Width * ([orginalModel.height floatValue]>0?[orginalModel.height floatValue]:320.f) / ([orginalModel.width floatValue]>0?[orginalModel.width floatValue]:320.f);
    RBHomeListImagesModel * scrollModel = self.dataModel.images_list[index + 1];
    CGFloat scrollHeight = kScreen_Width * ([scrollModel.height floatValue]>0?[scrollModel.height floatValue]:320.f) / ([scrollModel.width floatValue]>0?[scrollModel.width floatValue]:320.f);
    
    return orginalHeigh + (scrollHeight - orginalHeigh)*scrale;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        CGFloat height = [tableView fd_heightForCellWithIdentifier:DETAILCELL configuration:^(RBNodeDetailTableViewCell * cell) {
            cell.model = self.dataModel;
        }];
        self.scrollToolsHeight += height;
        return height;
    }else if (indexPath.section == 2){
        CGFloat height = [tableView fd_heightForCellWithIdentifier:COMMENTCELL configuration:^(RBNodeDCommentTableViewCell * cell) {
            cell.model = self.dataModel.comments_list[indexPath.row];
        }];
        self.scrollToolsHeight += height;
        return height;
    }
    
    self.recommendCell.dataArr = self.dataArr;
    return self.recommendCell.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        self.scrollToolsHeight += 55.f;
        return 55.f;
    }else if (section == 1){
        if (self.dataModel) {
            if (self.dataModel.images_list.count == 0) {
                return 10;
            }
            RBHomeListImagesModel * orginalModel = self.dataModel.images_list[0];
            self.scrollToolsHeight = self.scrollToolsHeight - _scrollImageHeight;
            if (_scrollImageHeight == 0) {
                _scrollImageHeight = kScreen_Width * ([orginalModel.height floatValue]>0?[orginalModel.height floatValue]:320.f) / ([orginalModel.width floatValue]>0?[orginalModel.width floatValue]:320.f);
            }
            self.scrollToolsHeight += _scrollImageHeight;
            return _scrollImageHeight;
        }
        return kScreen_Height/2;
    }
    self.scrollToolsHeight += section == 2?44.f : 50.f;
    return section == 2?44.f : 50.f;//50.f为相关笔记的高度？110.f
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataModel&&section == 2) {
        self.scrollToolsHeight += [self.dataModel.comments integerValue] >3?30.f:1.f;
        return [self.dataModel.comments integerValue] >3?30.f:1.f;
    }
    self.scrollToolsHeight += 1.f;
    return 1.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [self authorHeaderMake];
    }else if (section == 1){
        return [self imageHeaderMake];
    }else if (section == 2){
        return [self commentHeaderMake];
    }
    if (!self.recommendHeader) {
        self.recommendHeader = [[[NSBundle mainBundle]loadNibNamed:@"RBNodeDetailRecommendHeader" owner:nil options:nil] firstObject];
    }
    return self.recommendHeader;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.dataModel&&section == 2 && [self.dataModel.comments integerValue] >3) {
        if (!self.commentFooter) {
            self.commentFooter = [[[NSBundle mainBundle]loadNibNamed:@"RBNodeDetailCommendFooter" owner:nil options:nil] firstObject];
            self.commentFooter.commentCount = self.dataModel.comments;
            WEAKSELF;
            self.commentFooter.viewAllCommentBlock  = ^(){
                RBNodeShowCommentDetailVC * vc = [[RBNodeShowCommentDetailVC alloc]init];
                vc.idd = weakSelf.model.homeID;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        return self.commentFooter;
    }
    return nil;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {//回复用户评论
        RBNodeShowCommentModel * model = self.dataModel.comments_list[indexPath.row];
        if (model.user.nickname == nil) {
            model.user.nickname = @"";
        }

        [self commentActionWithUserDic:@{@"nodeID":self.model.homeID,@"userID":model.user.userid,@"userName":model.user.nickname}];
        return;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataModel?section == 0?0: section == 2?self.dataModel.comments_list.count >3?3:self.dataModel.comments_list.count:1:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        RBNodeDetailTableViewCell * detailCell = [tableView dequeueReusableCellWithIdentifier:DETAILCELL];
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        detailCell.model = self.dataModel;
        return detailCell;
    }else if (indexPath.section == 2){
        RBNodeDCommentTableViewCell * commentCell = [tableView dequeueReusableCellWithIdentifier:COMMENTCELL];
        commentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        commentCell.model = self.dataModel.comments_list[indexPath.row];
        return commentCell;
    }
    return self.recommendCell;
}
-(void)notice:(id)sender{
    [self requestData];
}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.tableView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}

- (void)footerRereshing{
    self.pages++;
    self.failedCount = 0;
    [self requestDataWithPages:self.pages];
}

- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (!isHeader)[self.tableView.mj_footer endRefreshing];
}

#pragma mark - Http
- (void)requestData{
    if (self.note_id == nil) {
        self.note_id = self.model.homeID;
        
    }

    NSDictionary * pragram = @{@"token":[UserSession instance].token,@"note_id":self.note_id,@"device_id":[JWTools getUUID],@"user_id":@([UserSession instance].uid),@"user_type":@([UserSession instance].isVIP==3?2:1)};
    
    [[HttpObject manager]postDataWithType:YuWaType_RB_DETAIL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is 1 %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSMutableDictionary * dataDic = [RBNodeShowModel dataDicSetWithDic:responsObj[@"data"]];
        [dataDic setObject:self.note_id forKey:@"id"];
        self.dataModel = [RBNodeShowModel yy_modelWithDictionary:dataDic];
        self.scrollToolsHeight = 0.f;
        [self reSetBottomToolsView];
        [self requestDataWithPages:0];//瀑布流数据
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is 2 %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}
- (void)requestDataWithPages:(NSInteger)page{
    if (self.note_id == nil) {
        self.note_id = self.model.homeID;
        
    }
    NSDictionary * pragram = @{@"note_id":self.note_id,@"pagen":self.pagens,@"pages":[NSString stringWithFormat:@"%zi",page],@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"user_type":@([UserSession instance].isVIP==3?2:1)};
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    if (page==0) {
        [self.tableView.mj_footer endRefreshing];
    }
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_RELATED withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is  3%@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page == 0) {
            [self.dataArr removeAllObjects];
        }
        NSArray * dataArr = responsObj[@"data"];
        if (dataArr.count>0) {
            for (int i = 0; i < dataArr.count; i++) {
                NSDictionary * dic = dataArr[i];
                NSMutableDictionary * dataDic = [RBHomeModel dataDicSetWithDic:dic];
                [self.dataArr addObject:[RBHomeModel yy_modelWithDictionary:dataDic]];
            }
            [self.tableView reloadData];
            self.bottomToolsHeight = self.bottomToolsHeight == 0.f? self.scrollToolsHeight/2 : self.bottomToolsHeight;
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is 4 %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        if (self.failedCount > 3) {
            [self.tableView reloadData];
        }else{
            self.failedCount++;
            [self requestDataWithPages:page];
        }
    }];
}
- (void)requestAddToAldumWithIdx:(NSString *)aldumIdx{
    MyLog(@"添加到专辑%@",aldumIdx);
    if (self.addToAldumView.dataArr.count<=0) {
        YWNodeAddAldumViewController * vc = [[YWNodeAddAldumViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [self.addToAldumView setUserInteractionEnabled:YES];
        [self.addToAldumView removeFromSuperview];
        return;
    }
    RBNodeAddToAldumModel * aldumModel = self.addToAldumView.dataArr[[aldumIdx integerValue]];
    NSString * album_id = aldumModel.aldumID;
    
    NSDictionary * pragram = @{@"note_id":self.model.homeID,@"album_id":album_id,@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"user_type":@([UserSession instance].isVIP==3?2:1),@"auser_type":self.model.user.user_type};//album_id没有将创建默认
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_COLLECTION_TO_ALDUM withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is  5 %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        self.toolsBottomView.isCollection = !self.toolsBottomView.isCollection;
        self.dataModel.infavs = @"1";
        [self.addToAldumView setUserInteractionEnabled:YES];
        self.dataModel.fav_count = [NSString stringWithFormat:@"%zi",([self.dataModel.fav_count integerValue] + 1)];
        if (![UserSession instance].aldumCount||[[UserSession instance].aldumCount integerValue]<=0)[UserSession instance].aldumCount = @"1";//成功后若无专辑则创建
        [self reSetBottomToolsView];
        [self.addToAldumView removeFromSuperview];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        [self.addToAldumView setUserInteractionEnabled:YES];
    }];
}

- (void)requestCancelToAldum{
    if (self.note_id == nil) {
        self.note_id = self.model.homeID;
        
    }

    NSDictionary * pragram = @{@"note_id":self.note_id,@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"user_type":@([UserSession instance].isVIP==3?2:1),@"auser_type":self.model.user.user_type};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_COLLECTION_CANCEL withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        self.dataModel.infavs = @"0";
        self.dataModel.fav_count = [NSString stringWithFormat:@"%zi",([self.dataModel.fav_count integerValue] - 1)];
        self.toolsBottomView.isCollection = !self.toolsBottomView.isCollection;
        [self reSetBottomToolsView];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
