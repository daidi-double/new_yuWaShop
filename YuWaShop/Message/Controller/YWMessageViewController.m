//
//  YWMessageViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/27.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageViewController.h"
#import "YWLoginViewController.h"
#import "YWMessageNotificationViewController.h"
#import "YWMessageFriendsAddViewController.h"
#import "YWMessageChatViewController.h"
#import "YWMessageAddressBookTableView.h"
#import "EaseUI.h"
#import "NSDictionary+Attributes.h"
#import "VIPTabBarController.h"
#import "YWMessageTableViewCell.h"

#import "VoiceChatViewController.h"

#define MESSAGECELL @"YWMessageTableViewCell"
@interface YWMessageViewController ()<UITableViewDelegate,UITableViewDataSource,EMContactManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *noLoginBGBtnView;
@property (nonatomic,strong)UIImageView *noChatBGBtnView;
@property (nonatomic,strong)UILabel * noChatlabel;

@property (nonatomic,strong)NSMutableArray * dataAry;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;

@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)UISegmentedControl * segmentedControl;
@property (nonatomic,strong)YWMessageAddressBookTableView * addressBooktableView;
@property (nonatomic,strong)UIBarButtonItem * rightBarBtn;
@property (nonatomic,copy)NSString * type;

@property (nonatomic,strong)VoiceChatViewController * voiceController;
@end

@implementation YWMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
    [self dataSet];
    [self setupRefresh];
    
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    //移除好友回调
    [[EMClient sharedClient].contactManager removeDelegate:self];
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];


}




- (void)messagesDidReceive:(NSArray *)aMessages{
    [self.tableView reloadData];
}

/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    [JRToast showWithText:[NSString stringWithFormat:@"收到%@的好友请求",aUsername] duration:1];
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
        
    });
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    self.noLoginBGBtnView.hidden = YES;
    self.noChatBGBtnView.hidden = YES;
    self.noChatlabel.hidden = self.noChatBGBtnView.hidden;
    if (self.status == 1&&![UserSession instance].isLogin){
        self.segmentedControl.selectedSegmentIndex = 0;
        [self headerRereshing];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![UserSession instance].isLogin){
        [self withOutLogion];
        return;
    }else if(self.status == 0){
        [self headerRereshing];
    }else if (self.status == 1&&self.addressBooktableView) {
        [self.addressBooktableView headerRereshing];
    }
}

- (void)dataSet{
    self.dataAry = [NSMutableArray arrayWithCapacity:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGECELL bundle:nil] forCellReuseIdentifier:MESSAGECELL];
}

- (void)makeUI{
    self.tableView.alwaysBounceVertical = YES;
    self.noChatBGBtnView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width/2-40.f, kScreen_Height/2 - 80.f, 80.f, 80.f)];
    self.noChatBGBtnView.image = [UIImage imageNamed:@"MessageNoChat"];
    self.noChatBGBtnView.hidden = YES;
    [self.view addSubview:self.noChatBGBtnView];
    
    self.noChatlabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(self.noChatBGBtnView.frame), kScreen_Width, 21.f)];
    self.noChatlabel.textAlignment = NSTextAlignmentCenter;
    self.noChatlabel.text = @"暂时没有新消息";
    self.noChatlabel.textColor = [UIColor colorWithHexString:@"#b1b4bb"];
    self.noChatlabel.font = [UIFont systemFontOfSize:17.f];
    self.noChatlabel.hidden = YES;
    [self.view addSubview:self.noChatlabel];
    self.type = @"1";
    [self addressBookMake];
}
- (void)makeNavi{
    self.segmentedControl = [self makeSegmentedControl];
    self.navigationItem.titleView = self.segmentedControl;
    
    
}

