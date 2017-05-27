//
//  JWCollectionViewFlowLayout.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/9.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWCollectionViewFlowLayout;
@protocol JWWaterflowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowlayout:(JWCollectionViewFlowLayout *)waterlayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;
@optional
- (CGFloat)columnCountInWaterflowLayout:(JWCollectionViewFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(JWCollectionViewFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(JWCollectionViewFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(JWCollectionViewFlowLayout *)waterflowLayout;

@end

@interface JWCollectionViewFlowLayout : UICollectionViewLayout

/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

@property (nonatomic, weak) id<JWWaterflowLayoutDelegate> delegate;


@end
