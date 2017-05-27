//
//  GetMoneyToBankViewController.m
//  YuWa
//
//  Created by double on 17/3/29.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "GetMoneyToBankViewController.h"
#import "GetMoneyToBankModel.h"
@interface GetMoneyToBankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UILabel *getMoneyStatus;//提现进度（状态）
@property (weak, nonatomic) IBOutlet UITableView *detailTablleView;
@property (nonatomic,strong)NSMutableArray * dataAry;
@property (nonatomic,strong)NSMutableArray * titleAry;
@property (nonatomic,assign)NSInteger status;
@end

@implementation GetMoneyToBankViewController

- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (NSMutableArray *)titleAry{
    if (!_titleAry) {
        _titleAry = [NSMutableArray array];
    }
    return _titleAry;
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self requestData];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.title =  @"提现详情";
    // Do any additional setup after loading the view from its nib.
}
- (void)makeUI{
    self.completeBtn.layer.masksToBounds = YES;
    self.completeBtn.layer.cornerRadius = 6;
    NSArray * title = @[@"预计到账时间",@"储蓄卡",@"提现金额",@"手续费",@""];
    [self.titleAry addObjectsFromArray:title];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"getMoneyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"getMoneyCell"];
    }
    
    cell.textLabel.text = self.titleAry[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = RGBCOLOR(160, 161, 161, 1);
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = RGBCOLOR(160, 161, 161, 1);

    if (indexPath.row == 1) {
        NSString * card = [self.bankCard substringFromIndex:self.bankCard.length - 4];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ 尾号%@",self.bankName,card];
    
    }else if(indexPath.row == 2){
    cell.detailTextLabel.text = self.money;
    }else  if(indexPath.row == 3){
      cell.detailTextLabel.text = @"1%";
    }else if(indexPath.row == 0){
        cell.detailTextLabel.text = @"工商银行账户24小时内到账,其他银行48小时内到账";
        cell.detailTextLabel.numberOfLines = 2;
        cell.detailTextLabel.textAlignment = 0;
    }else{
        cell.textLabel.text = @"";
    }
  
    
    
    return cell;
}
- (IBAction)completeAction:(UIButton *)sender {
    if (self.status == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        });

    }else{
        [JRToast showWithText:@"网络繁忙,请稍后再试" duration:1];
    }
}
- (void)requestData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_GETMYTOBANK];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"user_type":@(2),@"token":[UserSession instance].token, @"user_card_id":self.user_card_id,@"money":self.money};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            MyLog(@"data = %@",data);
        self.getMoneyStatus.text = data[@"msg"];
            
           
            [self.detailTablleView reloadData];

        }else{
            [JRToast showWithText:data[@"errorMessage"]duration:1];
        }
    }];
    
}
//-(void)sureGetMoney{
//    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SUREGETMYMONEY];
//    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"user_type":@(2),@"token":[UserSession instance].token,@"user_card_id":self.user_card_id,@"money":self.money};
//    HttpManager * manager = [[HttpManager alloc]init];
//    [manager postDatasNoHudWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
//        MyLog(@"data = %@",data);
//        NSInteger number = [data[@"errorCode"] integerValue];
//        self.status = number;
//        if (number == 0) {
//            [JRToast showWithText:data[@"msg"] duration:1];
//            
//            
//        }else{
//            [JRToast showWithText:data[@"errorMessage"]duration:1];
//            
//        }
//    }];
//
//}
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
