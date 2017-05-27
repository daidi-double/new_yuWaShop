//
//  YWMessageAddressBookTableView.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/28.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWMessageAddressBookTableView.h"
#import "UIScrollView+JWGifRefresh.h"
#import "JWTools.h"
#import "HttpObject.h"

@implementation YWMessageAddressBookTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F8FA"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.keyArr = [NSMutableArray arrayWithCapacity:0];
    [self registerNib:[UINib nibWithNibName:MESSAGEADDRESSCELL bundle:nil] forCellReuseIdentifier:MESSAGEADDRESSCELL];
    [self registerNib:[UINib nibWithNibName:MESSAGEADDRESSHEADER bundle:nil] forHeaderFooterViewReuseIdentifier:MESSAGEADDRESSHEADER];
    self.dataSource = self;
    self.delegate = self;
    [self setupRefresh];
    [self headerRereshing];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?0.0001f:18.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0)return nil;
    YWMessageAddressBookHeader * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MESSAGEADDRESSHEADER];
    headerView.nameLabel.text = self.keyArr[section - 1];
    return headerView;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0?UITableViewCellEditingStyleNone:UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)return;
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        if (indexPath.row<[self.dataArr[indexPath.section - 1] count]) {
            UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSMutableArray * dataArr = self.dataArr[indexPath.section - 1];
                YWMessageAddressBookModel * model = dataArr[indexPath.row];
                [dataArr removeObjectAtIndex:indexPath.row];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    EMError *error = [[EMClient sharedClient].contactManager deleteContact:model.hxID];
                    if (!error)MyLog(@"删除%@成功",model.hxID);
                });
                
                if (dataArr.count > 0) {
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }else{
                    [self.keyArr removeObjectAtIndex:(indexPath.section - 1)];
                    [self.dataArr removeObjectAtIndex:(indexPath.section - 1)];
                    [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                }
            }];
            
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除好友?" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:cancelAction];
            [alertVC addAction:OKAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        self.friendsAddBlock();
        return;
    }
    
    YWMessageAddressBookModel * model = self.dataArr[indexPath.section - 1][indexPath.row];
    self.friendsChatBlock(model);
}

#pragma mark - UITableViewDataSource
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.keyArr;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSString *key = self.keyArr[index];
    if (key == title) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:(index + 1)] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        return NSNotFound;
    }
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?1:[self.dataArr[section - 1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWMessageAddressBookTableViewCell * messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGEADDRESSCELL];
    if (indexPath.section == 0) {
        messageCell.iconImageView.image = [UIImage imageNamed:@"message_friends_add"];
        messageCell.nameLabel.text = @"好友申请与通知";
        NSMutableArray * friendsRequest = [NSMutableArray arrayWithArray:[KUSERDEFAULT valueForKey:FRIENDSREQUEST]];
        if (!friendsRequest)friendsRequest = [NSMutableArray arrayWithCapacity:0];
        if (friendsRequest.count > 0) {
            NSInteger unRedCount = 0;
            for (NSDictionary * requestDic in friendsRequest) {
                if ([requestDic[@"status"] isEqualToString:@"0"])unRedCount++;
            }
            messageCell.countLabel.hidden = unRedCount > 0?NO:YES;
            messageCell.countLabel.text = [NSString stringWithFormat:@"%zi",friendsRequest.count];
        }
    }else{
        messageCell.model = self.dataArr[indexPath.section - 1][indexPath.row];
        messageCell.countLabel.hidden = YES;
    }
    
    return messageCell;
}
#pragma mark - TableView Refresh
- (void)setupRefresh{
    self.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
}
- (void)headerRereshing{
    [self requestShopArrData];
}


#pragma mark - Http
- (void)requestShopArrData{
    [self.dataArr removeAllObjects];
    [self.keyArr removeAllObjects];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.mj_header endRefreshing];
    });
    
    NSArray *userlist;
    EMError *error = nil;
    userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (error)userlist = [[EMClient sharedClient].contactManager getContacts];
    if (!userlist||userlist.count<=0) {
        [self reloadData];
        return;
    }
    
    NSMutableArray * sortArr = [NSMutableArray arrayWithCapacity:0];
                                  
    for (int i = 0; i < userlist.count; i++) {
        NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"other_username":userlist[i]};
        [[HttpObject manager]postNoHudWithType:YuWaType_FRIENDS_INFO withPragram:pragram success:^(id responsObj) {
            MyLog(@"Regieter Code pragram is %@",pragram);
            MyLog(@"Regieter Code is %@",responsObj);
            YWMessageAddressBookModel * model = [YWMessageAddressBookModel yy_modelWithDictionary:responsObj[@"data"]];
            model.hxID = userlist[i];//无昵称时设为环信ID
            [sortArr addObject:model];
            if (sortArr.count >= userlist.count) {
                if (userlist.count == 1) {
                    [self.dataArr addObject:@[model]];
                    [self.keyArr addObject:[JWTools stringWithFirstCharactor:[model.nikeName substringToIndex:1]]];
                    [self reloadData];
                }else{
                    [self sortedArry:sortArr];
                }
            }
        } failur:^(id responsObj, NSError *error) {
            MyLog(@"Regieter Code pragram is %@",pragram);
            MyLog(@"Regieter Code error is %@",responsObj);
            if (sortArr.count>0) {
                if (sortArr.count == 1) {
                    YWMessageAddressBookModel * model = sortArr[0];
                    [self.dataArr addObject:@[model]];
                    [self.keyArr addObject:[JWTools stringWithFirstCharactor:[model.nikeName substringToIndex:1]]];
                    [self reloadData];
                }else{
                    [self sortedArry:sortArr];
                }
            }
        }];
    }
}

- (void)sortedArry:(NSMutableArray *)sortArr{//排序好的数组、按照首字母排
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[sortArr sortedArrayUsingComparator:^NSComparisonResult(YWMessageAddressBookModel * _Nonnull obj1, YWMessageAddressBookModel * _Nonnull obj2) {
        if (NSOrderedDescending==[[JWTools stringWithFirstCharactor:obj1.nikeName] compare:[JWTools stringWithFirstCharactor:obj2.nikeName]]){
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (NSOrderedAscending==[[JWTools stringWithFirstCharactor:obj1.nikeName] compare:[JWTools stringWithFirstCharactor:obj2.nikeName]]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }]];
    
    __block NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [arr enumerateObjectsUsingBlock:^(YWMessageAddressBookModel *_Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray * arrTemp = dic[[JWTools stringWithFirstCharactor:[model.nikeName substringToIndex:1]]];
        if (!arrTemp)arrTemp = [NSMutableArray arrayWithCapacity:0];
        [arrTemp addObject:model];
        [dic setObject:arrTemp forKey:[JWTools stringWithFirstCharactor:[model.nikeName substringToIndex:1]]];
        
    }];//接口后,数组内模型的昵称进行排序
    self.keyArr = [NSMutableArray arrayWithArray:[[dic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    NSInteger sortCount = 0;
    while (([self.keyArr[0] integerValue]>0&&[self.keyArr[0] integerValue]<=9)||([self.keyArr[0] isEqualToString:@"0"])) {
        if (sortCount>=10) {
            break;
        }
        [self.keyArr addObject:self.keyArr[0]];
        [self.keyArr removeObjectAtIndex:0];
        sortCount++;
    }
    [self.keyArr enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArr addObject:dic[key]];
        if (idx+1 >= self.keyArr.count) {
            [self reloadData];
        }
    }];
}


@end
