//
//  RBNodeCollectionToAldumView.m
//  YuWa
//
//  Created by Tian Wei You on 16/10/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RBNodeCollectionToAldumView.h"
#import "HttpObject.h"
#import "JWTools.h"
#import "RBNodeAddToAldumTableViewCell.h"

#define ADDTOALDUMCELL @"RBNodeAddToAldumTableViewCell"
@implementation RBNodeCollectionToAldumView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.alphaBGView addGestureRecognizer:tap];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableBGView.layer.cornerRadius = 5.f;
    self.tableBGView.layer.masksToBounds = YES;
    [self.tableView registerNib:[UINib nibWithNibName:ADDTOALDUMCELL bundle:nil] forCellReuseIdentifier:ADDTOALDUMCELL];
}
- (void)tapAction{
    self.cancelBlock();
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.headView) {
        self.headView = [[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width - 72.f, 44.f)];
        self.headView.backgroundColor = [UIColor whiteColor];
        self.headView.textAlignment = NSTextAlignmentCenter;
        self.headView.text = @"收藏至我的专辑";
        self.headView.font = [UIFont systemFontOfSize:18.f];
    }
    return self.headView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.addToAlbumBlock(indexPath.row);
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RBNodeAddToAldumTableViewCell * addCell = [tableView dequeueReusableCellWithIdentifier:ADDTOALDUMCELL forIndexPath:indexPath];
    addCell.model = self.dataArr[indexPath.row];
    return addCell;
}
- (IBAction)addAldumBtnAction:(id)sender {
    self.newAlbumBlock();
}
#pragma mark - Http
- (void)aldumReload{
    
    if ([self.auser_type isKindOfClass:[NSNull class]] || [self.auser_type isEqualToString:@""] ||self.auser_type == nil) {
        self.auser_type = @"1";
    }
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"user_type":@([UserSession instance].isVIP==3?2:1),@"auser_type":self.auser_type};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_ALDUM withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        NSArray * dataArr = responsObj[@"data"];
        [UserSession instance].aldumCount = [NSString stringWithFormat:@"%zi",dataArr.count];
        if (dataArr.count>0) {
            self.dataArr = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i<dataArr.count; i++) {
                [self.dataArr addObject:[RBNodeAddToAldumModel yy_modelWithDictionary:dataArr[i]]];
            }
        }
        [self.tableView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
