//
//  YWBankViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWBankViewController.h"
#import "YWBankTableViewCell.h"
#import "NSString+JWAppendOtherStr.h"
#import "AddBankViewController.h"
#import "PayManageViewController.h"
#define BANCKCELL @"YWBankTableViewCell"
@interface YWBankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * bankArr;
@property (nonatomic,strong)NSArray * colorArr;
@property (nonatomic,assign)NSInteger check;
@end

@implementation YWBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self dataSet];
    [self checkUserWhetherHavePassword];
//    [self requestData];
    self.view.backgroundColor = [UIColor whiteColor];
    self.colorArr = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"#fdc02a"],[UIColor colorWithHexString:@"#5cde9e"],[UIColor colorWithHexString:@"#56c3ee"],[UIColor colorWithHexString:@"#ff7575"], nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self requestData];
}
- (void)dataSet{
//    self.nameLabel.attributedText = [NSString stringWithFirstStr:@"如需要修改银行卡信息,请您联系" withFont:[UIFont systemFontOfSize:13.f] withColor:[UIColor blackColor] withSecondtStr:@"责任销售" withFont:[UIFont systemFontOfSize:13.f] withColor:CNaviColor];
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"三点"] style:UIBarButtonItemStylePlain target:self action:@selector(forgetPassword)];
    self.navigationItem.rightBarButtonItem = rightBtn;

    
    self.bankArr = [NSMutableArray arrayWithCapacity:0];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:BANCKCELL bundle:nil] forCellReuseIdentifier:BANCKCELL];
}

- (void)makeNavi{
    self.title = @"银行卡管理";

}
-(void)forgetPassword{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * payAction = [UIAlertAction actionWithTitle:@"支付管理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PayManageViewController * vc = [[PayManageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:payAction];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == self.bankArr.count) {

        return 44.f;
    }else{
        return 88.f;
    }
}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
////    if (indexPath.section != self.bankArr.count +1 ) {
////        
////        if (editingStyle ==UITableViewCellEditingStyleDelete){
////            UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////                YWBankModel * model = self.bankArr[indexPath.row];
////                [self requestDelBankWithID:model.bankID withIndexPath:indexPath];
////            }];
////            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
////            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除银行卡?" preferredStyle:UIAlertControllerStyleAlert];
////            [alertVC addAction:cancelAction];
////            [alertVC addAction:OKAction];
////            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
////        }
////    }
//}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.bankArr.count +1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    bgView.backgroundColor = [UIColor whiteColor];
    return bgView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.status == 1 && indexPath.section != self.bankArr.count) {
        YWBankModel * model = self.bankArr[indexPath.section];
          self.getBankCardBlock(model.bankName,model.bankCard,model.bankID,model.userName);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    if (indexPath.section == self.bankArr.count) {
        AddBankViewController * addVC = [[AddBankViewController alloc]init];
//        if (indexPath.section == self.bankArr.count) {
//            addVC.isPubAccount = NO;
//        }else{
//            addVC.isPubAccount = YES;
//        }
        addVC.check = self.check;
        [self.navigationController pushViewController:addVC animated:YES];
    }else{
        YWBankModel * model = self.bankArr[indexPath.section];
        NSInteger row = indexPath.section;
        if (row <self.bankArr.count) {
            SuccessViewController * successVC = [[SuccessViewController alloc]init];
            successVC.bankCard = model.bankCard;
            successVC.bankName = model.bankName;
            successVC.bankCategory = model.bankCategory;
            successVC.state = 1;
            successVC.bank_id = model.bankID;
            successVC.phoneNumber = model.phoneNumber;
            [self.navigationController pushViewController:successVC animated:YES];
        }
    }
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section != self.bankArr.count ) {
        
    YWBankTableViewCell * bankCell = [tableView dequeueReusableCellWithIdentifier:BANCKCELL];
    NSInteger a = indexPath.section % 4;
    
        bankCell.backgroundColor = self.colorArr[a];
        bankCell.layer.cornerRadius = 5;
        bankCell.layer.masksToBounds = YES;

    if (!bankCell) {
        bankCell = [[YWBankTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BANCKCELL];
    }
    
        if (self.bankArr.count>0) {
            NSInteger row = indexPath.section;
            if (row <self.bankArr.count) {
                YWBankModel * model = self.bankArr[indexPath.section];
                bankCell.bankModel = model;
            }
        }
    return bankCell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"addBankCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addBankCell"];
        }
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = YES;
        cell.backgroundColor = CNaviColor;
//        13788855888 123123
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * addBankLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0,cell.width, cell.height)];
        if (indexPath.section == self.bankArr.count) {
            addBankLabel.text = @"+ 添加银行卡 ";
        }
        addBankLabel.font = [UIFont systemFontOfSize:14];
        addBankLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:addBankLabel];
    
        return cell;
    }
}

#pragma mark - Http
- (void)requestData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_MyBankList];
    NSDictionary * pragram = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_type":@(2)};
    
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];

        [manager POST:urlStr parameters:pragram success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            MyLog(@"responseObject = %@",responseObject);
            [self.bankArr removeAllObjects];
            for (NSDictionary*dict in responseObject[@"data"]) {
//                YWBankModel*model=[YWBankModel yy_modelWithDictionary:dict];
                YWBankModel * model = [YWBankModel bankModelWithDic:dict];
                [self.bankArr addObject:model];
                
            }
            [self.tableView reloadData];

        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            MyLog(@"%@",error);
//            NSInteger number = [data[@"errorCode"] integerValue];
//            if (number == 9) {
//                YWLoginViewController * vc = [[YWLoginViewController alloc]init];
//
            //            }
        }];
    

}

//检测是否存在支付密码
- (void)checkUserWhetherHavePassword{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_CHICKWHETHERHAVEPASSWORD];
    NSDictionary * pragrams = @{@"device_id":[JWTools getUUID],@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"user_type":@(2)};
    HttpManager * manager = [[HttpManager alloc]init];
    
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        // 0 存在密码  1 不存在密码
        MyLog(@"data = %@",data);
        NSInteger number = [data[@"errorCode"] integerValue] ;
        
        self.check = number;
    }];
}

//- (void)requestDelBankWithID:(NSString *)bankID withIndexPath:(NSIndexPath *)indexPath{
//    //h3333333333删除银行卡
//    [self.bankArr removeObjectAtIndex:indexPath.row];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//}

@end
