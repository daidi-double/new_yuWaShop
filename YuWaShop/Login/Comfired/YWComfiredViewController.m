//
//  YWComfiredViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/22.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWComfiredViewController.h"
#import "YWLoginViewController.h"
#import "YWComfiredAgreeViewController.h"
#import "JWTagsCollectionView.h"
#import "YWStormSortTableView.h"
#import "YWStormSubSortCollectionView.h"
#import "YWAddressSortTableView.h"
#import "YWAddressSubSortCollectionView.h"
#import "YWComfiringViewController.h"
#import "JPUSHService.h"
#import "VIPTabBarController.h"

#import <CoreLocation/CoreLocation.h>

@interface YWComfiredViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,MBProgressHUDDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)MBProgressHUD*HUD;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *upImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *upUserImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *upUsersImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *upUserOtherImageBtn;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (nonatomic,assign)BOOL isAgree;
@property (nonatomic,strong)UIImage * cameraImage;
@property (nonatomic,copy)NSString * cameraImageURL;
@property (nonatomic,strong)UIImage * cameraUserImage;
@property (nonatomic,copy)NSString * cameraUserImageURL;
@property (nonatomic,strong)UIImage * cameraUsersImage;
@property (nonatomic,copy)NSString * cameraUsersImageURL;
@property (nonatomic,strong)UIImage * cameraUserOtherImage;
@property (nonatomic,copy)NSString * cameraUserOtherImageURL;
@property (nonatomic,strong) UIImageView * explainView;
@property (weak, nonatomic) IBOutlet UIProgressView *progress1;
@property (nonatomic,assign) int count;
@property (nonatomic,assign) int upImageCount;
@property (nonatomic,strong) UIView* zhezhao;

@property (weak, nonatomic) IBOutlet UIView *chooseTagBGView;

@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (nonatomic,strong)YWStormSortTableView * sortTableView;
@property (nonatomic,strong)YWStormSubSortCollectionView * sortSubCollectionView;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSMutableArray * tagIDArr;
@property (nonatomic,copy)NSString * allTagID;
@property (nonatomic,strong)JWTagsCollectionView * tagCollectionView;

@property (nonatomic,strong)YWAddressSortTableView * sortAddressTableView;
@property (nonatomic,strong)YWAddressSubSortCollectionView * sortAddressSubCollectionView;
@property (nonatomic,assign)NSInteger addressType;
@property (nonatomic,assign)NSInteger addressSubType;
@property (nonatomic,copy)NSString * addressName;
@property (nonatomic,copy)NSString * addressSubName;
@property (nonatomic,assign)NSInteger cameraStatus;
@property (nonatomic,strong)CLGeocoder * geocoder;
@property (nonatomic,copy)NSString * latitudeStr;
@property (nonatomic,copy)NSString * longitudeStr;

@end

@implementation YWComfiredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self makeNavi];
    [self makeUI];
    UIView * view = [[UIView alloc]initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.3;
    view.hidden = YES;
    [self.view addSubview:view];
    self.progress1.hidden = YES;
    self.zhezhao = view;
}
-(void)progress2{
    if (self.count != 4) {
        self.count= self.count + 1;
        self.progress1.progress+=0.22;
    }else if (self.upImageCount == 4){
        self.progress1.progress+=0.22;
        self.count++;
    }else if (self.count == 5){
        self.progress1.hidden = YES;
        self.zhezhao.hidden = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.HUD hide:YES];
}

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

- (void)makeNavi{
    self.title = @"店铺签约";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImageName:@"NaviBack" withSelectImage:@"NaviBack" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside withWidth:30.f];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"退出登录" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(outLogion) forControlEvents:UIControlEventTouchUpInside withWidth:66.f];
    self.type = 1;
}

