//
//  YWAddressSubSortCollectionView.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/23.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWStormSubSortCollectionView.h"
#import "YWAddressComfiredTypeModel.h"

@interface YWAddressSubSortCollectionView  : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,assign)CGFloat cellWidth;
@property (nonatomic,copy)void(^choosedTypeBlock)(NSString *,NSInteger);
@property (nonatomic,assign)NSInteger choosedTypeIdx;
@property (nonatomic,strong)NSArray * dataArr;
@property (nonatomic,strong)NSArray * dataTagArr;
@property (nonatomic,assign)NSInteger allTypeIdx;
@property (nonatomic,strong)NSMutableArray * choosedTypeArr;

- (void)dataSet;

@end
