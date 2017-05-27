//
//  JWTagCollectionView.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/8.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWTagCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,copy)void (^changeTagBlock)(NSString *);

@property (nonatomic,strong)NSArray * tagArr;

@property (nonatomic,assign)NSInteger choosedTag;
@property (nonatomic,strong)UIView * tagVeiw;//浮动滑块

@property (nonatomic,strong)UIColor * fontColor;
@property (nonatomic,strong)UIColor * chooseColor;
@property (nonatomic,assign)BOOL tagChoosed;

@end
