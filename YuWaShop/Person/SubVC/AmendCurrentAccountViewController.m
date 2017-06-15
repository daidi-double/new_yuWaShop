//
//  AmendCurrentAccountViewController.m
//  雨掌柜
//
//  Created by double on 17/6/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AmendCurrentAccountViewController.h"
#import "AmendAccountTableViewCell.h"
#import "AmendInfoViewController.h"


#define AMENDCELL @"AmendAccountTableViewCell"
@interface AmendCurrentAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *accountInfoTableView;

@end

@implementation AmendCurrentAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改当前账号信息";
    [self.accountInfoTableView registerNib:[UINib nibWithNibName:AMENDCELL bundle:nil] forCellReuseIdentifier:AMENDCELL];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"amendAccountCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"amendAccountCell"];
    }
    if (indexPath.row != 0) {
        AmendAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AMENDCELL];
        NSArray * nameAry = @[@"账号",@"密码",@"手机号"];
        cell.nameLabel.text = nameAry[indexPath.row-1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row ==1) {
            
            cell.contenLabel.text = self.model.username;
        }else if (indexPath.row==2){
            cell.contenLabel.text = @"******";
        }else if (indexPath.row==3){
            cell.contenLabel.text = [NSString stringWithFormat:@"(+86)%@",self.model.phone];//修改
        }
        return cell;
    }else{
        cell.selectionStyle = NO;
        cell.textLabel.text = self.model.company_name;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AmendInfoViewController * vc = [[AmendInfoViewController alloc]init];
    if (indexPath.row == 1) {
        vc.status = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        vc.status= 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        if ([self.model.phone isEqualToString:@""]) {
            vc.status = 3;
        }else{
            vc.status = 2;
            vc.iphone = self.model.phone;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
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
