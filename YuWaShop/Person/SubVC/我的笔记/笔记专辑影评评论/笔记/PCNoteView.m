//
//  PCNoteView.m
//  YuWa
//
//  Created by 黄佳峰 on 16/10/14.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "PCNoteView.h"
#import "JWCollectionViewFlowLayout.h"
#import "RBNodeBGView.h"
#import "RBHomeCollectionViewCell.h"
#import "RBNewNodeCollectionViewCell.h"


#import "JWTools.h"

#define NEWNODECELL @"RBNewNodeCollectionViewCell"
#define HOMECELL @"RBHomeCollectionViewCell"

@interface PCNoteView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,JWWaterflowLayoutDelegate>

@property(nonatomic,strong)NSMutableArray*allDatas;

@property (strong, nonatomic)UICollectionView *collectionView;
@property (nonatomic,strong)RBHomeCollectionViewCell * heighCell;
@property (nonatomic, strong)JWCollectionViewFlowLayout *waterFlowLayout;
@end

@implementation PCNoteView



-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

-(instancetype)initWithFrame:(CGRect)frame andArray:(NSMutableArray*)allDatas{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.allDatas=allDatas;

        
        self.waterFlowLayout = [[JWCollectionViewFlowLayout alloc]init];
        self.waterFlowLayout.delegate = self;
        
        self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:self.waterFlowLayout];
      
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.backgroundColor=RGBCOLOR(239, 239, 244, 1);
        self.collectionView.scrollEnabled = NO;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerNib:[UINib nibWithNibName:HOMECELL bundle:nil] forCellWithReuseIdentifier:HOMECELL];
        [self.collectionView registerNib:[UINib nibWithNibName:NEWNODECELL bundle:nil] forCellWithReuseIdentifier:NEWNODECELL];
        
        self.heighCell = [[[NSBundle mainBundle] loadNibNamed:HOMECELL owner:nil options:nil] firstObject];

        
        
    }
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame andArray:(NSMutableArray*)allDatas withIsOther:(BOOL)isOther{
    self=[super initWithFrame:frame];
    if (self) {
        self.isOther = isOther;
        self.allDatas=allDatas;
        
        
        self.waterFlowLayout = [[JWCollectionViewFlowLayout alloc]init];
        self.waterFlowLayout.delegate = self;
        
        self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:self.waterFlowLayout];
        
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.backgroundColor=RGBCOLOR(239, 239, 244, 1);
        self.collectionView.scrollEnabled = NO;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerNib:[UINib nibWithNibName:HOMECELL bundle:nil] forCellWithReuseIdentifier:HOMECELL];
        [self.collectionView registerNib:[UINib nibWithNibName:NEWNODECELL bundle:nil] forCellWithReuseIdentifier:NEWNODECELL];
        
        self.heighCell = [[[NSBundle mainBundle] loadNibNamed:HOMECELL owner:nil options:nil] firstObject];
        
        
        
    }
    return self;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat height = 180.f - 55.25f + (kScreen_Width - 20.f - 75.f)/4;
//    return CGSizeMake(kScreen_Width - 20.f, height);
//}

#pragma mark - JWWaterFlowLayoutDelegate
- (CGFloat)waterflowlayout:(JWCollectionViewFlowLayout *)waterlayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    if (index == 0 && !self.isOther) {
        return [UIScreen mainScreen].bounds.size.width/320.f*145.f;
    }
    RBHomeModel * model;
    if (self.isOther) {
        model = self.allDatas[index];
    }else{
        model = self.allDatas[index - 1];
    }
    
    if (model.cellHeight > 10.f) {
        return model.cellHeight;
    }
    
    self.heighCell.model = model;
    model.cellHeight = self.heighCell.cellHeight;
    return model.cellHeight;
}

#pragma mark - UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MyLog(@"%@",indexPath);
    NSInteger number=indexPath.row-1;
    
    if (self.touchCellBlock) {
        self.touchCellBlock(number);
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.isOther?self.allDatas.count:(self.allDatas.count+1);
    

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
        if (indexPath.row == 0 && !self.isOther) {
            RBNewNodeCollectionViewCell * newNodeCell = [collectionView dequeueReusableCellWithReuseIdentifier:NEWNODECELL forIndexPath:indexPath];
            
            return newNodeCell;
        }
    
    
        RBHomeCollectionViewCell * homeCell = [collectionView dequeueReusableCellWithReuseIdentifier:HOMECELL forIndexPath:indexPath];
    homeCell.model = self.allDatas[self.isOther?indexPath.row:(indexPath.row - 1)];
        return homeCell;
    
    
   }





//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(kScreen_Width, 200);
//}

@end
