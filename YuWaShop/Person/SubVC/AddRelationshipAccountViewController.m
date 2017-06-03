//
//  AddRelationshipAccountViewController.m
//  雨掌柜
//
//  Created by double on 17/6/3.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AddRelationshipAccountViewController.h"

@interface AddRelationshipAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextFild;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextFild;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation AddRelationshipAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加关联账号";
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.layer.masksToBounds = YES;
    
}
- (IBAction)accountAction:(UITextField *)sender {
    [sender becomeFirstResponder];
}
- (IBAction)passwordAction:(UITextField *)sender {
    [sender becomeFirstResponder];
    
}
//保存
- (IBAction)submitBtnAction:(UIButton *)sender {
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
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
