//
//  YWPersonSettingViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonSettingViewController.h"
#import "YWBasicTableViewCell.h"
#import "JWThirdTools.h"
#import "YWLoginViewController.h"
#import "YWForgetPassWordViewController.h"
#import "YWPersonNoticaficationViewController.h"
#import "YWPersonAboutUsViewController.h"

@interface YWPersonSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * nameArr;

@end

@implementation YWPersonSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self dataSet];
}

- (void)dataSet{
    NSArray*path=  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    self.nameArr = [NSMutableArray arrayWithArray:@[@"通知设置",[NSString stringWithFormat:@"清除缓存(%.2fMB)",[JWThirdTools folderSizeAtPath:path[0]]],@"更改密码",@"退出登录",@"关于我们"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"YWBasicTableViewCell" bundle:nil] forCellReuseIdentifier:@"YWBasicTableViewCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWBasicTableViewCell * settingCell = [tableView dequeueReusableCellWithIdentifier:@"YWBasicTableViewCell"];
    settingCell.nameLabel.text = self.nameArr[indexPath.row];
    
    return settingCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
        [JWThirdTools clearCache:paths[0]];
        [self showHUDWithStr:@"清除缓存成功" withSuccess:YES];
        [self.nameArr replaceObjectAtIndex:1 withObject:@"清除缓存(0MB)"];
        [self.tableView reloadData];
        return;
    }
    
    UIViewController * vc;
    switch (indexPath.row) {
        case 0:{
            vc = [[YWPersonNoticaficationViewController alloc]init];
            break;
        }
        case 2:{
            vc = [[YWForgetPassWordViewController alloc]init];
            break;
        }
        case 3:{
            [UserSession clearUser];
            vc = [[YWLoginViewController alloc]init];
            break;
        }
        case 4:{
            vc = [[YWPersonAboutUsViewController alloc]init];
            break;
        }
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}




@end
