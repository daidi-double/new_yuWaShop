//
//  RBNodeViewController.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeViewController.h"
#import "RBNodeShowViewController.h"
#import "JWCollectionViewFlowLayout.h"
#import "RBNodeBGView.h"
#import "YJSegmentedControl.h"

#import "RBHomeCollectionViewCell.h"
#import "RBNewNodeCollectionViewCell.h"
#import "RBNewAlbumCollectionViewCell.h"
#import "RBAlbumCollectionViewCell.h"

#define ALDUMCELL @"RBAlbumCollectionViewCell"
#define NEWALDUMCELL @"RBNewAlbumCollectionViewCell"
#define NEWNODECELL @"RBNewNodeCollectionViewCell"
#define HOMECELL @"RBHomeCollectionViewCell"

@interface RBNodeViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,JWWaterflowLayoutDelegate,YJSegmentedControlDelegate>

@property (nonatomic,strong)RBNodeBGView *nodeBGView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;

@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * albumDataArr;
@property (nonatomic,copy)NSString * pagens;
@property (nonatomic,assign)NSInteger pages;
@property (nonatomic,assign)NSInteger albumPages;
@property (nonatomic,assign)NSInteger states;

@property (nonatomic,strong)RBHomeCollectionViewCell * heighCell;
@property (nonatomic, strong)JWCollectionViewFlowLayout *waterFlowLayout;
@property (nonatomic,strong)YJSegmentedControl * segmentControl;

@end

@implementation RBNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笔记";
    [self dataSet];
    [self makeUI];
    [self setupRefresh];
    self.states = 1;
    [self headerRereshing];
    self.states = 0;
    [self headerRereshing];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.nodeBGView.frame = CGRectMake(0.f, 94.f, kScreen_Width, kScreen_Height - 94.f);
}

- (void)dataSet{
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.albumDataArr = [NSMutableArray arrayWithCapacity:0];
    self.pagens = @"10";
    
    self.waterFlowLayout = [[JWCollectionViewFlowLayout alloc]init];
    self.waterFlowLayout.delegate = self;
    self.collectionView.collectionViewLayout = self.waterFlowLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:HOMECELL bundle:nil] forCellWithReuseIdentifier:HOMECELL];
    [self.collectionView registerNib:[UINib nibWithNibName:NEWNODECELL bundle:nil] forCellWithReuseIdentifier:NEWNODECELL];
    self.heighCell = [[[NSBundle mainBundle] loadNibNamed:HOMECELL owner:nil options:nil] firstObject];
    
    [self.albumCollectionView registerNib:[UINib nibWithNibName:ALDUMCELL bundle:nil] forCellWithReuseIdentifier:ALDUMCELL];
    [self.albumCollectionView registerNib:[UINib nibWithNibName:NEWALDUMCELL bundle:nil] forCellWithReuseIdentifier:NEWALDUMCELL];
}

- (void)makeUI{
    self.segmentControl = [YJSegmentedControl segmentedControlFrame:CGRectMake(0.f, NavigationHeight, kScreen_Width, 44.f) titleDataSource:@[@"笔记·0",@"专辑·0"] backgroundColor:[UIColor whiteColor] titleColor:[UIColor colorWithHexString:@"#999999"] titleFont:[UIFont systemFontOfSize:15.f] selectColor:[UIColor colorWithHexString:@"#ff2741"] buttonDownColor:[UIColor colorWithHexString:@"#ff2741"] Delegate:self];
    [self.view addSubview:self.segmentControl];
    
    self.nodeBGView = [[[NSBundle mainBundle]loadNibNamed:@"RBNodeBGView" owner:nil options:nil]firstObject];
    WEAKSELF;
    self.nodeBGView.publishBlock = ^(){
        if (self.states == 0) {
            [weakSelf publishNodeAction];
        }else{
            [weakSelf publishAlbumAction];
        }
    };
    [self.view addSubview:self.nodeBGView];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 180.f - 55.25f + (kScreen_Width - 20.f - 75.f)/4;
    return CGSizeMake(kScreen_Width - 20.f, height);
}

#pragma mark - JWWaterFlowLayoutDelegate
- (CGFloat)waterflowlayout:(JWCollectionViewFlowLayout *)waterlayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    if (index == 0) {
        return [UIScreen mainScreen].bounds.size.width/320.f*145.f;
    }
    RBHomeModel * model = self.dataArr[index - 1];
    if (model.cellHeight > 10.f) {
        return model.cellHeight;
    }
    
    self.heighCell.model = model;
    model.cellHeight = self.heighCell.cellHeight;
    return model.cellHeight;
}

