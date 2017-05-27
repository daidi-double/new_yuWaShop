//
//  YWPersonViewController.m
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/17.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWPersonViewController.h"
#import "YWPersonTableViewCell.h"
#import "YWPersonHeaderView.h"
#import "YWPersonVC.h"
#import "YWBusinessMemberViewController.h"   //商务会员
#import "YWMyContactViewController.h"      //我的笔记

#define PERSONCCELL @"YWPersonTableViewCell"

@interface YWPersonViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)YWPersonHeaderView * headerView;
@property (nonatomic,strong)NSArray * countArr;
@property (nonatomic,strong)NSArray * subViewArr;
@property (nonatomic,strong)NSMutableArray * showArr;
@property (nonatomic,strong)UIImage * cameraImage;
@property (nonatomic,copy)NSString * cameraImageURL;

@end

@implementation YWPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeNavi];
    [self makeUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [UserSession userToComfired];
            [self dataSet];
     [self refreshUI];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0.f];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.f];
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
}

- (void)makeNavi{
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:@"Person_13" withSelectImage:@"Person_13" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside withSize:CGSizeMake(30.f, 30.f)];
}
- (void)makeUI{
    WEAKSELF;
    self.headerView = [[[NSBundle mainBundle]loadNibNamed:@"YWPersonHeaderView" owner:nil options:nil]firstObject];
    self.headerView.chooseBtnBlock = ^(NSInteger choosedBtn){//1门店2会员3分红
        UIViewController * vc;
        switch (choosedBtn) {
            case 1:{
                vc = [[YWPersonShopViewController alloc]init];
                 [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{
                 //2笔记
                vc =[[YWMyContactViewController  alloc]init];
                 [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 3:{
                //3分红
                vc = [[YWBusinessMemberViewController alloc]init];
                 [weakSelf.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            default:
                break;
        }
       
    };
    self.headerView.iconBtnBlock = ^(){
        [weakSelf makeLocalImagePicker];
    };
}

- (void)dataSet{
    self.showArr = [NSMutableArray arrayWithArray:@[@[@{@"name":@"经营日报",@"image":@"Person_12"},@{@"name":@"银行账户管理",@"image":@"Person_5"},@{@"name":@"结算周期管理",@"image":@"Person_9"}],@[@{@"name":@"联系商务会员",@"image":@"Person_3"},@{@"name":@"业务合作",@"image":@"Person_2"},@{@"name":@"帮助中心",@"image":@"Person_1"},@{@"name":@"商务热线",@"image":@"Person_0"},@{@"name":@"意见反馈",@"image":@"Person_10"}],@[@{@"name":@"设置",@"image":@"Person_11"}]]];
    for (int i = 0; i < self.showArr.count; i++) {
        NSMutableArray * showArrTemp = [NSMutableArray arrayWithArray:self.showArr[i]];
        for (int j = 0; j < showArrTemp.count; j++) {
            [showArrTemp replaceObjectAtIndex:j withObject:[YWPersonCenterModel yy_modelWithDictionary:showArrTemp[j]]];
        }
        [self.showArr replaceObjectAtIndex:i withObject:showArrTemp];
    }
    
    self.countArr = @[@0,@([self.showArr[0] count]),@([self.showArr[1] count]),@([self.showArr[2] count])];
    
    [self.tableView registerNib:[UINib nibWithNibName:PERSONCCELL bundle:nil] forCellReuseIdentifier:PERSONCCELL];
    
    self.subViewArr = @[@[[YWPersonNewsViewController class],[YWBankViewController class],[YWPersonWeekCountViewController class]],@[[YWPersonSuperVipViewController class],[YWPersonCooperaViewController class],[YWPersonHelpViewController class],@"",[YWPersonSuggestViewController class]],@[[YWPersonSettingViewController class]]];
}

- (void)refreshUI{
    self.headerView.nameLabel.text = [UserSession instance].nickName;
    [self.headerView.iconImageView sd_setImageWithURL:[NSURL URLWithString:[UserSession instance].logo] placeholderImage:[UIImage imageNamed:@"btn-Upload-Avatar"] completed:nil];
    self.headerView.signatureLabel.text = [UserSession instance].personality;
}

- (void)makeLocalImagePicker{
    WEAKSELF;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//take photo
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [weakSelf myImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
        } else {
            MyLog(@"照片源不可用");
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//to localPhotos
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
    self.headerView.iconImageView.image = self.cameraImage;
    [self requestChangeIcon];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BtnAction
- (void)settingBtnAction{
    YWPersonSettingViewController * vc = [[YWPersonSettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)callService{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

     [alertController addAction:[UIAlertAction actionWithTitle:@"4001505599" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         UIWebView* callWebview =[[UIWebView alloc] init];
         //        NSURL * telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[UserSession instance].phone]];
         NSURL * telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:4001505599"]];
         [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
         [self.view addSubview:callWebview];
     }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        [self settingBtnAction];
    }else if (indexPath.section == 2&&indexPath.row == 3){
        [self callService];
    }else{
        Class viewClass = (Class)self.subViewArr[indexPath.section - 1][indexPath.row];
        UIViewController * vc = [[viewClass alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?(90.f + ACTUAL_WIDTH(250.f)):10.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section != 0)return nil;
    return self.headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.countArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.countArr[section] integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YWPersonTableViewCell * personCell = [tableView dequeueReusableCellWithIdentifier:PERSONCCELL forIndexPath:indexPath];
    personCell.model = self.showArr[indexPath.section - 1][indexPath.row];
    
    return personCell;
}

#pragma mark - Http
- (void)requestChangeIcon{
    NSDictionary * pragram = @{@"img":@"img"};
    
    [[HttpObject manager]postPhotoWithType:YuWaType_IMG_UP withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        self.cameraImageURL = responsObj[@"data"];
        if (!self.cameraImageURL)self.cameraImageURL=@"";
        [self requestUpIconURL];
    } failur:^(id errorData, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",error);
    } withPhoto:UIImagePNGRepresentation(self.cameraImage)];
    
}

- (void)requestUpIconURL{
    NSDictionary * pragram = @{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"company_img":self.cameraImageURL};
    
    [[HttpObject manager]postNoHudWithType:YuWaType_Shoper_ShopAdmin_SetBaseInfo withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        [UserSession instance].logo = self.cameraImageURL;
        self.headerView.iconImageView.image = self.cameraImage;
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
