//
//  AlbumView.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "AlbumView.h"
#import "RBNewAlbumCollectionViewCell.h"
#import "RBAlbumCollectionViewCell.h"


#define ALDUMCELL @"RBAlbumCollectionViewCell"
#define NEWALDUMCELL @"RBNewAlbumCollectionViewCell"

@interface AlbumView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView*collectionView;

@property(nonatomic,strong)NSArray*allDatas;
@end
@implementation AlbumView

-(instancetype)initWithFrame:(CGRect)frame andArray:(NSMutableArray*)allDatas{
    self=[super initWithFrame:frame];
    if (self) {
        self.allDatas=allDatas;
        
        UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
          CGFloat height = 180.f - 55.25f + (kScreen_Width - 20.f - 75.f)/4;
        flowLayout.itemSize=CGSizeMake(kScreen_Width-20.f, height);
        flowLayout.sectionInset=UIEdgeInsetsMake(10, 10, 0, 10);
        flowLayout.minimumLineSpacing=10;
        
        self.collectionView=[[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.scrollEnabled=NO;
        self.collectionView.backgroundColor=RGBCOLOR(239, 239, 244, 1);
        [self addSubview:self.collectionView];
        [self.collectionView registerNib:[UINib nibWithNibName:ALDUMCELL bundle:nil] forCellWithReuseIdentifier:ALDUMCELL];
        [self.collectionView registerNib:[UINib nibWithNibName:NEWALDUMCELL bundle:nil] forCellWithReuseIdentifier:NEWALDUMCELL];

        
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andArray:(NSMutableArray*)allDatas withIsOther:(BOOL)isOther{
    self=[super initWithFrame:frame];
    if (self) {
        self.isOther = isOther;
        self.allDatas=allDatas;
        UICollectionViewFlowLayout*flowLayout=[[UICollectionViewFlowLayout alloc]init];
        CGFloat height = 180.f - 55.25f + (kScreen_Width - 20.f - 75.f)/4;
        flowLayout.itemSize=CGSizeMake(kScreen_Width-20.f, height);
        flowLayout.sectionInset=UIEdgeInsetsMake(10, 10, 0, 10);
        flowLayout.minimumLineSpacing=10;
        
        self.collectionView=[[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.scrollEnabled=NO;
        self.collectionView.backgroundColor=RGBCOLOR(239, 239, 244, 1);
        [self addSubview:self.collectionView];
        [self.collectionView registerNib:[UINib nibWithNibName:ALDUMCELL bundle:nil] forCellWithReuseIdentifier:ALDUMCELL];
        [self.collectionView registerNib:[UINib nibWithNibName:NEWALDUMCELL bundle:nil] forCellWithReuseIdentifier:NEWALDUMCELL];
        
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame=self.frame;
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.isOther?self.allDatas.count:(self.allDatas.count+1);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.allDatas.count) {
        RBNewAlbumCollectionViewCell * newAldumCell = [collectionView dequeueReusableCellWithReuseIdentifier:NEWALDUMCELL forIndexPath:indexPath];
        return newAldumCell;
    }
    
    RBAlbumCollectionViewCell * albumCell = [collectionView dequeueReusableCellWithReuseIdentifier:ALDUMCELL forIndexPath:indexPath];
    albumCell.model = self.allDatas[indexPath.row];
//    albumCell.backgroundColor=[UIColor redColor];
    return albumCell;

    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   //最大的话  就是 发布专辑
    if (self.touchCellBlock) {
        self.touchCellBlock(indexPath.row,self.allDatas.count);
    }
    
}



@end
