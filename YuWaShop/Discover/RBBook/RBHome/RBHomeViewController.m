//
//  RBHomeViewController.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBHomeViewController.h"
#import "RBNodeShowViewController.h"
#import "RBHomeSearchViewController.h"
#import "YWLoginViewController.h"
#import "TZImagePickerController.h"

#import "JWTagCollectionView.h"
#import "JWCollectionViewFlowLayout.h"
#import "JWSearchView.h"

#import "RBHomeCollectionViewCell.h"

#define HOMECELL @"RBHomeCollectionViewCell"
@interface RBHomeViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,JWWaterflowLayoutDelegate,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)JWTagCollectionView * tagCollectionView;
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,copy)NSString * states;

@property (nonatomic,strong)RBHomeCollectionViewCell * heighCell;
@property (nonatomic, strong)JWCollectionViewFlowLayout *waterFlowLayout;
@property (nonatomic,strong)JWSearchView * searchView;

@end

@implementation RBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataSet];
    [self makeNavi];
    [self setupRefresh];
    [self makeTagCollectionViewWithArr:@[@"推荐", @"美食",@"电影",@"酒店",@"周边游",@"休闲娱乐",@"生活服务",@"旅游",@"宴会",@"时尚购",@"丽人",@"运动健身",@"母婴亲子",@"宠物",@"汽车服务",@"摄影写真",@"结婚",@"购物",@"家装",@"学习培训",@"医疗"]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestDataWithPages:0 ];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.searchView.width = kScreen_Width - 40.f - 30.f;
}

- (void)makeNavi{
   self.searchView = [[[NSBundle mainBundle]loadNibNamed:@"JWSearchView" owner:nil options:nil]firstObject];
    WEAKSELF;
    self.searchView.searchClik = ^(){
        [weakSelf searchBtnAction];
    };
    self.navigationItem.titleView = self.searchView;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImageName:@"white_camera" withSelectImage:@"white_camera" withHorizontalAlignment:UIControlContentHorizontalAlignmentCenter withTarget:self action:@selector(publishNodeAction) forControlEvents:UIControlEventTouchUpInside withSize:CGSizeMake(30.f, 30.f)];
}

- (void)makeTagCollectionViewWithArr:(NSArray *)tagArr{
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.tagCollectionView = [[JWTagCollectionView alloc]initWithFrame:CGRectMake(0.f, NavigationHeight, kScreen_Width, 44.f) collectionViewLayout:flowLayout];
    self.tagCollectionView.tagArr = tagArr;
    WEAKSELF;
    self.tagCollectionView.changeTagBlock = ^(NSString * chooseTag){//选中标签后操作
        weakSelf.states = chooseTag;
        MyLog(@"选择了%@个标签",chooseTag);
        [weakSelf.collectionView.mj_header beginRefreshing];
    };
    [self.view addSubview:self.tagCollectionView];
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.pagens = @"10";
    self.states = @"0";
    
    self.waterFlowLayout = [[JWCollectionViewFlowLayout alloc]init];
    self.waterFlowLayout.delegate = self;
    self.collectionView.collectionViewLayout = self.waterFlowLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:HOMECELL bundle:nil] forCellWithReuseIdentifier:HOMECELL];
    self.heighCell = [[[NSBundle mainBundle] loadNibNamed:HOMECELL owner:nil options:nil] firstObject];
}

#pragma mark - Button Action
- (void)backBarButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBtnAction{
    if (![self isComfired])return;
    RBHomeSearchViewController * vc = [[RBHomeSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JWWaterFlowLayoutDelegate
- (CGFloat)waterflowlayout:(JWCollectionViewFlowLayout *)waterlayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    RBHomeModel * model = self.dataArr[index];
    if (model.cellHeight > 10.f) return model.cellHeight;
    
    self.heighCell.model = model;
    model.cellHeight = self.heighCell.cellHeight;
    return model.cellHeight;
}

#pragma mark - UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![self isComfired])return;
    RBNodeShowViewController * vc = [[RBNodeShowViewController alloc]init];
    vc.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:NO];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBHomeCollectionViewCell * homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:HOMECELL forIndexPath:indexPath];
    homeCell.model = self.dataArr[indexPath.row];
    
    return homeCell;
}

#pragma mark - Collection Refresh
- (void)setupRefresh{
    self.collectionView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    
    self.collectionView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}
- (void)headerRereshing{
    self.pages = 0;
    [self requestDataWithPages:self.pages];
}
- (void)footerRereshing{
    self.pages++;
    [self requestDataWithPages:self.pages];
}

- (void)cancelRefreshWithIsHeader:(BOOL)isHeader{
    if (isHeader) {
        [self.collectionView.mj_header endRefreshing];
    }else{
        [self.collectionView.mj_footer endRefreshing];
    }
}

#pragma mark - Http
- (void)requestDataWithPages:(NSInteger)page{
    NSDictionary * pragram = @{@"type":self.states,@"pagen":self.pagens,@"pages":[NSString stringWithFormat:@"%zi",page],@"user_type":@(2),@"user_id":@([UserSession instance].uid),@"token":[UserSession instance].token,@"device_id":[JWTools getUUID]};
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RefreshTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelRefreshWithIsHeader:(page==0?YES:NO)];
    });
    
    [[HttpObject manager]postNoHudWithType:YuWaType_RB_HOME withPragram:pragram success:^(id responsObj) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code is %@",responsObj);
        if (page == 0) {
            [self.dataArr removeAllObjects];
        }
        NSArray * dataArr = responsObj[@"data"];
        if (dataArr.count>0) {
            for (int i = 0; i < dataArr.count; i++) {
                NSDictionary * dic = dataArr[i];
                NSMutableDictionary * dataDic = [RBHomeModel dataDicSetWithDic:dic];
                [self.dataArr addObject:[RBHomeModel yy_modelWithDictionary:dataDic]];
            }
        }
        [self.collectionView reloadData];
    } failur:^(id responsObj, NSError *error) {
        MyLog(@"Regieter Code pragram is %@",pragram);
        MyLog(@"Regieter Code error is %@",responsObj);
    }];
}

@end
