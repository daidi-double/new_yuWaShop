//
//  ChildAccountViewController.m
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "ChildAccountViewController.h"
#import "ChildAccountTableViewCell.h"
#import "AddChildAccounViewController.h"
#import "MyChildAccountViewController.h"
#import "ChildModel.h"


#define CHILDCELL @"ChildAccountTableViewCell"
@interface ChildAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *accountTableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,strong)NSString * name;
@property (nonatomic,strong)NSMutableArray * dataAry;

@end

@implementation ChildAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理门店账号";
    [self makeUI];
    [self requestChildAccountData];
}

- (void)makeUI{
    [self.accountTableView registerNib:[UINib nibWithNibName:CHILDCELL bundle:nil] forCellReuseIdentifier:CHILDCELL];
    self.accountTableView.separatorStyle = NO;
    self.addBtn.layer.cornerRadius = 5;
    self.addBtn.layer.masksToBounds = YES;
    self.name = @"所有门店";
    UIBarButtonItem * editBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(touchAction:)];
    
    self.navigationItem.rightBarButtonItem = editBtn;
    
}

- (void)touchAction:(UIBarButtonItem*)sender{
    self.accountTableView.editing = !self.accountTableView.editing;
    if (self.accountTableView.editing == YES) {
        [sender setTitle:@"完成"];
        
    }else{
        [sender setTitle:@"编辑"];
        
    }
}
- (IBAction)addAccountAction:(UIButton *)sender {
    AddChildAccounViewController * vc = [[AddChildAccounViewController alloc]init];
    vc.status = 0;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChildAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CHILDCELL];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 35)];
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, kScreen_Width*0.8f, 35)];
        titleLabel.textColor = RGBCOLOR(89, 90, 91, 1);
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        titleLabel.text = self.name;

        [bgView addSubview:titleLabel];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myAllAccount)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap.delegate = self;
        [bgView addGestureRecognizer:tap];
        
        UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Width - 23, 0, 8, 15)];
        rightImageView.centerY = bgView.centerY;
        rightImageView.image = [UIImage imageNamed:@"右箭头"];
        [bgView addSubview:rightImageView];
        
        return bgView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 35.f;
    }
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddChildAccounViewController * vc = [[AddChildAccounViewController alloc]init];
    vc.status = 1;
    [self.navigationController pushViewController:vc animated:YES];

    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete){

        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ChildModel * model = self.dataAry[indexPath.row];
            [self requestDelChildAccountData:model];//修改
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除该子账号?" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

//我的所有门店
- (void)myAllAccount{
    MyChildAccountViewController * vc = [[MyChildAccountViewController alloc]init];
    WEAKSELF;
    vc.nameBlock= ^(NSString * name){
        weakSelf.name = name;
        [weakSelf.accountTableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];

}

//请求数据
- (void)requestChildAccountData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_MYCHILDACCOUNT];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID]};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",pragarms);
        MyLog(@"子账号列表%@",data);
        
    }];
    
}
- (void)requestDelChildAccountData:(ChildModel*)model{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_DELCHILDACCTOUNT];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID],@"account_id":model.id};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager postDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@",pragarms);
        MyLog(@"删除子账号%@",data);
        
    }];
    
}
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
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
