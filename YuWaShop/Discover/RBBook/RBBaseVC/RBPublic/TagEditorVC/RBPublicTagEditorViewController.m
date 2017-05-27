//
//  RBPublicTagEditorViewController.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RBPublicTagEditorViewController.h"
#import "JWEditTextField.h"
#import "JWTagCollectionView.h"
#import "RBPublishSession.h"

@interface RBPublicTagEditorViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet JWEditTextField *nameTextField;
@property (weak, nonatomic) IBOutlet JWEditTextField *priceTextField;
@property (weak, nonatomic) IBOutlet JWEditTextField *placeTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic,strong)JWTagCollectionView * tagCollectionView;
@property (nonatomic,assign)NSInteger states;

@end

@implementation RBPublicTagEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)makeUI{
    [self layerSetWithSender:self.nameLabel];
    [self layerSetWithSender:self.priceLabel];
    [self layerSetWithSender:self.placeLabel];
    [self layerSetWithSender:self.nameTextField];
    [self layerSetWithSender:self.priceTextField];
    [self layerSetWithSender:self.placeTextField];
    
    self.submitBtn.layer.cornerRadius = 18.f;
    self.submitBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 18.f;
    self.cancelBtn.layer.masksToBounds = YES;
    
    [self makeTagCollectionViewWithArr:@[@"美食",@"电影",@"酒店",@"周边游",@"休闲娱乐",@"生活服务",@"旅游",@"宴会",@"时尚购",@"丽人",@"运动健身",@"母婴亲子",@"宠物",@"汽车服务",@"摄影写真",@"结婚",@"购物",@"家装",@"学习培训",@"医疗"]];
}

- (void)layerSetWithSender:(UIView *)sender{
    sender.layer.borderWidth = 1.3f;
    sender.layer.borderColor = [UIColor whiteColor].CGColor;
    sender.layer.cornerRadius = 18.f;
    sender.layer.masksToBounds = YES;
}

- (IBAction)submitBtnAction:(id)sender {
    if ([self canSend])[self sendTags];
}
- (IBAction)cancelbtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)makeTagCollectionViewWithArr:(NSArray *)tagArr{
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.tagCollectionView = [[JWTagCollectionView alloc]initWithFrame:CGRectMake(35.f, 372.f, kScreen_Width - 70.f, 44.f) collectionViewLayout:flowLayout];
    self.tagCollectionView.tagArr = tagArr;
    self.tagCollectionView.tagChoosed = YES;
    self.tagCollectionView.changeTagBlock = ^(NSString * chooseTag){//选中标签后操作
        [RBPublishSession sharePublishSession].status = [chooseTag integerValue] + 1;
        MyLog(@"选择了%@个标签",chooseTag);
    };
    [self.view addSubview:self.tagCollectionView];
}

- (BOOL)canSend{
//    if ([self.placeTextField.text isEqualToString:@""]&&[self.priceTextField.text isEqualToString:@""]&&[self.nameTextField.text isEqualToString:@""]){
//        [self showHUDWithStr:@"请输入内容" withSuccess:NO];
//        return NO;
//    }
    return YES;
}

- (void)sendTags{
    NSMutableArray * tagsArr = [NSMutableArray arrayWithCapacity:0];
    if (![self.nameTextField.text isEqualToString:@""])[tagsArr addObject:self.nameTextField.text];
    if (![self.priceTextField.text isEqualToString:@""])[tagsArr addObject:self.priceTextField.text];
    if (![self.placeTextField.text isEqualToString:@""])[tagsArr addObject:self.placeTextField.text];
    self.tagAddBlock(tagsArr);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self canSend]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendTags];
        });
        return YES;
    }else{
        return NO;
    }
}


@end