#pragma mark - UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 1) {
        if (indexPath.row == 0) {
            [self publishNodeAction];
            return;
        }
        RBNodeShowViewController * vc = [[RBNodeShowViewController alloc]init];
        vc.model = self.dataArr[indexPath.row - 1];
        vc.isUser = YES;
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        if (indexPath.row == self.albumDataArr.count) {
            [self publishAlbumAction];
            return;
        }
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.states == 0) {
        collectionView.hidden = self.dataArr.count > 0?NO:YES;
        self.nodeBGView.hidden = self.dataArr.count > 0?YES:NO;
        self.albumCollectionView.hidden = YES;
    }else{
        collectionView.hidden = self.albumDataArr.count > 0?NO:YES;
        self.nodeBGView.hidden = self.albumDataArr.count > 0?YES:NO;
        self.collectionView.hidden = YES;
    }
    
    [self updateSegmentDataWithNodeCount:self.dataArr.count withAldumCount:self.albumDataArr.count];
    
    return collectionView.tag == 1 ? self.dataArr.count + 1:self.albumDataArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 1) {
        if (indexPath.row == 0) {
            RBNewNodeCollectionViewCell * newNodeCell = [collectionView dequeueReusableCellWithReuseIdentifier:NEWNODECELL forIndexPath:indexPath];
            
            return newNodeCell;
        }
        RBHomeCollectionViewCell * homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:HOMECELL forIndexPath:indexPath];
        homeCell.model = self.dataArr[indexPath.row - 1];
        return homeCell;
    }
    
    if (indexPath.row == self.albumDataArr.count) {
        RBNewAlbumCollectionViewCell * newAldumCell = [collectionView dequeueReusableCellWithReuseIdentifier:NEWALDUMCELL forIndexPath:indexPath];
        return newAldumCell;
    }
    RBAlbumCollectionViewCell * albumCell = [collectionView dequeueReusableCellWithReuseIdentifier:ALDUMCELL forIndexPath:indexPath];
    albumCell.model = self.albumDataArr[indexPath.row];
    return albumCell;
}


#pragma mark - Collection Refresh
- (void)setupRefresh{
    self.collectionView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    
    self.collectionView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
    
    self.albumCollectionView.mj_header = [UIScrollView scrollRefreshGifHeaderWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self headerRereshing];
    }];
    
    self.albumCollectionView.mj_footer = [UIScrollView scrollRefreshGifFooterWithImgName:@"newheader" withImageCount:60 withRefreshBlock:^{
        [self footerRereshing];
    }];
}
- (void)headerRereshing{
    if (self.states == 0) {
        self.pages = 0;
    }else{
        self.albumPages = 0;
    }
    [self requestDataWithPages:0];
}
- (void)footerRereshing{
    if (self.states == 0) {
        self.pages++;
    }else{
        self.albumPages++;
    }
    
    [self requestDataWithPages:self.states == 0?self.pages:self.albumPages];
}

#pragma mark - YJSegmentedControlDelegate
- (void)segumentSelectionChange:(NSInteger)selection{
    self.states = selection;
    self.nodeBGView.isNode = selection == 0?YES:NO;
    [self headerRereshing];
}

- (void)updateSegmentDataWithNodeCount:(NSInteger)node withAldumCount:(NSInteger)aldum{
    NSMutableArray * btnTitleSource = [NSMutableArray arrayWithArray:@[[NSString stringWithFormat:@"笔记·%zi",node],[NSString stringWithFormat:@"专辑·%zi",aldum]]];
    for (int i = 0; i < self.segmentControl.btnTitleSource.count; i++) {
        UIButton * btn = [self.segmentControl viewWithTag:i + 1];
        [btn setTitle:btnTitleSource[i] forState:UIControlStateNormal];
    }
}

#pragma mark - Http
- (void)requestDataWithPages:(NSInteger)page{
    if (self.states == 0) {
        [self requestNodeWithPage:page];
    }else{
        [self requestAldumWithPage:page];
    }
}

- (void)requestNodeWithPage:(NSInteger)page{
    NSDictionary * dataDic = [JWTools jsonWithFileName:@"总的笔记个人"];
//    MyLog(@"%@",dataDic);
    
    if (page == 0) {
        [self.dataArr removeAllObjects];
        [self.collectionView.mj_header endRefreshing];
    }else{
        [self.collectionView.mj_footer endRefreshing];
    }
    
    NSArray * dataArr = dataDic[@"data"][@"notes"];
    [dataArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataArr addObject:[RBHomeModel yy_modelWithDictionary:dic]];
    }];
    [self.collectionView reloadData];
}

- (void)requestAldumWithPage:(NSInteger)page{
    NSDictionary * dataDic = [JWTools jsonWithFileName:@"总的专辑 个人中心展示小图"];
//    MyLog(@"%@",dataDic);
    
    if (page == 0) {
        [self.albumDataArr removeAllObjects];
        [self.albumCollectionView.mj_header endRefreshing];
    }else{
        [self.albumCollectionView.mj_footer endRefreshing];
    }
    
    NSArray * dataArr = dataDic[@"data"];
    [dataArr enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.albumDataArr addObject:[RBCenterAlbumModel yy_modelWithDictionary:dic]];
    }];
    [self.albumCollectionView reloadData];
    
}


@end
