//
//  JWTagCollectionView.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "JWTagCollectionView.h"
#import "JWTagCollectionViewCell.h"
#import "RBPublishSession.h"

#define TAGCELL @"JWTagCollectionViewCell"

#define TagWidth [UIScreen mainScreen].bounds.size.width/5
@implementation JWTagCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:flowLayout{
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        self.fontColor = [UIColor colorWithHexString:@"#333333"];
        self.chooseColor = CNaviColor;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self registerNib:[UINib nibWithNibName:TAGCELL bundle:nil] forCellWithReuseIdentifier:TAGCELL];
        [self makeTagView];
    }
    return self;
}

- (void)setTagArr:(NSArray *)tagArr{
    if (!tagArr)return;
    _tagArr = tagArr;
    [self reloadData];
}

- (void)setTagChoosed:(BOOL)tagChoosed{
    _tagChoosed = tagChoosed;
    if (tagChoosed) {
        self.chooseColor = CNaviColor;
        self.fontColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        _tagChoosed = [RBPublishSession sharePublishSession].status>0?NO:YES;
        self.choosedTag = [RBPublishSession sharePublishSession].status>0?[RBPublishSession sharePublishSession].status - 1:0;
        [self reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.choosedTag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
            JWTagCollectionViewCell * selectedCell = (JWTagCollectionViewCell *)[self collectionView:self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.choosedTag inSection:0]];
            self.tagVeiw.x = selectedCell.x;
            self.tagVeiw.hidden = [RBPublishSession sharePublishSession].status == 0?YES:NO;
            if (!self.tagVeiw.hidden) {
                selectedCell.nameLabel.textColor = self.chooseColor;
            }
        });
    }
}

- (void)makeTagView{
    self.tagVeiw = [[UIView alloc]initWithFrame:CGRectMake(self.choosedTag * TagWidth, self.height - 2.f, TagWidth, 2.f)];
    self.tagVeiw.backgroundColor = self.chooseColor;
    [self addSubview:self.tagVeiw];
}

#pragma mark - UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _tagChoosed = NO;
    
    self.changeTagBlock([NSString stringWithFormat:@"%zi",indexPath.row]);
    self.choosedTag = indexPath.row;
    
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    JWTagCollectionViewCell * selectedCell = (JWTagCollectionViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.nameLabel.textColor = self.chooseColor;
    [UIView animateWithDuration:0.4 animations:^{
        self.tagVeiw.x = selectedCell.x;
    } completion:nil];
    [self reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.tagArr) {
        self.tagArr = @[];
    }
    return self.tagArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JWTagCollectionViewCell * tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:TAGCELL forIndexPath:indexPath];
    tagCell.fontColor = self.fontColor;
    tagCell.chooseColor = self.chooseColor;
    tagCell.choosed = self.choosedTag == indexPath.row ? YES:NO;
    if (self.choosedTag == indexPath.row)self.tagVeiw.hidden = self.tagChoosed;
    if (self.choosedTag == indexPath.row && self.tagChoosed) {
        tagCell.choosed = NO;
    }
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
