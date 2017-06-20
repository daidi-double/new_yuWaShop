//
//  YWMessageFriendsAddViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageFriendsAddViewController.h"
//#import "YWOtherSeePersonCenterViewController.h"

#import "YWMessageFriendAddCell.h"
#import "YWMessageSearchFriendAddCell.h"

#define MESSAGEADDFRIENDSEARCHCELL @"YWMessageSearchFriendAddCell"
#define MESSAGEADDFRIENDCELL @"YWMessageFriendAddCell"
@interface YWMessageFriendsAddViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YWMessageSearchFriendAddCellDelegate>
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * searchDataArr;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *searchBGView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YWMessageFriendsAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友申请";
    [self dataSet];
    [self makeUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0]setAlpha:1];
}

- (void)dataSet{
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGEADDFRIENDCELL bundle:nil] forCellReuseIdentifier:MESSAGEADDFRIENDCELL];
    [self.tableView registerNib:[UINib nibWithNibName:MESSAGEADDFRIENDSEARCHCELL bundle:nil] forCellReuseIdentifier:MESSAGEADDFRIENDSEARCHCELL];
    self.tableView.alwaysBounceVertical = YES;
    
    self.searchDataArr = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray * friendsRequest = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:FRIENDSREQUEST]];
    if (!friendsRequest)friendsRequest = [NSMutableArray arrayWithCapacity:0];
    if (friendsRequest.count > 0) {
        for (int i = 0; i<friendsRequest.count; i++) {
            NSMutableDictionary * requestDic = [NSMutableDictionary dictionaryWithDictionary:friendsRequest[i]];
            if ([requestDic[@"status"] isEqualToString:@"0"]){
                [requestDic setObject:@"1" forKey:@"status"];
                [friendsRequest replaceObjectAtIndex:i withObject:requestDic];
            }
        }
        [KUSERDEFAULT setObject:friendsRequest forKey:FRIENDSREQUEST];
    }
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [friendsRequest enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull requestDic, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArr addObject:[YWMessageFriendAddModel yy_modelWithDictionary:requestDic]];
    }];
}

- (void)makeUI{
    self.searchBGView.layer.cornerRadius = 5.f;
    self.searchBGView.layer.masksToBounds = YES;
}

- (BOOL)isSearch{
    return ![self.searchTextField.text isEqualToString:@""];
}

