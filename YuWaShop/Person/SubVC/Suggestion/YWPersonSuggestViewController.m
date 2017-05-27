//
//  YWPersonSuggestViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonSuggestViewController.h"
#import "YWPersonSuggRePlayViewController.h"

@interface YWPersonSuggestViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet JWTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation YWPersonSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.textView becomeFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)makeNavi{
    self.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"查看意见反馈" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(toSeePlayAction) forControlEvents:UIControlEventTouchUpInside withWidth:98.f];
}

- (void)makeUI{
    self.textView.placeholderColor = [UIColor colorWithHexString:@"#b3b3b3"];
    self.textView.placeholder = @"请输入您宝贵的建议(最少5字)";
    
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#b3b3b3"].CGColor;
    self.textView.layer.borderWidth = 1.5f;
    self.textView.layer.cornerRadius = 5.f;
    self.textView.layer.masksToBounds = YES;
    
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
}

- (IBAction)submitBtnAction:(id)sender {
    [self requestSendSuggestion];
}
- (void)toSeePlayAction{
    YWPersonSuggRePlayViewController * vc = [[YWPersonSuggRePlayViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestSendSuggestion];
        });
    }
    return YES;
}

#pragma mark - Http
- (void)requestSendSuggestion{
    if ([self.textView.text isEqualToString:@""]) {
        [self showHUDWithStr:@"建议不能为空哟~" withSuccess:NO];
        return;
    }else if (self.textView.text.length < 5){
        [self showHUDWithStr:@"字数不够呐" withSuccess:NO];
        return;
    }
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"customer_content":self.textView.text};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_ReplySuggest withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self showHUDWithStr:@"感谢您的建议" withSuccess:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView resignFirstResponder];
            self.textView.text = @"";
            self.textView.isDrawPlaceholder = YES;
            self.textView.placeholder = @"请输入您宝贵的建议(最少5字)";
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
