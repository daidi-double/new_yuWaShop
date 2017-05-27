//
//  XHTagView.h
//  XHTagView
//
//  Created by Jack_iMac on 16/2/22.
//  Copyright © 2016年 蒋威 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBranchLayer.h"
#import "XHCenterView.h"
#import "XHBranchTextView.h"
#import "XHBranchPoint.h"

#import "XHTagHeader.h"

@interface XHTagView : UIView

/**
 *  分支动画末梢圆圈的半径
 *
 *  默认值 3.0
 */
@property (nonatomic, assign) CGFloat radius;

/**
 *  获取标签视图是否显示，仅仅用于获取，不能赋值
 */
@property (nonatomic, assign, readonly) BOOL showing;

/**
 *  是否支持手势滑动TagView，默认是YES
 */
@property (nonatomic, assign) BOOL panGestureOnTagViewed;


@property (nonatomic, strong) NSMutableArray *branchPoints;
@property (nonatomic, strong) XHBranchLayer *topBranchLayer;
@property (nonatomic, strong) XHBranchLayer *midBranchLayer;
@property (nonatomic, strong) XHBranchLayer *bottomBranchLayer;

@property (nonatomic, strong) XHBranchTextView *topBranchTextView;
@property (nonatomic, strong) XHBranchTextView *midBranchTextView;
@property (nonatomic, strong) XHBranchTextView *bottomBranchTextView;

@property (nonatomic, strong) XHCenterView *centerView;

@property (nonatomic, assign) BOOL isChangedStyle;
//以下需要记录
/**
 *  动画方向
 */
@property (nonatomic, assign) XHTagAnimationStyle tagAnimationStyle;
/**
 *  标签分支的文本，总共三个
 */
@property (nonatomic, strong) NSMutableArray *branchTexts;
@property (nonatomic,assign)CGPoint centerLocationPoint;//起始位置

- (void)showInPoint:(CGPoint)point;
- (void)dismiss;
- (void)animation;

@end