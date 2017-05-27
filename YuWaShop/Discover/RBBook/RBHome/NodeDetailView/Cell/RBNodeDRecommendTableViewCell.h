//
//  RBNodeDRecommendTableViewCell.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWCollectionViewFlowLayout.h"

@interface RBNodeDRecommendTableViewCell : UITableViewCell<UICollectionViewDataSource,JWWaterflowLayoutDelegate>

@property (nonatomic,copy)void (^selectNodeBlock)(NSInteger);
@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic, strong)JWCollectionViewFlowLayout *waterFlowLayout;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (nonatomic,assign)CGFloat cellHeight;

@end
