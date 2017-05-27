//
//  StorePhotoViewController.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/13.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "StorePhotoViewController.h"
#import "StorePhotoCollectionViewCell.h"

#import "StorePhotoModel.h"

#import "JWTools.h"
#import "YJSegmentedControl.h"
#import "JLPhotoBrowser.h"



#define CELL0    @"StorePhotoCollectionViewCell"
@interface StorePhotoViewController ()<YJSegmentedControlDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property(nonatomic,strong)YJSegmentedControl*topView;
@property(nonatomic,strong)UICollectionView*collectionView;

@property(nonatomic,assign)NSInteger status;
@property(nonatomic,assign)int pagen;
@property(nonatomic,assign)int pages;
@property(nonatomic,strong)NSMutableArray*allDatasModel;


@end

@implementation StorePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.title=@"商家相册";
    [self addTopView];
    [self addcollectionView];
    [self setUpMJRefresh];
    [self rightButton];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden= NO;
}

#pragma mark  -- UI
-(void)rightButton{
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,20,20)];
    [button setBackgroundImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchRightItem) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem=item;
    
}

-(void)addTopView{
    NSArray*titleArray=@[@"店铺",@"商品",@"环境",@"其他"];
    YJSegmentedControl*topView=[YJSegmentedControl segmentedControlFrame:CGRectMake(0, 64, kScreen_Width, 44) titleDataSource:titleArray backgroundColor:[UIColor whiteColor] titleColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:14] selectColor:CNaviColor buttonDownColor:CNaviColor Delegate:self];
    [self.view addSubview:topView];
    self.topView=topView;
    
}

-(void)addcollectionView{
    UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing=20;
    flowLayout.minimumLineSpacing=15;
    flowLayout.sectionInset=UIEdgeInsetsMake(15, 15, 15, 15);
    flowLayout.itemSize=CGSizeMake((kScreen_Width-20-30)/2, (kScreen_Width-20-30)/2);
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64+44, kScreen_Width, kScreen_Height-64-44) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor=[UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellWithReuseIdentifier:CELL0];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
  
    [self.view addSubview:self.collectionView];
    
    
}

-(void)setUpMJRefresh{
    self.status=0;
    self.pagen=10;
    self.pages=0;
    self.allDatasModel=[NSMutableArray array];
    
    self.collectionView.mj_header=[UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages=0;
        self.allDatasModel=[NSMutableArray array];
        [self getDatas];
        
    }];
    
    //上拉刷新
    self.collectionView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        self.pages++;
        [self getDatas];
    }];
    
    //立即刷新
    [self.collectionView.mj_header beginRefreshing];
    
    
    
}


#pragma mark  --collectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allDatasModel.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:CELL0 forIndexPath:indexPath];
    StorePhotoModel*model=self.allDatasModel[indexPath.row];
    
    UIImageView*imageView=[cell viewWithTag:1];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    UILabel*label=[cell viewWithTag:3];
    label.text=model.title;
  
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray*array=[NSMutableArray array];
    for (StorePhotoModel*model in self.allDatasModel) {
        [array addObject:model.url];
    }
    
    NSMutableArray *photos = [NSMutableArray array];
    
    for (int i=0; i<array.count; i++) {
        
       
        JLPhoto *photo = [[JLPhoto alloc] init];
        photo.bigImgUrl = array[i];
        photo.tag = i;
        [photos addObject:photo];
        
    }
    
    JLPhotoBrowser *photoBrowser = [[JLPhotoBrowser alloc] init];
    photoBrowser.allDatasModel=self.allDatasModel;
    photoBrowser.photos = photos;
    photoBrowser.currentIndex =(short)indexPath.row;


    //改变名字
    photoBrowser.changeNameBlock=^(NSInteger selectedNumber,NSString*title){

        
        [self changePhotoTitle:selectedNumber andTitle:title];
        
    };
    
    //删除照片
    photoBrowser.deletePhotoBlock=^(NSInteger selectedNumber){


        [self deletePhoto:selectedNumber];
        
    };
    
    
    [photoBrowser show];

    
    
    
}

#pragma mark  --touch
-(void)touchRightItem{

   [self makeLocalImagePicker];

}

#pragma mark  --  photoChoose
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
    UIImage*image = info[@"UIImagePickerControllerEditedImage"];
    [self addPhotoWithImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}



#pragma mark  --delegate
-(void)segumentSelectionChange:(NSInteger)selection{

    self.status=selection;
    [self.collectionView.mj_header beginRefreshing];
    
}


#pragma mark  -- Datas
-(void)getDatas{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_PHOTO_ALBUM];
    NSString*pagen=[NSString stringWithFormat:@"%d",self.pagen];
    NSString*pages=[NSString stringWithFormat:@"%d",self.pages];
    NSString*status=[NSString stringWithFormat:@"%ld",(long)self.status];
    
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"type":status,@"pagen":pagen,@"pages":pages};
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            for (NSDictionary*dict in data[@"data"]) {
                StorePhotoModel*model=[StorePhotoModel yy_modelWithDictionary:dict];
                [self.allDatasModel addObject:model];
                
            }
             [self.collectionView reloadData];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
 
        
    }];
    
    
}

//改变相片的名字
-(void)changePhotoTitle:(NSInteger)selectedNumber andTitle:(NSString*)title{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_PHOTI_CHANGE_TITLE];
      StorePhotoModel*model=self.allDatasModel[selectedNumber];
     NSString*idd=model.id;
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":idd,@"title":title};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [JRToast showWithText:data[@"data"]];
            [self.collectionView.mj_header beginRefreshing];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }
        
      
    }];


    
    
    
};

//删除相片
-(void)deletePhoto:(NSInteger)selectedNumber{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_PHOTO_DELETE];
    StorePhotoModel*model=self.allDatasModel[selectedNumber];
    NSString*idd=model.id;
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"id":idd};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [JRToast showWithText:data[@"data"]];
            [self.collectionView.mj_header beginRefreshing];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }

        
    }];
    
    
    
}

//添加相片
-(void)addPhotoWithImage:(UIImage*)image{
    //上传照片
    NSData*data= UIImageJPEGRepresentation(image, 1.0);
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_UPDATEIMAGE];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postUpdatePohotoWithUrl:urlStr withParams:nil withPhoto:data compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            NSString*urlStr=data[@"data"];
            [self updataImageURl:urlStr];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }

        
    }];
    
    
}

-(void)updataImageURl:(NSString*)imageUrl{
    NSString*urlStr=[NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,SHOP_PHOTO_ADD];
    NSDictionary*params=@{@"device_id":[JWTools getUUID],@"token":[UserSession instance].token,@"user_id":@([UserSession instance].uid),@"title":@"图片",@"url":imageUrl,@"type":@(self.status)};
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDatasNoHudWithUrl:urlStr withParams:params compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        NSNumber*number=data[@"errorCode"];
        NSString*errorCode=[NSString stringWithFormat:@"%@",number];
        if ([errorCode isEqualToString:@"0"]) {
            [self.collectionView.mj_header beginRefreshing];
            
        }else{
            [JRToast showWithText:data[@"errorMessage"]];
        }

        
        
    }];
    
    
}


@end