#pragma mark- UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchTextField resignFirstResponder];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self isSearch]?50.f:75.f;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self isSearch]?UITableViewCellEditingStyleNone:UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isSearch])return;
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        YWMessageFriendAddModel * model = self.dataArr[indexPath.row];
        if ([model.status isEqualToString:@"1"]) {
            EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:model.hxID];
            if (!error) {
                MyLog(@"发送拒绝成功");
                NSMutableArray * friendsRequest = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:FRIENDSREQUEST]];
                [friendsRequest removeObjectAtIndex:indexPath.row];
                [KUSERDEFAULT setObject:friendsRequest forKey:FRIENDSREQUEST];
            }
        }else{
            NSMutableArray * friendsRequest = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:FRIENDSREQUEST]];
            [friendsRequest removeObjectAtIndex:indexPath.row];
            [KUSERDEFAULT setObject:friendsRequest forKey:FRIENDSREQUEST];
        }
        [self.dataArr removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isSearch]) {
        //        YWOtherSeePersonCenterViewController * vc = [[YWOtherSeePersonCenterViewController alloc]init];
        //        YWMessageSearchFriendAddModel * model = self.searchDataArr[indexPath.row];
        //        vc.uid = model.user_id;
        //        vc.nickName = model.nickName;
        //        vc.otherIcon = model.header_img;
        //        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self isSearch]?self.searchDataArr.count:self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isSearch]) {
        YWMessageSearchFriendAddCell * searchCell = [tableView dequeueReusableCellWithIdentifier:MESSAGEADDFRIENDSEARCHCELL];
        searchCell.model = self.searchDataArr[indexPath.row];
        searchCell.delegate = self;
        return searchCell;
    }
    
    YWMessageFriendAddCell * friendCell = [tableView dequeueReusableCellWithIdentifier:MESSAGEADDFRIENDCELL];
    friendCell.model = self.dataArr[indexPath.row];
    return friendCell;
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.searchDataArr.count > 0) {
        if (![self judgeSendRequest]) {
            return NO;
        }
        YWMessageSearchFriendAddModel * model = self.searchDataArr[0];
        if (model.hxID == nil) {
            model.hxID = self.searchTextField.text;
        }
        EMError *error = [[EMClient sharedClient].contactManager addContact:model.hxID message:@"我想加您为好友"];
        if (!error) {
            MyLog(@"添加成功");
        }else{
            MyLog(@"%u",error.code);
        }

        return YES;
    }
    if ([self.searchTextField.text isEqualToString:[UserSession instance].account]){
        [JRToast showWithText:@"不能添加自己为好友" duration:2];
        
    }else{
        [self showHUDWithStr:@"不存在该用户" withSuccess:NO];
    }
    return NO;
}
- (void)addFriends{
    YWMessageSearchFriendAddModel * model = self.searchDataArr[0];
    if (model.hxID == nil) {
        model.hxID = self.searchTextField.text;
    }
    if (![self judgeSendRequest]) {
        return;
    }
    EMError *error = [[EMClient sharedClient].contactManager addContact:model.hxID message:@"我想加您为好友"];
    if (!error) {
        MyLog(@"添加成功");
        [JRToast showWithText:@"好友请求发送成功" duration:1.5];
    }else{
        [JRToast showWithText:@"好友请求发送失败,请稍后再试" duration:1.5];
    }
    

    
}
- (BOOL)judgeSendRequest{
    if ([self.searchTextField.text isEqualToString:[UserSession instance].account]){
        [JRToast showWithText:@"不能添加自己为好友" duration:2];
        return NO;
    }else if (self.searchDataArr.count <=0){
        [self showHUDWithStr:@"不存在该用户" withSuccess:NO];
        return NO;
    }else if (![self getFriendsList:self.searchTextField.text]){
        [self showHUDWithStr:@"你们已经是好友了" withSuccess:NO];
        return NO;
    }
    return YES;
}

- (BOOL )getFriendsList:(NSString *)username{
    //    从服务器获取所有的好友
    NSArray *userlist;
    EMError *error = nil;
    userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    
    if (error){
        //        从数据库获取所有的好友
        userlist = [[EMClient sharedClient].contactManager getContacts];
    }
    if (!userlist||userlist.count<=0) {
        
        return YES;
    }
    for (NSString * userName in userlist) {
        if ([userName isEqualToString:username]) {
            return NO;
        }
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (textField.text.length>10) {
            [self.tableView scrollsToTop];
            [self requestSearchFriend];
        }else if (self.searchDataArr.count > 0){
            [self.searchDataArr removeAllObjects];
        }
    });
    return YES;
}

#pragma mark - Http
- (void)requestSearchFriend{
    if ([self.searchTextField.text isEqualToString:[UserSession instance].account]){
        [JRToast showWithText:@"不能添加自己为好友" duration:2];
        return;
    }
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_username":self.searchTextField.text,@"user_type":@(2)};
    [[HttpObject manager]postNoHudWithType:YuWaType_FRIENDS_INFO withPragram:pragram success:^(id responsObj) {
        MyLog(@"参数Regieter Code pragram is %@",pragram);
        MyLog(@"加好友Regieter Code is %@",responsObj);
        if (responsObj[@"data"][@"user_id"]) {
            [self.searchDataArr removeAllObjects];
            YWMessageSearchFriendAddModel * model = [YWMessageSearchFriendAddModel yy_modelWithDictionary:responsObj[@"data"]];
            
            [self.searchDataArr addObject:model];
            [self.tableView reloadData];
        }
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"加好友Regieter Code error is %@",responsObj);
        if ([responsObj[@"errorCode"] integerValue] == 9) {
            [JRToast showWithText:responsObj[@"errorMessage"] duration:2];
        }
    }];
}

@end
