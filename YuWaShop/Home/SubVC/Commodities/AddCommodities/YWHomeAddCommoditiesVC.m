//
//  YWHomeAddCommoditiesVC.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWHomeAddCommoditiesVC.h"
#import "YWHomeCommoditiesModel.h"
@interface YWHomeAddCommoditiesVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *introTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UITextField *discountPriceTextField;
@property(nonatomic,strong)MBProgressHUD*HUD;
@property (nonatomic,copy)NSString * cameraImageStr;

@end

@implementation YWHomeAddCommoditiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加商品信息";

    [self makeUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)makeUI{
    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
    if (self.staues == 1) {
        self.title = @"修改商品信息";
        YWHomeCommoditiesModel * commoditiesModel = self.shopDataArr[self.row];

        self.nameTextField.text = commoditiesModel.goods_name;
        self.introTextField.text = commoditiesModel.goods_info;
        self.priceTextField.text = commoditiesModel.goods_price;
        self.discountPriceTextField.text = commoditiesModel.goods_disprice;
        [self.shopImage sd_setImageWithURL:[NSURL URLWithString:commoditiesModel.goods_img]];
        [self.submitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    }
}

- (IBAction)submitBtnAction:(id)sender {
    if (self.staues == 0) {
        
        [self requestChangeIcon];
    }else if (self.staues == 1){
        UIAlertAction * OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestChangeIcon];//修改接口
        }];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认修改此商品?" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:OKAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
- (NSString*)getShopId{
    YWHomeCommoditiesModel * commoditiesModel = self.shopDataArr[self.row];
        
        return commoditiesModel.commoditiesID;
}
- (IBAction)imageBtnAction:(id)sender {
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
    
    self.shopImage.image = info[@"UIImagePickerControllerEditedImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Http
- (void)requestChangeIcon{
    if ([self.nameTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入商品名称哟~" withSuccess:NO];
        return;
    }else if ([self.introTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入商品介绍哟~" withSuccess:NO];
        return;
    }else if ([self.priceTextField.text isEqualToString:@""]||[self.priceTextField.text floatValue]<=0.f) {
        self.priceTextField.text = @"";
        [self showHUDWithStr:@"请输入正确的商品价格哟~" withSuccess:NO];
        return;
    }else if ([self.discountPriceTextField.text isEqualToString:@""]||[self.discountPriceTextField.text floatValue]<=0.f) {
        self.priceTextField.text = @"";
        [self showHUDWithStr:@"请输入正确的商品价格哟~" withSuccess:NO];
        return;
    }
    
    if (!self.shopImage.image) {
        [self showHUDWithStr:@"请添加商品相片哟~" withSuccess:NO];
        return;
    }
    [self.HUD show:YES];
    self.priceTextField.text = [NSString stringWithFormat:@"%.2f",[self.priceTextField.text floatValue]];
    self.discountPriceTextField.text = [NSString stringWithFormat:@"%.2f",[self.discountPriceTextField.text floatValue]];
    
    NSDictionary * pragram = @{@"img":@"img"};
    
    [[HttpObject manager]postPhotoWithType:YuWaType_IMG_UP withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        self.cameraImageStr = responsObj[@"data"];
        if (!self.cameraImageStr)self.cameraImageStr=@"";
        if (self.staues == 0) {
            
            [self requestUpData];;
        }else{
            [self changShopInfo];
        }
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",error);
    } withPhoto:UIImagePNGRepresentation(self.shopImage.image)];
    
}
- (void)requestUpData{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"goods_name":self.nameTextField.text,@"goods_info":self.introTextField.text,@"goods_price":@([self.priceTextField.text floatValue]),@"goods_disprice":self.discountPriceTextField.text,@"goods_img":self.cameraImageStr,@"goods_cat_id":self.catID};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_AddGoods withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [self.HUD hide:YES];
        [self showHUDWithStr:@"恭喜!添加成功" withSuccess:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });

    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
         [self.HUD hide:YES];
    }];
}
- (void)changShopInfo{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"goods_name":self.nameTextField.text,@"goods_info":self.introTextField.text,@"goods_price":@([self.priceTextField.text floatValue]),@"goods_img":self.cameraImageStr,@"goods_id":[self getShopId],@"goods_disprice":self.discountPriceTextField.text};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_changGoods withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
         [self.HUD hide:YES];
        [self showHUDWithStr:@"恭喜!修改成功" withSuccess:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
         [self.HUD hide:YES];
        
    }];

}

-(MBProgressHUD *)HUD{
    if (!_HUD) {
        _HUD=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        _HUD.delegate=self;
        _HUD.userInteractionEnabled=NO;
        //        _HUD.mode=MBProgressHUDModeAnnularDeterminate;
        _HUD.dimBackground=NO;
        _HUD.labelText = @"请稍等";
        _HUD.removeFromSuperViewOnHide = YES;
    }
    return _HUD;
}

@end
