//
//  YWNodeAddAldumViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/10/9.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWNodeAddAldumViewController.h"

#import "YWNodeAddAldumTitleTableViewCell.h"
#import "YWNodeAddAldumShowTableViewCell.h"

#define ALDUM_SHOW_CELL @"YWNodeAddAldumShowTableViewCell"
#define ALDUM_TITTLE_CELL @"YWNodeAddAldumTitleTableViewCell"
@interface YWNodeAddAldumViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign)BOOL isPublic;//YES为公开NO为只己见
@property (nonatomic,copy)NSString * aldumTitle;
@property (nonatomic,copy)NSString * aldumIntro;

@end

@implementation YWNodeAddAldumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self dataSet];
}

- (void)makeNavi{
    self.title = @"新建专辑";
    self.navigationItem.rightBarButtonItem =[UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"确认" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(addAldumAction) forControlEvents:UIControlEventTouchUpInside withWidth:40.f];
}
- (void)dataSet{
    self.isPublic = YES;
    [self.tableView registerNib:[UINib nibWithNibName:ALDUM_TITTLE_CELL bundle:nil] forCellReuseIdentifier:ALDUM_TITTLE_CELL];
    [self.tableView registerNib:[UINib nibWithNibName:ALDUM_SHOW_CELL bundle:nil] forCellReuseIdentifier:ALDUM_SHOW_CELL];
}

- (void)addAldumAction{
    [self requestAddAldum];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0?130.f:44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YWNodeAddAldumTitleTableViewCell * tittleCell = [tableView dequeueReusableCellWithIdentifier:ALDUM_TITTLE_CELL];
        tittleCell.nameTextField.delegate = self;
        tittleCell.introTextView.delegate = self;
        [tittleCell.nameTextField becomeFirstResponder];
        return tittleCell;
    }
    
    YWNodeAddAldumShowTableViewCell * showCell = [tableView dequeueReusableCellWithIdentifier:ALDUM_SHOW_CELL];
    showCell.showPublicBlock = ^(BOOL isPublic){
        self.isPublic = !isPublic;
    };
    return showCell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.aldumTitle = textField.text;
    });
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.aldumIntro = textView.text;
    });
    return YES;
}

#pragma mark - Http
- (void)requestAddAldum{
    if (!self.aldumTitle||[self.aldumTitle isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入标题" withSuccess:NO];
        return;
    }
    if (!self.aldumIntro)self.aldumIntro = @"";
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"title":self.aldumTitle,@"info":self.aldumIntro,@"is_hidden":@(self.isPublic),@"user_type":@([UserSession instance].isVIP==3?2:1)};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_CREATE_ALDUM withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [UserSession instance].aldumCount = [NSString stringWithFormat:@"%zi",[UserSession instance].aldumCount?([[UserSession instance].aldumCount integerValue]+1):1];
        [self.navigationController popViewControllerAnimated:YES];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];    
}

@end
