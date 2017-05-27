//
//  JWTagCollectionView.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "JWTagsCollectionView.h"
#import "JWTagsCollectionViewCell.h"

#define TAGCELL @"JWTagsCollectionViewCell"

#define TagWidth [UIScreen mainScreen].bounds.size.width/5
@implementation JWTagsCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:flowLayout{
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        self.fontColor = CNaviColor;
        self.chooseColor = CNaviColor;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self registerNib:[UINib nibWithNibName:TAGCELL bundle:nil] forCellWithReuseIdentifier:TAGCELL];
    }
    return self;
}

- (void)setTagArr:(NSArray *)tagArr{
    if (!tagArr)return;
    _tagArr = tagArr;
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource

#pragma mark - UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.tagArr) {
        self.tagArr = @[];
    }
    return self.tagArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JWTagsCollectionViewCell * tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:TAGCELL forIndexPath:indexPath];
    tagCell.fontColor = self.fontColor;
    tagCell.chooseColor = self.chooseColor;
    tagCell.choosed = NO;
    tagCell.nameLabel.text = self.tagArr[indexPath.row];
    
    return tagCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(TagWidth, 42.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.f;
}

@end
