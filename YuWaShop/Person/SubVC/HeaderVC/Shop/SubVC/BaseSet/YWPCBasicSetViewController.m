//
//  YWPCBasicSetViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/24.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPCBasicSetViewController.h"
#import "YWPersonShopModel.h"
#import "JWTextView.h"

@interface YWPCBasicSetViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopIconBtn;
@property (weak, nonatomic) IBOutlet JWTextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *subPhoneTextField;

@property (nonatomic,strong)UIImage * cameraImage;
@property (nonatomic,copy)NSString * cameraImageURL;
@property (nonatomic,strong)YWPersonShopModel * model;

@end

@implementation YWPCBasicSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店的基本信息";
    self.model = [YWPersonShopModel sharePersonShop];
    [self makeUI];
}

- (void)makeUI{
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5.f;
    self.textView.layer.masksToBounds = YES;
    self.textView.placeholder = @"显示简介";
    self.textView.placeholderColor = [UIColor colorWithHexString:@"#d3d3d3"];
    if (![[UserSession instance].personality isEqualToString:@"尚未设置门店简介哟"]) {
        self.textView.isDrawPlaceholder = NO;
        self.textView.text = [UserSession instance].personality;
    }
    
    if (![JWTools isPhoneIDWithStr:[UserSession instance].nickName]) self.nameTextField.text = [UserSession instance].nickName;
    
    [self.shopIconBtn sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Person_Shop_Add_Img"] completed:nil];
    if (self.model.headerModel.company_address)self.addressTextField.text = self.model.headerModel.company_address;
    if (self.model.headerModel.company_first_tel)self.firstPhoneTextField.text = self.model.headerModel.company_first_tel;
    if (self.model.headerModel.company_second_tel&&![self.model.headerModel.company_second_tel isEqualToString:self.model.headerModel.company_first_tel])self.subPhoneTextField.text = self.model.headerModel.company_second_tel;
}

- (IBAction)submitBtnAction:(id)sender {
    [self requestChangeIcon];
}
- (IBAction)shopIconBtnAction:(id)sender {
    [self makeLocalImagePicker];
}

- (void)makeLocalImagePicker{
    WEAKSELF;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [weakSelf myImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
        } else {
            MyLog(@"照片源不可用");
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf myImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)myImagePickerWithType:(UIImagePickerControllerSourceType)sourceType{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        [picker setSourceType:sourceType];
        [picker setAllowsEditing:YES];
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        MyLog(@"照片源不可用");
    }
}

#pragma mark - ImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.cameraImage = info[@"UIImagePickerControllerEditedImage"];
    [self.shopIconBtn setImage:self.cameraImage forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Http
- (void)requestChangeIcon{
    if ([self.nameTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"门店名称不能为空哟" withSuccess:NO];
        return;
    }else if ([self.textView.text isEqualToString:@""]) {
        [self showHUDWithStr:@"门店简介不能为空哟" withSuccess:NO];
        return;
    }else if ([self.addressTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"门店地址不能为空哟" withSuccess:NO];
        return;
    }else if ([self.firstPhoneTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"首选电话不能为空哟" withSuccess:NO];
        return;
    }else if (![JWTools isPhoneIDWithStr:self.firstPhoneTextField.text]) {
        [self showHUDWithStr:@"请输入正确电话哟" withSuccess:NO];
        return;
    }else if (![self.subPhoneTextField.text isEqualToString:@""]&&![JWTools isPhoneIDWithStr:self.subPhoneTextField.text]){
        [self showHUDWithStr:@"请输入次要正确电话哟" withSuccess:NO];
        return;
    }
    
    if (self.cameraImage) {
        NSDictionary * pragram = @{@"img":@"img"};
        
        [[HttpObject manager]postPhotoWithType:YuWaType_IMG_UP withPragram:pragram success:^(id responsObj) {
            MyLog(@"Regieter Code pragram is %@",pragram);
            MyLog(@"Regieter Code is %@",responsObj);
            self.cameraImageURL = responsObj[@"data"];
            if (!self.cameraImageURL)self.cameraImageURL= [UserSession instance].logo;
            [self requestUpLoadShopInfo];
        } failur:^(id errorData, NSError *error) {
            MyLog(@"Regieter Code pragram is %@",pragram);
            MyLog(@"Regieter Code error is %@",error);
        } withPhoto:UIImagePNGRepresentation(self.cameraImage)];
    }else{
        if ([[UserSession instance].logo isEqualToString:@""]) {
            [self showHUDWithStr:@"请选择门店头像" withSuccess:NO];
            return;
        }
        self.cameraImageURL = [UserSession instance].logo;
        [self requestUpLoadShopInfo];
    }
}

- (void)requestUpLoadShopInfo{
    NSMutableDictionary * pragram = [NSMutableDictionary dictionaryWithDictionary:@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"company_img":self.cameraImageURL,@"company_name":self.nameTextField.text,@"company_address":self.addressTextField.text,@"company_first_tel":self.firstPhoneTextField.text,@"company_mark":self.textView.text}];
    if (![self.subPhoneTextField.text isEqualToString:@""]&&self.subPhoneTextField.text)[pragram setObject:self.subPhoneTextField.text forKey:@"company_second_tel"];
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_SetBaseInfo withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self showHUDWithStr:@"恭喜,修改成功" withSuccess:YES];
        [UserSession instance].logo = self.cameraImageURL;
        [UserSession instance].nickName = self.nameTextField.text;
        [UserSession instance].personality = self.textView.text;
        ;
        self.model.headerModel.company_address = self.addressTextField.text;
        self.model.headerModel.company_first_tel = self.firstPhoneTextField.text;
        self.model.headerModel.company_second_tel = self.subPhoneTextField.text;
        self.model.headerModel.company_name = self.nameTextField.text;
        self.model.headerModel.company_img = self.cameraImageURL;
        
        NSMutableArray * shopArr = [NSMutableArray arrayWithArray:self.model.dataArr[1]];
        [shopArr replaceObjectAtIndex:0 withObject:self.nameTextField.text];
        [self.model.dataArr replaceObjectAtIndex:1 withObject:shopArr];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        [self showHUDWithStr:@"设置门店信息失败" withSuccess:NO];
    }];
}

@end
