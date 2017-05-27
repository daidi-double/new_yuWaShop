//
//  AddShopCategoryViewController.m
//  YuWaShop
//
//  Created by double on 17/4/26.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AddShopCategoryViewController.h"

@interface AddShopCategoryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *categoryNameTF;
@property (weak, nonatomic) IBOutlet UIButton *commitActionBtn;

@end

@implementation AddShopCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commitActionBtn.layer.cornerRadius = 5.f;
    self.commitActionBtn.layer.masksToBounds = YES;
    if (self.status == 1) {
        self.title = @"修改分类";
        self.categoryNameTF.text = self.categoryName;
    }else{
        self.title = @"添加分类";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (IBAction)commitAction:(UIButton *)sender {
    if (self.categoryNameTF.text == nil || [self.categoryNameTF.text isKindOfClass:[NSNull class]] || [self.categoryNameTF.text isEqualToString:@""]) {
        [JRToast showWithText:@"请输入分类名称" duration:1];
        return;
    }
    if (self.status == 1) {
        [self recomposeCategoryNameData];
    }else{
       [self addCategoryNameData];
    }
}
- (void)addCategoryNameData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shopr_ShopAdmin_AddCategory];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"cat_name":self.categoryNameTF.text};
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"data添加分类 %@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            [JRToast showWithText:data[@"data"] duration:1];
            WEAKSELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [JRToast showWithText:@"添加失败" duration:1];
        }
        
    }];
}
//修改分类
- (void)recomposeCategoryNameData{
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shopr_ShopAdmin_RecomposeCategory];
    NSDictionary * pragrams = @{@"user_id":@([UserSession instance].uid),@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"cat_name":self.categoryNameTF.text,@"cat_id":self.cat_id};
    HttpManager * manage = [[HttpManager alloc]init];
    [manage postDatasWithUrl:urlStr withParams:pragrams compliation:^(id data, NSError *error) {
        MyLog(@"data添加分类 %@",data);
        NSInteger number = [data[@"errorCode"] integerValue];
        if (number == 0) {
            [JRToast showWithText:data[@"data"] duration:1];
            WEAKSELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [JRToast showWithText:@"添加失败" duration:1];
        }
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
