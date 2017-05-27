
//
//  RBPublicToolView.m
//  YuWa
//
//  Created by Tian Wei You on 16/9/21.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "RBPublicToolView.h"

#define IMGTOOLSCELL @"RBIMGToolsCollectionViewCell"
@interface RBPublicToolView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YJSegmentedControlDelegate>

@property (nonatomic,strong)NSArray * toolTypeArr;

@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)YJSegmentedControl * bottomSegmentControl;
@property (nonatomic,strong)UIView * imageToolHeader;

@end

@implementation RBPublicToolView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.toolTypeArr = [JWTools imageFilterArr];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self makeUI];
    [self.collectionView registerNib:[UINib nibWithNibName:IMGTOOLSCELL bundle:nil] forCellWithReuseIdentifier:IMGTOOLSCELL];
}

- (void)makeUI{
    self.bottomSegmentControl = [YJSegmentedControl segmentedControlFrame:CGRectMake(0.f, 160.f, kScreen_Width, 44.f) titleDataSource:@[@"滤镜",@"标签"] backgroundColor:[UIColor colorWithHexString:@"#f5f8fa"] titleColor:CsubtitleColor titleFont:[UIFont systemFontOfSize:15.f] selectColor:CsubtitleColor buttonDownColor:[UIColor colorWithHexString:@"#f14567"] Delegate:self];
    [self addSubview:self.bottomSegmentControl];
    
    self.imageToolHeader = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, kScreen_Width, 30.f)];
    self.imageToolHeader.backgroundColor = [UIColor whiteColor];
    UIButton * effectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 105.f, self.imageToolHeader.height)];
    effectBtn.backgroundColor = [UIColor whiteColor];
    [effectBtn setTitleColor:CtitleColor forState:UIControlStateNormal];
    [effectBtn setTitle:@"滤镜库" forState:UIControlStateNormal];
    [effectBtn setUserInteractionEnabled:NO];
    effectBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.imageToolHeader addSubview:effectBtn];
    [self addSubview:self.imageToolHeader];
}

- (IBAction)tagBtnAction:(id)sender {
    self.tagBlock();
}

- (void)setSelectType:(NSInteger)selectType{
    if (_selectType == selectType)return;
    RBIMGToolsCollectionViewCell *typeCell = (RBIMGToolsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectType inSection:0]];
    typeCell.showImageView.layer.borderWidth = 0.f;
    
    _selectType = selectType;
    RBIMGToolsCollectionViewCell *selectCell = (RBIMGToolsCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectType inSection:0]];
    selectCell.showImageView.layer.borderWidth = 3.f;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectType inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - YJSegmentedControlDelegate
-(void)segumentSelectionChange:(NSInteger)selection{
    self.status = selection;//加贴纸功能后有用1111111
    self.tagAddBtn.hidden = selection == 1?NO:YES;
    if (!self.tagAddBtn.titleLabel.text){
        [self.tagAddBtn setTitle:@"        点击照片\n选择添加相关信息" forState:UIControlStateNormal];
    }
    self.imageToolHeader.hidden = selection == 0?NO:YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.toolTypeArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBIMGToolsCollectionViewCell * toolsCell = [collectionView dequeueReusableCellWithReuseIdentifier:IMGTOOLSCELL forIndexPath:indexPath];
    toolsCell.idx = indexPath.row;
    toolsCell.nameLabel.text = self.toolTypeArr[indexPath.row][@"title"];
    toolsCell.showImageView.layer.borderColor = [UIColor colorWithHexString:@"#f15467"].CGColor;
    toolsCell.showImageView.layer.borderWidth = indexPath.row == self.selectType?3:0;
    toolsCell.filterName = self.toolTypeArr[indexPath.row][@"name"];
    
    return toolsCell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(95.f, 130.f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectType = indexPath.row;
    self.effectChooseBlock(self.toolTypeArr[indexPath.row][@"name"],indexPath.row);
}

@end
