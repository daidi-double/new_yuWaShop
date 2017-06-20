//
//  YWHomeViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeViewController.h"
#import "YWFinancialViewController.h"   //财务管理
#import "ShowMoreCommitViewController.h"   //口碑管理
#import "StorePhotoViewController.h"      //相册管理
#import "YWHomeNoticaficationViewController.h"
#import "YWHomeQuickPayListVC.h"
#import "YWHomePayBillViewController.h"

#import "YWPersonShopViewController.h"
#import "YWCategoryViewController.h"
#import "YWHomeRefundVC.h"
#import "YWHomeFestivalViewController.h"
#import "YWHomeCompareViewController.h"
#import "YWHomeCouponViewController.h"
#import "YWHomeAdvanceOrderViewController.h"

#import "YWHomeCollectionViewCell.h"
#import "YWHomeCollectionHeaderView.h"

#import "YWMessageTableViewCell.h"
#import "VIPTabBarController.h"
@interface YWHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,EMChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSArray * nameArr;
@property (nonatomic,strong)NSArray * IDSArr;
@property (nonatomic,strong)NSArray * imgNameArr;
@property (nonatomic,strong)NSArray * subVCArr;

@property (nonatomic,strong)UIBarButtonItem * rightBarBtn;

@end

@implementation YWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self dataSet];
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

}
#pragma mark ---------------------------------------接收消息回调------------------

-(void)messagesDidReceive:(NSArray *)aMessages{
    
    for (EMMessage *message in aMessages) {
        if (message.body.type == EMMessageBodyTypeText) {
            MyLog(@"接收到文字消息");
            WEAKSELF;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf requestShopArrData];
                
            });
        }
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self isNewNotification:[UserSession instance].isNewNoticafication];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
}

- (void)makeNavi{
    self.title = @"首页";
    self.rightBarBtn = [UIBarButtonItem barItemWithImageName:@"MessageNoChatWhite" withSelectImage:@"MessageNoChatWhite" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside withWidth:30.f];
    CGFloat redWidth = 8.f;
    UILabel * redLabel = [[UILabel alloc]initWithFrame:CGRectMake(20.f, 5.f, redWidth, redWidth)];
    redLabel.backgroundColor = [UIColor redColor];
    redLabel.layer.cornerRadius = redWidth/2;
    redLabel.layer.masksToBounds = YES;
    redLabel.tag = 1001;
    redLabel.hidden = YES;
    [self.rightBarBtn.customView addSubview:redLabel];
    self.navigationItem.rightBarButtonItem = self.rightBarBtn;
}

