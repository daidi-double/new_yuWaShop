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

#define CHILDCELL @"ChildAccountTableViewCell"
@interface ChildAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *accountTableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic,strong)NSString * name;

@end

@implementation ChildAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"管理门店账号";
    [self makeUI];

}

- (void)makeUI{
    [self.accountTableView registerNib:[UINib nibWithNibName:CHILDCELL bundle:nil] forCellReuseIdentifier:CHILDCELL];
    self.accountTableView.separatorStyle = NO;
    self.addBtn.layer.cornerRadius = 5;
    self.addBtn.layer.masksToBounds = YES;
    self.name = @"所有门店";
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