- (UISegmentedControl *)makeSegmentedControl{
    UISegmentedControl * segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"消息",@"通讯录"]];
    segmentControl.frame = CGRectMake(0.f, 0.f, ACTUAL_WIDTH(180.f), 30.f);
    segmentControl.tintColor = [UIColor whiteColor];
    segmentControl.selectedSegmentIndex = 0;
    segmentControl.layer.cornerRadius = 5.f;
    segmentControl.layer.masksToBounds = YES;
    segmentControl.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentControl.layer.borderWidth = 2.f;
    [segmentControl setTitleTextAttributes:[NSDictionary dicOfTextAttributeWithFont:[UIFont systemFontOfSize:15.f] withTextColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [segmentControl addTarget:self action:@selector(segmentControlAction:) forControlEvents:UIControlEventValueChanged];
    return segmentControl;
}

- (void)addressBookMake{
    self.addressBooktableView = [[YWMessageAddressBookTableView alloc]initWithFrame:CGRectMake(0.f, 64.f, kScreen_Width, kScreen_Height - 64.f - 49.f) style:UITableViewStylePlain];
    [self.addressBooktableView dataSet];
    WEAKSELF;
    self.addressBooktableView.friendsAddBlock = ^(){
        YWMessageFriendsAddViewController * vc = [[YWMessageFriendsAddViewController alloc]init];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            YWMessageAddressBookTableViewCell * firstCell = [weakSelf.addressBooktableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            firstCell.countLabel.hidden = YES;
        });
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.addressBooktableView.friendsChatBlock = ^(YWMessageAddressBookModel * model){
        [weakSelf chatWithUser:model];
    };
    [self.view addSubview:self.addressBooktableView];
}

#pragma mark - Control Action
- (IBAction)noLoginBGBtnAvtion:(id)sender {
    if (![UserSession instance].isLogin){
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)withOutLogion{
    self.noLoginBGBtnView.hidden = NO;
    UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YWLoginViewController * vc = [[YWLoginViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    }];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先登录" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:cancelAction];
    [alertVC addAction:OKAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)segmentControlAction:(UISegmentedControl *)sender{
    self.status = sender.selectedSegmentIndex;
    
    if (!self.addressBooktableView)return;
    self.addressBooktableView.hidden = sender.selectedSegmentIndex == 0?YES:NO;
    
    if (sender.selectedSegmentIndex == 0) {
        [self.tableView.mj_header beginRefreshing];
    }else{
        [self.addressBooktableView.mj_header beginRefreshing];
    }
}

- (void)pushMessagesViewAction{
    YWMessageNotificationViewController * vc = [[YWMessageNotificationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)isNewNotification:(BOOL)isNew{
    UILabel * redLabel = (UILabel *)[self.rightBarBtn.customView viewWithTag:1001];
    redLabel.hidden = !isNew;
}
- (void)chatWithUser:(YWMessageAddressBookModel *)model{
    YWMessageChatViewController *chatVC = [[YWMessageChatViewController alloc] initWithConversationChatter:model.hxID conversationType:EMConversationTypeChat];
    
    if ([model.friend_remark isEqualToString:@""]) {
        
        chatVC.friendNikeName = model.nikeName;
    }else{
        chatVC.friendNikeName = model.friend_remark;
    }
    chatVC.friendID = model.user_id;
    chatVC.friendIcon = model.header_img;
    
    
    //    从服务器获取所有的好友
    NSArray *userlist;
    EMError *error = nil;
    userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    
    if (error){
        //        从数据库获取所有的好友
        userlist = [[EMClient sharedClient].contactManager getContacts];
    }
    if (!userlist||userlist.count<=0) {
        chatVC.chatMessage = @"你们已不是好友了哦~";
    }else{
        [userlist enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:model.hxID]) {
                chatVC.chatMessage = nil;
                *stop = YES;
                
            }else{
                chatVC.chatMessage = @"你们已不是好友了哦~";
                return ;
            }
        }];
    }
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.f;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        if (indexPath.row<[self.dataAry count]) {
            EaseConversationModel *model = self.dataAry[indexPath.row];
            [self.dataAry removeObjectAtIndex:indexPath.row];//移除数据源的数据
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                
                [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId isDeleteMessages:YES completion:nil];
                
            });
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMessageTableViewCell * messageCell = [tableView cellForRowAtIndexPath:indexPath];
    [self chatWithUser:messageCell.model.jModel];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.noChatBGBtnView.hidden = self.dataAry.count != 0?YES:NO;
    if (![UserSession instance].isLogin)self.noChatBGBtnView.hidden = YES;
    self.noChatlabel.hidden = self.noChatBGBtnView.hidden;
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMessageTableViewCell * messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGECELL];
    messageCell.model = self.dataAry[indexPath.row];
    
    return messageCell;
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
- (void)footerRereshing{
    self.pages++;
    [self requestShopArrDataWithPages:self.pages];
}
- (void)headerRereshing{
    self.pages = 0;
    if ([UserSession instance].isLogin ) {
        [self requestShopArrDataWithPages:0];
    }else{
        [self cancelRefreshWithIsHeader:YES];
    }
}
- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
}
#pragma mark - Http
- (void)requestShopArrDataWithPages:(NSInteger)page{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    if (page>0){
        return;
    }else{
        [self.dataAry removeAllObjects];
    }
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorted = [conversations sortedArrayUsingComparator:^(EMConversation *obj1, EMConversation* obj2){
        EMMessage *message1 = [obj1 latestMessage];
        EMMessage *message2 = [obj2 latestMessage];
        if(message1.timestamp > message2.timestamp) {
            return(NSComparisonResult)NSOrderedAscending;
        }else {
            return(NSComparisonResult)NSOrderedDescending;
        }
    }];
    
    __block NSInteger count = 0;
    for (int i = 0; i<sorted.count; i++) {
        EMConversation * converstion = sorted[i];
        EaseConversationModel * model = [[EaseConversationModel alloc] initWithConversation:converstion];
        NSString * username;
        NSString * firstNum = [[model.title length] > 0?model.title:model.conversation.conversationId substringToIndex:1];
        if (model&&([YWMessageTableViewCell latestMessageTitleForConversationModel:model].length>0)){
            [self.dataAry addObject:model];
            username = [model.title length] > 0?model.title:model.conversation.conversationId;
            if (model.title.length >= 12 && [firstNum isEqualToString:@"2"]) {
                username = [[model.title substringFromIndex:1] substringToIndex:11];
                _type = @"2";
            }else {
                _type = @"1";
            }
            if ([firstNum isEqualToString:@"2"]) {
                username = [[model.title substringFromIndex:1] substringToIndex:11];
                _type = @"2";
            }
            NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_username":username,@"user_type":@(2),@"type":self.type};
            [[HttpObject manager]postNoHudWithType:YuWaType_FRIENDS_INFO withPragram:pragram success:^(id responsObj) {
                MyLog(@"Regieter Code pragram is %@",pragram);
                MyLog(@"对话Regieter Code is %@",responsObj);
                YWMessageAddressBookModel * modelTemp = [YWMessageAddressBookModel yy_modelWithDictionary:responsObj[@"data"]];
                modelTemp.hxID = [model.title length] > 0?model.title:model.conversation.conversationId;
                model.title = modelTemp.nikeName;
                model.avatarURLPath = modelTemp.header_img;
                model.jModel = modelTemp;
                [self.dataAry replaceObjectAtIndex:i withObject:model];
                
                count++;
                int badgeValue = 0;
                
                for (EaseConversationModel * model in self.dataAry) {
                    badgeValue += model.conversation.unreadMessagesCount;
                }
                VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                UITabBarItem * item=[rootTabBarVC.tabBar.items objectAtIndex:3];
                NSMutableArray * friendsRequest = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:FRIENDSREQUEST]];
                if (!friendsRequest)friendsRequest = [NSMutableArray arrayWithCapacity:0];
                if (friendsRequest.count > 0) {
                    NSInteger unRedCount = 0;
                    for (NSDictionary * requestDic in friendsRequest) {
                        if ([requestDic[@"status"] isEqualToString:@"0"])unRedCount++;
                    }
                    badgeValue += unRedCount;
                    
                    
                }
                item.badgeValue=[NSString stringWithFormat:@"%d",badgeValue];
                if (badgeValue == 0) {
                    item.badgeValue = nil;
                }
                
                
                [self.tableView reloadData];
                
                
            } failur:^(id responsObj, NSError *error) {
                MyLog(@"Regieter Code pragram is %@",pragram);
                MyLog(@"对话列表Regieter Code error is %@",responsObj);
                static int a = 0;
                a++ ;
                if (a== 1) {
                    
                    if ([responsObj[@"errorCode"] integerValue] == 1) {
                        self.type = @"2";
                        [self requestShopArrDataWithPages:0];
                    }
                }
                if (count>0) {
                    [self.tableView reloadData];
                }
                if ([responsObj[@"errorMessage"] isEqualToString:@"没有权限"]) {
                    [self.dataAry removeAllObjects ];
                    [self.tableView reloadData];
                }
            }];
        }
        [self.tableView reloadData];
    }
     [self.tableView reloadData];
}

@end
