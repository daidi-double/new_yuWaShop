//
//  YWMessageNotificationCell.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageFriendAddCell.h"
#import "YWMessageAddressBookModel.h"
#import "HttpObject.h"

#import "JWTools.h"
@implementation YWMessageFriendAddCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.iconImageView.layer.cornerRadius = 25.f;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.agreementBtn.layer.cornerRadius = 3.f;
    self.agreementBtn.layer.masksToBounds = YES;
    self.refuseBtn.layer.cornerRadius = 3.f;
    self.refuseBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setModel:(YWMessageFriendAddModel *)model{
    if (!model)return;
    _model = model;
    [self dataSet];
}

- (void)dataSet{
    self.conLabel.text = self.model.message;
    [self makeUIWithStatus:self.model.status];
    [self requestFriendData];
}

- (void)makeUIWithStatus:(NSString *)status{//0未读1未处理2同意3拒绝
    self.agreementBtn.hidden = [status isEqualToString:@"1"]?NO:YES;
    self.refuseBtn.hidden = [status isEqualToString:@"1"]?NO:YES;
    self.statesLabel.hidden = [status isEqualToString:@"1"]?YES:NO;
    self.statesLabel.text = [status isEqualToString:@"2"]?@"已同意":@"已拒绝";
    if ([status integerValue]>1) {
        NSMutableArray * friendsRequest = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:FRIENDSREQUEST]];
        for (int i = 0; i < friendsRequest.count; i++) {
            NSMutableDictionary * requestDic = [NSMutableDictionary dictionaryWithDictionary:friendsRequest[i]];
            if ([requestDic[@"hxID"] isEqualToString:self.model.hxID]) {
                [requestDic setObject:status forKey:@"status"];
                [friendsRequest replaceObjectAtIndex:i withObject:requestDic];
                break;
            }
        }
        [KUSERDEFAULT setObject:friendsRequest forKey:FRIENDSREQUEST];
    }
}

- (IBAction)agreementBtnAction:(id)sender {
    if ([self judgeIsFriends]) {
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:self.model.hxID];
        if (!error){
            MyLog(@"发送同意成功");
            [self makeUIWithStatus:@"2"];
        }
        
    }else{
        [self.delegate delFriendRequset:self.row];
        return;
        
    }

    
}
- (BOOL)judgeIsFriends{
    //    从服务器获取所有的好友
    NSArray *userlist;
    EMError *errors = nil;
    userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&errors];
    
    if (errors){
        //        从数据库获取所有的好友
        userlist = [[EMClient sharedClient].contactManager getContacts];
    }
    if (!userlist||userlist.count<=0) {
        return YES;//可以加为好友
    }else{
        for (NSString * strs in userlist) {
            if ([strs isEqualToString:self.model.hxID]) {
                [JRToast showWithText:@"你们已经是好友了" duration:1];
                return NO;
            }else if ([[strs substringFromIndex:1] isEqualToString:self.model.hxID]){
                [JRToast showWithText:@"你们已经是好友了" duration:1];
                return NO;
            }
        }
        return YES;
    }

}
- (IBAction)refuseBtnAction:(id)sender {
    if (![self judgeIsFriends]) {
        [self.delegate delFriendRequset:self.row];
        return;
    }
    EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:self.model.hxID];
    if (!error) {
        MyLog(@"发送拒绝成功");
        [self makeUIWithStatus:@"3"];
    }
}

#pragma mark - Http
- (void)requestFriendData{
    NSInteger type = 1;
    NSString * accounts = self.model.hxID;
    NSString * firstNum = [self.model.hxID substringToIndex:1];//第一个数字
    if (self.model.hxID.length == 12) {
        NSString * account = [self.model.hxID substringFromIndex:1];
        if ([JWTools isPhoneIDWithStr:account]) {
            type = 2;
            accounts = account;
        }
    }else if ([firstNum isEqualToString:@"2"]){
            if ([JWTools checkIsHaveNumAndLetter:accounts] == 3) {
            type = 2;
            accounts = [accounts substringFromIndex:1];
        }else{
            type = 1;
        }
    }
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_username":accounts,@"type":@(type),@"user_type":@(2)};
    [[HttpObject manager]postNoHudWithType:YuWaType_FRIENDS_INFO withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        YWMessageAddressBookModel * model = [YWMessageAddressBookModel yy_modelWithDictionary:responsObj[@"data"]];
        model.hxID = self.model.hxID;//无昵称时设为环信ID
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.header_img] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
        self.nameLabel.text = model.nikeName;
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