- (void)backAction{
    [self.navigationController popToRootViewControllerAnimated:NO];
    VIPTabBarController * rootTabBarVC = (VIPTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    rootTabBarVC.selectedIndex = 0;
    rootTabBarVC.hidesBottomBarWhenPushed = NO;
}

- (void)outLogion{
    [UserSession clearUser];
    YWLoginViewController * vc = [[YWLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)makeUI{
    self.isAgree = YES;

    self.submitBtn.layer.cornerRadius = 5.f;
    self.submitBtn.layer.masksToBounds = YES;
    
    [self addLineWithUI:self.idTextField];
    [self addLineWithUI:self.nameTextField];
    [self addLineWithUI:self.addressTextField];
    [self addLineWithUI:self.addressLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAddressAction)];
    [self.addressLabel addGestureRecognizer:tap];
    
    self.tagIDArr = [NSMutableArray arrayWithCapacity:0];
    self.allTagID = @"24";
    [self makeSortView];
    [self makeAddressSortView];
}

- (void)makeSortView{
    WEAKSELF;
    UICollectionViewFlowLayout * collectionFlow = [[UICollectionViewFlowLayout alloc]init];
    collectionFlow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sortSubCollectionView = [[YWStormSubSortCollectionView alloc]initWithFrame:CGRectMake(kScreen_Width/3, NavigationHeight, kScreen_Width * 2/3, kScreen_Height - 64.f) collectionViewLayout:collectionFlow];
    [self.sortSubCollectionView dataSet];
    
    self.sortTableView = [[YWStormSortTableView alloc]initWithFrame:CGRectMake(0.f, NavigationHeight, kScreen_Width/3, self.sortSubCollectionView.height) style:UITableViewStylePlain];
    self.sortTableView.choosedTypeBlock = ^(NSInteger type,NSInteger subType,NSArray * subArr,NSString * allTypeID){
        weakSelf.type = type+1;
        weakSelf.allTagID = allTypeID;
        weakSelf.sortSubCollectionView.allTypeIdx = type;
        weakSelf.sortSubCollectionView.dataArr = subArr;
    };
    self.sortTableView.hidden = YES;
    self.sortSubCollectionView.hidden = self.sortTableView.hidden;
    [self.view addSubview:self.sortTableView];
    [self.view addSubview:self.sortSubCollectionView];
}

- (void)makeAddressSortView{
    WEAKSELF;
    UICollectionViewFlowLayout * collectionAddressFlow = [[UICollectionViewFlowLayout alloc]init];
    collectionAddressFlow.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sortAddressSubCollectionView = [[YWAddressSubSortCollectionView alloc]initWithFrame:CGRectMake(kScreen_Width/3, NavigationHeight, kScreen_Width * 2/3, kScreen_Height - 64.f) collectionViewLayout:collectionAddressFlow];
    self.sortAddressSubCollectionView.choosedTypeBlock = ^(NSString * placeNmae,NSInteger subType){
        weakSelf.addressSubType = subType;
        weakSelf.sortAddressTableView.hidden = YES;
        weakSelf.sortAddressSubCollectionView.hidden = weakSelf.sortAddressTableView.hidden;
        weakSelf.addressSubName = placeNmae;
        weakSelf.addressLabel.textColor = [UIColor blackColor];
        weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@/%@",weakSelf.addressName,placeNmae];
    };
    [self.sortAddressSubCollectionView dataSet];
    
    self.sortAddressTableView = [[YWAddressSortTableView alloc]initAddressWithFrame:CGRectMake(0.f, NavigationHeight, kScreen_Width/3, self.sortAddressSubCollectionView.height) style:UITableViewStylePlain];
    self.sortAddressTableView.choosedTypeBlock = ^(NSInteger type,NSString * name,NSArray * subArr){
        weakSelf.addressType = type;
        weakSelf.sortAddressSubCollectionView.allTypeIdx = type;
        weakSelf.sortAddressSubCollectionView.dataArr = subArr;
        weakSelf.addressName = name;
    };
    self.sortAddressTableView.hidden = YES;
    self.sortAddressSubCollectionView.hidden = self.sortAddressTableView.hidden;
    [self.view addSubview:self.sortAddressTableView];
    [self.view addSubview:self.sortAddressSubCollectionView];
}

- (void)addLineWithUI:(UIView *)sender{
    sender.layer.borderWidth = 1.f;
    sender.layer.borderColor = [UIColor colorWithHexString:@"#D6D6D6"].CGColor;
    sender.layer.cornerRadius = 5.f;
    sender.layer.masksToBounds = YES;
}

- (MBProgressHUD *)HUD{
    if (!_HUD) {
        _HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        _HUD.delegate = self;
        _HUD.userInteractionEnabled = NO;
        _HUD.dimBackground = NO;
        _HUD.removeFromSuperViewOnHide = YES;
    }
    return _HUD;
}

#pragma mark - Button Action
- (IBAction)submitBtnAction:(UIButton*)sender {
    if ([self isCanCommit]) {
        self.zhezhao.hidden = NO;
        self.progress1.hidden = NO;
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(progress2) userInfo:nil repeats:YES];
        [self requestComfired];
        sender.userInteractionEnabled = NO;
    }
}
- (IBAction)upImageBtnAction:(UIButton *)sender {
    self.cameraStatus = 0;
    [self makeLocalImagePicker];
}
- (IBAction)upUserImageBtnAction:(id)sender {
    self.cameraStatus = 1;
    [self makeLocalImagePicker];
}
- (IBAction)upUsersImageBtnAction:(id)sender {
    self.cameraStatus = 2;
    [self makeLocalImagePicker];
}
- (IBAction)upUserOtherImageBtnAction:(UIButton *)sender {
    self.cameraStatus = 3;
    [self makeLocalImagePicker];
}

- (IBAction)agreeBtnAction:(UIButton *)sender {
    self.isAgree = !self.isAgree;

    [sender setImage:[UIImage imageNamed:self.isAgree?@"photo_sel_photoPickerVc":@"photo_def_previewVc"] forState:UIControlStateNormal];
}
- (IBAction)seeAgreeBtnAction:(id)sender {
    YWComfiredAgreeViewController * vc = [[YWComfiredAgreeViewController alloc]init];
    vc.agreeBlock = ^(){
        self.isAgree = YES;
        [self.agreeBtn setImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)chooseTagBtn:(id)sender {
    self.sortTableView.hidden = NO;
    self.sortSubCollectionView.hidden = self.sortTableView.hidden;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:nil withSelectImage:nil withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTittle:@"完成" withTittleColor:[UIColor whiteColor] withTarget:self action:@selector(tagChoosedFinish) forControlEvents:UIControlEventTouchUpInside withWidth:33.f];
}

- (void)tagChoosedFinish{
    NSMutableArray * tagArr = [NSMutableArray arrayWithCapacity:0];
    [self.tagIDArr removeAllObjects];
    for (YWComfiredTypeModel * model in self.sortSubCollectionView.choosedTypeArr) {
        [tagArr addObject:model.tag_name];
        [self.tagIDArr addObject:model.typeID];
    }
    if (self.tagIDArr.count > 2) {
        [JRToast showWithText:@"最多只能选择两个分类,请重新选择" duration:1];
        
    }else{

        self.navigationItem.rightBarButtonItem = nil;
        self.sortTableView.hidden = YES;
        self.sortSubCollectionView.hidden = self.sortTableView.hidden;
    [self makeTagCollectionViewWithArr:tagArr];
}
}

- (void)chooseAddressAction{
    self.sortAddressTableView.hidden = NO;
    self.sortAddressSubCollectionView.hidden = self.sortAddressTableView.hidden;
}
- (IBAction)explain:(UIButton *)sender {

    [self setExplainImageView];
    self.navigationController.navigationBarHidden = YES;
 
}
- (void)setExplainImageView{
    _explainView = [[UIImageView alloc]initWithFrame:self.view.frame];
    _explainView.image = [UIImage imageNamed:@"explaintext.jpg"];
    _explainView.userInteractionEnabled = YES;
    [self.view addSubview:_explainView];
    
    UITapGestureRecognizer * removeExplain = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeExplain:)];
    removeExplain.numberOfTapsRequired = 1;
    removeExplain.numberOfTouchesRequired = 1;
    removeExplain.delegate = self;
    
    [_explainView addGestureRecognizer:removeExplain];
    
    UIImageView * back = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 20, 30)];
    back.image = [UIImage imageNamed:@"img_navi_back"];
    back.userInteractionEnabled = YES;
    [_explainView addSubview:back];
    
}

