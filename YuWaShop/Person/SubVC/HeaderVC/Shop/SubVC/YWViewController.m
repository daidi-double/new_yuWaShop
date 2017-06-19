//
//  YWViewController.m
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWViewController.h"
#import "YWPCEOnTableViewCell.h"
#import "LimitModel.h"



#define PCEONCELL @"YWPCEOnTableViewCell"
@interface YWViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *chooseTabelView;
@property (nonatomic,strong)NSMutableArray * dataAry;
@property (nonatomic,strong)NSMutableArray * bigAry;
@property (nonatomic,strong)NSMutableArray * titleAry;
@property (nonatomic,strong)NSMutableArray * backAry;//返回数据
@end

@implementation YWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择权限";
    [self makeUI];
    
    [self requestChildAccountLimitData];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.backAry removeAllObjects];
}
-(void)makeUI{
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(subcommitActions:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.chooseTabelView registerNib:[UINib nibWithNibName:PCEONCELL bundle:nil] forCellReuseIdentifier:PCEONCELL];
}

- (void)subcommitActions:(UIBarButtonItem*)sender{
    if (self.backAry.count <=0) {
        [JRToast showWithText:@"最少选择一个权限" duration:1];
        return;
    }
    if (self.limitBlock) {
        self.limitBlock(self.backAry);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.bigAry.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.bigAry[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWPCEOnTableViewCell * onCell = [tableView dequeueReusableCellWithIdentifier:PCEONCELL];
    if (self.status == 1) {
        LimitChildModel * limitModel = self.bigAry[indexPath.section][indexPath.row];
        
        onCell.nameLabel.text = limitModel.name;
        WEAKSELF;
        //遍历查询是否有开启的权限，开的权限给予开启
        for (NSDictionary * dict in self.childModel.route) {
            LimitChildModel * limitModels = [LimitChildModel yy_modelWithDictionary:dict];
            if ([limitModels.enable integerValue] == 1) {
                
                if ([limitModels.name isEqualToString:limitModel.name]) {
                    onCell.isChoosed = 1;
                    [self.backAry addObject:limitModels];//把已开启的权限放返回数组中，待修改替换即将要开启的权限
                }
            }
        }
        
        onCell.chooseBlock = ^(BOOL isChoosed){
            LimitChildModel * nameModel = weakSelf.bigAry[indexPath.section][indexPath.row];
            if (isChoosed == 1) {
                //开启新权限时，判断已有的数组中是否存在该权限，没有的话就加入到返回数组中，有的情况下不加入
                NSMutableArray * newLimitAry = [NSMutableArray array];
                __block typeof(newLimitAry)weaknewLimitAry = newLimitAry;
                [weakSelf.backAry enumerateObjectsUsingBlock:^(LimitChildModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![obj.name isEqualToString:nameModel.name]) {
                        
                        [weaknewLimitAry addObject:nameModel];
                        *stop = YES;
                    }
                }];
                [self.backAry addObjectsFromArray:newLimitAry];
            }else{
                //移除所选的权限，权限关闭时需要移除
                [weakSelf.backAry enumerateObjectsUsingBlock:^(LimitChildModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.name isEqualToString:nameModel.name]) {
                        
                        *stop = YES;
                        [weakSelf.backAry removeObjectAtIndex:idx];
                    }
                }];
            }
        };
        
        
    }else{
        
        LimitChildModel * limitModel = self.bigAry[indexPath.section][indexPath.row];
        
        onCell.nameLabel.text = limitModel.name;
        WEAKSELF;
        onCell.chooseBlock = ^(BOOL isChoosed){
            LimitChildModel * nameModel = weakSelf.bigAry[indexPath.section][indexPath.row];
            if (isChoosed == 1) {
                //开启的情况加入到返回数组中
                if (weakSelf.backAry.count<=0) {
                    [weakSelf.backAry addObject:nameModel];
                }else{
                    for (LimitChildModel * model in weakSelf.backAry) {
                        if (![model.name isEqualToString:nameModel.name]) {
                            MyLog(@"名称3  %@",model.name);
                            [weakSelf.backAry addObject:nameModel];
                        }
                    }
                }
            }else{
                //移除所选的权限 ,关闭的时候移除
                [weakSelf.backAry enumerateObjectsUsingBlock:^(LimitChildModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.name isEqualToString:nameModel.name]) {
                        *stop = YES;
                        [weakSelf.backAry removeObjectAtIndex:idx];
                    }
                }];
            }
        };
        
    }
    return onCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 25)];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, kScreen_Width *0.5, 25)];
    titleLabel.textColor = RGBCOLOR(90, 91, 92, 1);
    titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:titleLabel];
    LimitModel * model = self.titleAry[section];
    
    titleLabel.text = model.cat;
    
    return bgView;
    
}
- (void)requestChildAccountLimitData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_PRESON_CHOOSECHILDACCOUNTLIMIT];
    NSDictionary * pragarms = @{@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID]};
    HttpManager * manager = [[HttpManager alloc]init];
    [manager getDatasWithUrl:urlStr withParams:pragarms compliation:^(id data, NSError *error) {
        MyLog(@"参数%@~%@",pragarms,urlStr);
        MyLog(@"子账号权限%@",data);
        if ([data[@"errorCode"] integerValue] == 0) {
            [self.bigAry removeAllObjects];
            [self.titleAry removeAllObjects];
            NSArray * diAry = data[@"data"];
            for (int a = 0; a < diAry.count; a++) {
                [self.dataAry removeAllObjects];
                NSDictionary * dict = diAry[a];
                
                LimitModel * limitModel = [LimitModel yy_modelWithDictionary:dict];
                [self.titleAry addObject:limitModel];
                for (int i = 0; i < limitModel.name.count; i++) {
                    NSDictionary * dataDic = limitModel.name[i];
                    LimitChildModel * childModel = [LimitChildModel yy_modelWithDictionary:dataDic];
                    [self.dataAry addObject:childModel];
                }
                NSMutableArray * ary = [NSMutableArray array];
                [ary addObjectsFromArray:self.dataAry];
                [self.bigAry addObject:ary];
            }
        }
        [self.chooseTabelView reloadData];
    }];
    
}
- (NSMutableArray*)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (NSMutableArray*)bigAry{
    if (!_bigAry) {
        _bigAry = [NSMutableArray array];
    }
    return _bigAry;
}
- (NSMutableArray*)backAry{
    if (!_backAry) {
        _backAry = [NSMutableArray array];
    }
    return _backAry;
}
- (NSMutableArray*)titleAry{
    if (!_titleAry) {
        _titleAry = [NSMutableArray array];
    }
    return _titleAry;
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
