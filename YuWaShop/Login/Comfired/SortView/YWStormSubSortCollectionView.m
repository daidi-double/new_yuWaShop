//
//  YWStormSubSortCollectionView.m
//  YuWa
//
//  Created by Tian Wei You on 16/10/15.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWStormSubSortCollectionView.h"

@implementation YWStormSubSortCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F5F8FA"];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.dataArr = @[];
        self.choosedTypeArr = [NSMutableArray arrayWithCapacity:0];
        
        self.cellWidth = kScreen_Width*2/3 - 10.f;
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr{
    if (!dataArr)return;
    self.choosedTypeArr = [NSMutableArray arrayWithCapacity:0];
    if (!_dataArr) {
        _dataArr = dataArr;
        return;
    }
    _dataArr = dataArr;
    [self reloadData];

}
- (void)dataSet{
    self.dataSource = self;
    self.delegate = self;
    [self registerNib:[UINib nibWithNibName:STORMSORTCOLLECTIONCELL bundle:nil] forCellWithReuseIdentifier:STORMSORTCOLLECTIONCELL];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YWStormSubSortCollectionViewCell * subSortCell = [collectionView dequeueReusableCellWithReuseIdentifier:STORMSORTCOLLECTIONCELL forIndexPath:indexPath];
    YWComfiredTypeModel * model = self.dataArr[indexPath.row];
    subSortCell.nameLabel.text = model.tag_name;
    if (model.isSelected) {
        subSortCell.nameLabel.textColor = CNaviColor;
    }else{
        subSortCell.nameLabel.textColor = CsubtitleColor;
    }
    return subSortCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YWComfiredTypeModel * model = self.dataArr[indexPath.row];
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
        [self.choosedTypeArr addObject:model];
    }else{
        [self.choosedTypeArr removeObject:model];
    }
    [self reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.cellWidth - 20.f, 44.f);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0.f, 0.f, 5.f, 5.f);
}

@end