- (void)isNewNotification:(BOOL)isNew{
    UILabel * redLabel = (UILabel *)[self.rightBarBtn.customView viewWithTag:1001];
    redLabel.hidden = !isNew;
}
//Home_IMG1"
- (void)dataSet{
    self.IDSArr = @[@"1",@"3",@"4",@"5",@"未定",@"6",@"7",@"8",@"未定"];
    self.nameArr = @[@"财务管理",@"提现管理",@"商品管理",@"口碑品牌",@"退款管理",@"预定管理",@"优惠券",@"相册管理",@"同业排行"];
    self.imgNameArr = @[@"Home_IMG0",@"Home_IMG9",@"Home_IMG1",@"Home_IMG3",@"Home_IMG4",@"Home_IMG5",@"Home_IMG2",@"Home_IMG7",@"Home_IMG8"];
    self.subVCArr = @[[YWFinancialViewController class],[YWHomeFestivalViewController class],[YWCategoryViewController class],[ShowMoreCommitViewController class],[YWHomeRefundVC class],[YWHomeAdvanceOrderViewController class],[YWHomeCouponViewController class],[StorePhotoViewController class],[YWHomeCompareViewController class]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YWHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YWHomeCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YWHomeCollectionHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YWHomeCollectionHeaderView"];
    
    
    
    //加载完数据之后，判断是否是推送了通知，如果是，就跳转制定页面
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString * filePath1 = [NSString stringWithFormat:@"%@/isPush.plist",documentPath];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath1];
    if (dic == nil) {
        //表示没有这个文件时候。我们创建一个.plist文件
        NSMutableDictionary* arrM = [NSMutableDictionary dictionary];
        [arrM setObject:@"0" forKey:@"ispush"];
        [arrM writeToFile:filePath1 atomically:YES];
    }else{
        //说明已经有数据，在字典里面
        NSString * str = dic[@"ispush"];
        if ([str isEqualToString:@"1"]) {
            //说明是通知发送过来的
            YWHomeAdvanceOrderViewController*vc=[[YWHomeAdvanceOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            //跳转之后，把数据还原；
            [dic setValue:@"0" forKey:@"ispush"];
            [dic writeToFile:filePath1 atomically:YES];
        }
    }
}

- (void)messageAction{
    if (![UserSession userToComfired])return;
    YWHomeNoticaficationViewController * vc = [[YWHomeNoticaficationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    YWHomeCollectionHeaderView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YWHomeCollectionHeaderView" forIndexPath:indexPath];
    WEAKSELF;
    header.payBlock = ^(){
        if ([UserSession userToComfired]){
            if ([UserSession instance].routes.count>0) {
                
                if ([UserSession judgeIsLimit:@"2"]) {
                    
                    YWHomePayBillViewController * vc = [[YWHomePayBillViewController alloc]init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    [JRToast showWithText:@"没有权限" duration:1.5];
                }
            }else{
                YWHomePayBillViewController * vc = [[YWHomePayBillViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    };
    header.recordBlock = ^(){
        if ([UserSession userToComfired]){
            if ([UserSession instance].routes.count>0) {
                
                if ([UserSession judgeIsLimit:@"15"]) {
                    
                    YWHomeQuickPayListVC * vc = [[YWHomeQuickPayListVC alloc]init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }else{
                    [JRToast showWithText:@"没有权限" duration:1.5];
                }
            }else{
                YWHomeQuickPayListVC * vc = [[YWHomeQuickPayListVC alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    };
    return header;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.nameArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YWHomeCollectionViewCell * homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YWHomeCollectionViewCell" forIndexPath:indexPath];
    homeCell.nameLabel.text = self.nameArr[indexPath.row];
    homeCell.showImage.image = [UIImage imageNamed:self.imgNameArr[indexPath.row]];
    return homeCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![UserSession userToComfired])return;
    if ([UserSession instance].routes.count>0) {
        
        if ([UserSession judgeIsLimit:self.IDSArr[indexPath.row]]) {
            
            Class viewClass = (Class)self.subVCArr[indexPath.row];
            UIViewController * vc = [[viewClass alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [JRToast showWithText:@"没有权限" duration:1.5];
        }
    }else{
        Class viewClass = (Class)self.subVCArr[indexPath.row];
        UIViewController * vc = [[viewClass alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreen_Width/3, ACTUAL_WIDTH(110.f));
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreen_Width, 175.f);
}

#pragma mark --- 用来设置消息模块有几条信息是未读的
- (void)requestShopArrData{
    //    NSInteger page = 1;
    NSMutableArray * dataArr = [NSMutableArray array];
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
        if (model&&([YWMessageTableViewCell latestMessageTitleForConversationModel:model].length>0)){
            [dataArr addObject:model];
            NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_username":([model.title length] > 0?model.title:model.conversation.conversationId),@"user_type":@(2)};
            [[HttpObject manager]postNoHudWithType:YuWaType_FRIENDS_INFO withPragram:pragram success:^(id responsObj) {
                
                YWMessageAddressBookModel * modelTemp = [YWMessageAddressBookModel yy_modelWithDictionary:responsObj[@"data"]];
                modelTemp.hxID = [model.title length] > 0?model.title:model.conversation.conversationId;
                model.title = modelTemp.nikeName;
                model.avatarURLPath = modelTemp.header_img;
                model.jModel = modelTemp;
                [dataArr replaceObjectAtIndex:i withObject:model];
                count++;
                int badgeValue = 0;
                for (EaseConversationModel * model in dataArr) {
                    badgeValue += model.conversation.unreadMessagesCount;
                }
                VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                UITabBarItem * item=[rootTabBarVC.tabBar.items objectAtIndex:3];
                item.badgeValue=[NSString stringWithFormat:@"%d",badgeValue];
                if (badgeValue == 0) {
                    item.badgeValue = nil;
                }
                //还原
            } failur:^(id responsObj, NSError *error) {
                //                [JRToast showWithText:];
//                [self showHUDWithStr:responsObj[@"errorMessage"]withSuccess:YES];
                MyLog(@"%@~~~~~%@",error,responsObj);
            }];
        }
    }
}

@end
