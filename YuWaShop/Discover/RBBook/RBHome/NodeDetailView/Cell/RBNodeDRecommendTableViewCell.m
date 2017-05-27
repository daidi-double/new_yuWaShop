//
//  RBNodeDRecommendTableViewCell.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeDRecommendTableViewCell.h"
#import "RBHomeCollectionViewCell.h"

#define HOMECELL @"RBHomeCollectionViewCell"

@interface RBNodeDRecommendTableViewCell()
@property (nonatomic,strong)RBHomeCollectionViewCell * heighCell;

@end

@implementation RBNodeDRecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self collectionViewSet];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)collectionViewSet{
    self.waterFlowLayout = [[JWCollectionViewFlowLayout alloc]init];
    self.waterFlowLayout.delegate = self;
    self.collectionView.collectionViewLayout = self.waterFlowLayout;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:HOMECELL bundle:nil] forCellWithReuseIdentifier:HOMECELL];
    self.heighCell = [[[NSBundle mainBundle] loadNibNamed:HOMECELL owner:nil options:nil] firstObject];
}

- (void)setDataArr:(NSArray *)dataArr{
    if (!dataArr)return;
    _dataArr = dataArr;
    self.cellHeight = [self cellHeightSet];
    [self.collectionView reloadData];
    self.collectionViewHeight.constant = self.cellHeight;
    [self setNeedsLayout];
}

- (CGFloat)cellHeightSet{
    __block CGFloat rightRowHeight = 0.f;
    __block CGFloat leftRowHeight = 0.f;
    [self.dataArr enumerateObjectsUsingBlock:^(RBHomeModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.cellHeight < 10.f){
            self.heighCell.model = model;
            model.cellHeight = self.heighCell.cellHeight;
        }
        if (rightRowHeight > leftRowHeight) {
            leftRowHeight += model.cellHeight + 10.f;
        }else{
            rightRowHeight += model.cellHeight + 10.f;
        }
    }];
    
    return rightRowHeight>leftRowHeight?rightRowHeight:leftRowHeight;
}

#pragma mark - UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectNodeBlock(indexPath.row);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr?self.dataArr.count:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RBHomeCollectionViewCell * homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:HOMECELL forIndexPath:indexPath];
    homeCell.model = self.dataArr[indexPath.row];
    
    return homeCell;
}

#pragma mark - JWWaterflowLayoutDelegate
- (CGFloat)waterflowlayout:(JWCollectionViewFlowLayout *)waterlayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    RBHomeModel * model = self.dataArr[index];
    if (model.cellHeight > 10.f)return model.cellHeight;
    
    self.heighCell.model = model;
    model.cellHeight = self.heighCell.cellHeight;
    return model.cellHeight;
}

@end