- (void)removeExplain:(UITapGestureRecognizer*)tap{
    self.navigationController.navigationBarHidden = NO;
    [tap.view removeFromSuperview];
    
}
- (void)makeTagCollectionViewWithArr:(NSArray *)tagArr{
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    if (!self.tagCollectionView) {
        self.tagCollectionView = [[JWTagsCollectionView alloc]initWithFrame:CGRectMake(0.f, 5.f, kScreen_Width-90.f, 30.f) collectionViewLayout:flowLayout];
        [self.chooseTagBGView addSubview:self.tagCollectionView];
    }
    self.tagCollectionView.tagArr = tagArr;
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
    if (self.cameraStatus == 0) {
        self.cameraImage = info[@"UIImagePickerControllerEditedImage"];
        [self.upImageBtn setImage:nil forState:UIControlStateNormal];
        [self.upImageBtn setTitle:@"" forState:UIControlStateNormal];
        [self.upImageBtn setBackgroundImage:self.cameraImage forState:UIControlStateNormal];
    }else if (self.cameraStatus == 1){
        self.cameraUserImage = info[@"UIImagePickerControllerEditedImage"];
        [self.upUserImageBtn setImage:nil forState:UIControlStateNormal];
        [self.upUserImageBtn setTitle:@"" forState:UIControlStateNormal];
        [self.upUserImageBtn setBackgroundImage:self.cameraUserImage forState:UIControlStateNormal];
    }else if (self.cameraStatus == 2){
        self.cameraUsersImage = info[@"UIImagePickerControllerEditedImage"];
        [self.upUsersImageBtn setImage:nil forState:UIControlStateNormal];
        [self.upUsersImageBtn setTitle:@"" forState:UIControlStateNormal];
        [self.upUsersImageBtn setBackgroundImage:self.cameraUsersImage forState:UIControlStateNormal];
    }else{
        self.cameraUserOtherImage = info[@"UIImagePickerControllerEditedImage"];
        [self.upUserOtherImageBtn setImage:nil forState:UIControlStateNormal];
        [self.upUserOtherImageBtn setTitle:@"" forState:UIControlStateNormal];
        [self.upUserOtherImageBtn setBackgroundImage:self.cameraUserOtherImage forState:UIControlStateNormal];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Http
- (void)requestChangeIconWithType:(NSInteger)type{
    NSDictionary * pragram = @{@"img":@"img"};
    UIImage * camera;
    if (type == 0) {
        camera = self.cameraImage;
    }else if (type == 1){
        camera = self.cameraUserImage;
    }else if (type == 2){
        camera = self.cameraUsersImage;
    }else{
        camera = self.cameraUserOtherImage;
    }

    [[HttpObject manager]postPhotoWithType:YuWaType_IMG_UP_NOHUD withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        self.upImageCount ++;
        if (type == 0) {
            self.cameraImageURL = responsObj[@"data"];
            if (!self.cameraImageURL)self.cameraImageURL=@"";
        }else if (type == 1){
            self.cameraUserImageURL = responsObj[@"data"];
            if (!self.cameraUserImageURL)self.cameraUserImageURL=@"";
        }else if (type == 2){
            self.cameraUsersImageURL = responsObj[@"data"];
            if (!self.cameraUsersImageURL)self.cameraUsersImageURL=@"";
        }else{
            self.cameraUserOtherImageURL = responsObj[@"data"];
            if (!self.cameraUserOtherImageURL)self.cameraUserOtherImageURL = @"";
        }
        if (self.cameraImageURL&&self.cameraUserImageURL&&self.cameraUsersImageURL&&self.cameraUserOtherImageURL){
            [self requestUpComfired];
            
        }
        
        
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",error);
        [self.HUD hide:YES];
    } withPhoto:UIImagePNGRepresentation(camera)];
}
- (BOOL)isCanCommit{
    if ([self.idTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入授权码" withSuccess:NO];
        return NO;
    }else if ([self.nameTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入店铺名称" withSuccess:NO];
        return NO;;
    }else if ([self.addressTextField.text isEqualToString:@""]) {
        [self showHUDWithStr:@"请输入店铺地址" withSuccess:NO];
        return NO;;
    }else if (self.tagIDArr.count<=0) {
        [self showHUDWithStr:@"请选择所属分类" withSuccess:NO];
        return NO;;
    }else if ([self.addressLabel.text isEqualToString:@"店铺商区"]) {
        [self showHUDWithStr:@"请选择商区" withSuccess:NO];
        return NO;;
    }else if (self.tagIDArr.count<=0) {
        [self showHUDWithStr:@"请选择店铺分类" withSuccess:NO];
        return NO;;
    }else if (!self.cameraImage) {
        [self showHUDWithStr:@"请上传营业执照" withSuccess:NO];
        return NO;;
    }else if (!self.cameraUserImage) {
        [self showHUDWithStr:@"请上传身份证正面照" withSuccess:NO];
        return NO;;
    }else if (!self.cameraUsersImage) {
        [self showHUDWithStr:@"请上传身份证反面照" withSuccess:NO];
        return NO;;
    }else if (!self.isAgree){
        [self showHUDWithStr:@"请阅读协议并同意" withSuccess:NO];
        return NO;;
    }else if (!self.cameraUserOtherImage){
        [self showHUDWithStr:@"请上传相关行业许可证" withSuccess:NO];
        return NO;;
    }else if (self.isAgree !=1){
        [self showHUDWithStr:@"请同意协议" withSuccess:NO];
        return NO;;
    }else{
        return YES;
    }
}
- (void)requestComfired{

    
    [self.geocoder geocodeAddressString:self.addressTextField.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * pl = [placemarks firstObject];
        if(!error){
            self.latitudeStr = @(pl.location.coordinate.latitude).stringValue;
            self.longitudeStr = @(pl.location.coordinate.longitude).stringValue;
            [self requestChangeIconWithType:0];
            [self requestChangeIconWithType:1];
            [self requestChangeIconWithType:2];
            [self requestChangeIconWithType:3];
//            [JRToast showWithText:@"可能需要点时间,请稍等" duration:3];
            
        }else{
            [self showHUDWithStr:@"地址有误,请重试" withSuccess:NO];
        }
    }];
}

- (void)requestUpComfired{
    NSString * subTagIDStr = self.allTagID;
    for (int i = 0; i<self.tagIDArr.count; i++) {
        subTagIDStr = [NSString stringWithFormat:@"%@,%@",subTagIDStr,self.tagIDArr[i]];
    }
    
    // 还需要添加其他证件的参数上传；
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"invite_code":self.idTextField.text,@"business_licence":self.cameraImageURL,@"id_card":self.cameraUserImageURL,@"id_card_back":self.cameraUsersImageURL,@"company_name":self.nameTextField.text,@"company_address":self.addressTextField.text,@"cid":@(self.type),@"tag_id":subTagIDStr,@"coordinatey":self.latitudeStr,@"coordinatex":self.longitudeStr,@"company_near":@(self.addressSubType),@"company_first_tel":[UserSession instance].mobile};
    
    [[HttpObject manager]postDataWithType:YuWaType_Shoper_ShopAdmin_AddCheckStatus withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        YWComfiringViewController * vc = [[YWComfiringViewController alloc]init];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JPUSHService setAlias:[UserSession instance].account callbackSelector:nil object:nil];
            [UserSession instance].comfired_Status = 1;
            [self.navigationController pushViewController:vc animated:YES];
        });
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
        if ([responsObj[@"errorMessage"]isEqualToString:@"已经提交审核，请耐心等待"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.HUD hide:YES];
                YWComfiringViewController * vc = [[YWComfiringViewController alloc]init];
                [JPUSHService setAlias:[UserSession instance].account callbackSelector:nil object:nil];
                [self.navigationController pushViewController:vc animated:YES];
            });
        }else{
            [self showHUDWithStr:responsObj[@"errorMessage"]?responsObj[@"errorMessage"]:@"提交失败,请重试" withSuccess:NO];
        }
    }];
}


@end
