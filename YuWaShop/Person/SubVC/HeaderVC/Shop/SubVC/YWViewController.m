//
//  YWViewController.m
//  雨掌柜
//
//  Created by double on 17/5/20.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWViewController.h"
#import "YWPCEOnTableViewCell.h"


#define PCEONCELL @"YWPCEOnTableViewCell"
@interface YWViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *chooseTabelView;

@end

@implementation YWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择权限";
    [self makeUI];
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWPCEOnTableViewCell * onCell = [tableView dequeueReusableCellWithIdentifier:PCEONCELL];
    
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
    titleLabel.text = @"选择权限";
    [bgView addSubview:titleLabel];
    
    return bgView;
    
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
