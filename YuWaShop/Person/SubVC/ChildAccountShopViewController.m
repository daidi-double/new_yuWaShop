//
//  ChildAccountShopViewController.m
//  雨掌柜
//
//  Created by double on 17/6/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChildAccountShopViewController.h"
#import "ChildAccountShopTableViewCell.h"
#import "AddRelationshipAccountViewController.h"//添加关联账号
#import "AmendCurrentAccountViewController.h"//修改账号信息

#define CHILDSHOPCELL  @"ChildAccountShopTableViewCell"
@interface ChildAccountShopViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *accountTableView;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (nonatomic,strong)NSMutableArray * accountAry;//账号数据
@end

@implementation ChildAccountShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的账号";
    [self makeUI];
}

- (void)makeUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.quitBtn.layer.cornerRadius = 5;
    self.quitBtn.layer.masksToBounds = YES;
    [self.accountTableView registerNib:[UINib nibWithNibName:CHILDSHOPCELL bundle:nil] forCellReuseIdentifier:CHILDSHOPCELL];
}
- (IBAction)quiteAction:(UIButton *)sender {
    //退出账号
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        
        return self.accountAry.count+1;//修改
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 20.f;
    }
    return 30.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1||(indexPath.section == 0&&indexPath.row == self.accountAry.count)) {
        return 40;
    }
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 30)];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#e9eeef"];
        UILabel * str = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreen_Width-30, 30)];
        str.text = @"已关联账号，可用于快速切换";
        str.textColor = [UIColor colorWithHexString:@"#999999"];
        str.font = [UIFont systemFontOfSize:10];
        [bgView addSubview:str];
        return bgView;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    //需要判断当前账号，不是的需要隐藏右边的图案
    ChildAccountShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHILDSHOPCELL];
    if ((self.accountAry.count== 0&&indexPath.section==0)||(indexPath.section==0&&indexPath.row == self.accountAry.count)) {
        cell.accountNameLabel.hidden = YES;
        cell.isCurrentAccountLabel.hidden = YES;
        cell.managerLabel.hidden = YES;
        cell.addImageView.hidden = NO;
        cell.addLabel.hidden = NO;
    }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;//打钩标记
        return cell;
    }else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"shopAccountCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shopAccountCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"修改当前账户信息";
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == self.accountAry.count) {
            AddRelationshipAccountViewController * vc = [[AddRelationshipAccountViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //切换关联账号，调用接口
            
        }
    }else{
        //修改当前账户信息
        AmendCurrentAccountViewController * vc = [[AmendCurrentAccountViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
- (NSMutableArray*)accountAry{
    if (!_accountAry) {
        _accountAry = [NSMutableArray array];
    }
    return _accountAry;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
