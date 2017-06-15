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
#import "MainAccountListModel.h"
#import "HttpObject.h"
#import "MBProgressHUD.h"
#import "JPUSHService.h"
#import "VIPTabBarController.h"
#import "YWLoginViewController.h"

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
    [self requesstAccountList];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requesstAccountList];
}
- (void)makeUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.quitBtn.layer.cornerRadius = 5;
    self.quitBtn.layer.masksToBounds = YES;
    [self.accountTableView registerNib:[UINib nibWithNibName:CHILDSHOPCELL bundle:nil] forCellReuseIdentifier:CHILDSHOPCELL];
}
- (IBAction)quiteAction:(UIButton *)sender {
    //退出账号
    [UserSession clearUser];
   YWLoginViewController* vc = [[YWLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.accountAry.count>0) {
        for (MainAccountListModel * model in self.accountAry) {
            if ([model.is_current integerValue] == 1) {
                
                if ([model.isChild integerValue] == 0) {
                    return 1;
                }else{
                    return 2;
                }
            }
        }
    }
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
    return 56;
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
    self.accountTableView.separatorStyle = NO;
    if (indexPath.section == 0) {
        //需要判断当前账号，不是的需要隐藏右边的图案
        ChildAccountShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHILDSHOPCELL];
        
        if (indexPath.row == self.accountAry.count) {
            cell.accountNameLabel.hidden = YES;
            cell.managerLabel.hidden = YES;
            cell.addImageView.hidden = NO;
            cell.addLabel.hidden = NO;
        }else{
            MainAccountListModel * model = self.accountAry[indexPath.row];
            cell.model = model;
            cell.accountNameLabel.hidden = NO;
            cell.managerLabel.hidden = NO;
            cell.addImageView.hidden = YES;
            cell.addLabel.hidden = YES;
            if ([model.is_current integerValue] == 1) {
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;//打钩标记
            }
        }
        
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
            MainAccountListModel * model = self.accountAry[indexPath.row];
            if ([model.is_current integerValue] != 1) {
                
                [self changeAccount:model.id];
            }
        }
    }else{
        //修改当前账户信息
        AmendCurrentAccountViewController * vc = [[AmendCurrentAccountViewController alloc]init];
        for (MainAccountListModel * model in self.accountAry) {
            if ([model.is_current integerValue] == 1) {
                vc.model = model;
            }
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row != self.accountAry.count) {

    if (editingStyle ==UITableViewCellEditingStyleDelete){
        
        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            MainAccountListModel * model = self.accountAry[indexPath.row];
            [self requestDelChildAccountData:model andIndexpath:indexPath];
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认解除账号关联?" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
        
    }
}

- (void)requesstAccountList{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_MAINACCOUNTLIST];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID]};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"参数%@ ~~~~ %@",pragrams,urlStr);
        MyLog(@"主账号关联列表%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.accountAry removeAllObjects];
            for (NSDictionary * dict in data[@"data"]) {
                MainAccountListModel * model = [MainAccountListModel yy_modelWithDictionary:dict];
                
                [self.accountAry addObject:model];
            }
            
        }
        [self.accountTableView reloadData];
    }];
}
//解除关联
- (void)requestDelChildAccountData:(MainAccountListModel*)model andIndexpath:(NSIndexPath*)indexpath{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_DELMAINACCOUNT];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"relieve_id":model.id};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",pragarms);
        MyLog(@"删除子账号%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.accountAry removeObjectAtIndex:indexpath.row];
            [JRToast showWithText:data[@"errorMessage"] duration:2];
            
        }else if ([data[@"errorCode"] integerValue] == 9){
            [JRToast showWithText:@"您的身份已过期,请重新登入" duration:1.5];
            YWLoginViewController * vc = [[YWLoginViewController alloc]init];
            WEAKSELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController pushViewController:vc animated:YES];
            });
        }else{
            [JRToast showWithText:data[@"errorMessage"] duration:2];
        }
        [self.accountTableView reloadData];
        
    }];
    
}
//切换账号
- (void)changeAccount:(NSString *)uid{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_CHANGEACCOUNT];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"rela_id":@([uid integerValue])};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"参数%@ ~~ %@",pragrams,urlStr);
        MyLog(@"切换账号%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self loginAccount:data[@"data"][@"username"] andPassword:data[@"data"][@"password"]];
        }
    }];
}

- (void)loginAccount:(NSString*)account andPassword:(NSString *)password{
    NSDictionary * pragram = @{@"phone":account,@"password":password,@"is_md5":@(1)};
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[HttpObject manager]postNoHudWithType:YuWaType_Logion withPragram:pragram success:^(id responsObj) {
            MyLog(@"Pragram is %@",pragram);
            MyLog(@"Data is %@",responsObj);
            [UserSession saveUserLoginWithAccount:account withPassword:password];
            [UserSession saveUserInfoWithDic:responsObj[@"data"]];
            [self showHUDWithStr:@"登录成功" withSuccess:YES];
            EMError *errorLog = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"2%@",account] password:[UserSession instance].hxPassword];
            if (!errorLog){
                [[EMClient sharedClient].options setIsAutoLogin:NO];
                MyLog(@"环信登录成功");
            }else{
                EMError *error = [[EMClient sharedClient] registerWithUsername:[NSString stringWithFormat:@"2%@",account] password:account];
                if (error==nil) {
                    MyLog(@"环信注册成功");
                    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
                    if (!isAutoLogin) {
                        EMError *errorLog = [[EMClient sharedClient] loginWithUsername:[NSString stringWithFormat:@"2%@",account] password:[NSString stringWithFormat:@"2%@",account]];
                        if (errorLog==nil){
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                            MyLog(@"环信登录成功");
                        }
                    }
                }
            }
            
            if ([UserSession instance].comfired_Status == 2||[UserSession instance].isVIP == 3){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JPUSHService setAlias:[UserSession instance].account callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
                    rootTabBarVC.selectedIndex = 0;
                    rootTabBarVC.hidesBottomBarWhenPushed = NO;
                    
                });
            }
        } failur:^(id responsObj, NSError *error) {
            NSInteger number = [responsObj[@"errorCode"] integerValue];
            if ( number == 1) {
                [JRToast showWithText:@"账号或密码错误" duration:2];
            }
            MyLog(@"Pragram is %@",pragram);
            MyLog(@"Data Error error is %@",responsObj);
            MyLog(@"Error is %@",error);
        }];
    });

}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSLog(@"起别名 :      rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (void)showHUDWithStr:(NSString *)showHud withSuccess:(BOOL)isSuccess{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = showHud;
    if (isSuccess) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    }
    hud.alpha = 0.6;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:0.8];
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
