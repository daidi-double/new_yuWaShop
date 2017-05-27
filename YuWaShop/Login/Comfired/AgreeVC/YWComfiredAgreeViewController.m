//
//  YWComfiredAgreeViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWComfiredAgreeViewController.h"

@interface YWComfiredAgreeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (nonatomic,assign)NSInteger faild;

@end

@implementation YWComfiredAgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
}
- (void)makeNavi{
    self.title = @"协议";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"同意" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside withWidth:60.f];
}

- (void)makeUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.agreeBtn.layer.cornerRadius =  5.f;
    self.agreeBtn.layer.masksToBounds = YES;
//    if ([UserSession instance].agreement) {
        self.textView.text = [UserSession instance].agreement;
        [self.textView setContentOffset:CGPointMake(0.f, 0.f)];
//    }else{
        [self requestAgreeData];
//    }
}

- (IBAction)agreeBtnAction:(id)sender {
    [self agreeAction];
}

- (void)agreeAction{
    if (self.staus == 1) {
        
        self.agreeBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Http
- (void)requestAgreeData{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid)};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_GetShopAgreement withPragram:pragram success:^(id responsObj) {
//        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        self.textView.text = responsObj[@"data"]?responsObj[@"data"]:@"";
        if (![self.textView.text isEqualToString:@""])[UserSession instance].agreement = self.textView.text;
        [self.textView setContentOffset:CGPointMake(0.f, 0.f)];
    } failur:^(id responsObj, NSError *error) {
//        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        self.faild++;
        if (self.faild<3)[self requestAgreeData];
    }];
    
//    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_GetShopAgreement withPragram:nil success:^(id responsObj) {
//        MyLog(@"Regieter Code is %@",responsObj);
//        self.textView.text = responsObj[@"data"]?responsObj[@"data"]:@"";
//        if (![self.textView.text isEqualToString:@""])[UserSession instance].agreement = self.textView.text;
//        [self.textView setContentOffset:CGPointMake(0.f, 0.f)];
//    } failur:^(id responsObj, NSError *error) {
//        MyLog(@"Regieter Code error is %@",responsObj);
//        self.faild++;
//        if (self.faild<3)[self requestAgreeData];
//    }];

}

@end
