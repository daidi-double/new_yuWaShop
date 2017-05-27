//
//  ProgressView.h
//  YuWa
//
//  Created by double on 17/3/21.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
/**
 进度条色
 */
@property (nonatomic,strong)UIColor * progressColor;

/**
 进度条背景色
 */
@property (nonatomic,strong)UIColor * progressBackColor;

/**
 进度0~1
 */
@property (nonatomic,assign)CGFloat   proportion;

/**
 数据
 */
@property (nonatomic,strong)NSString * data;

/**
 数据名称
 */
@property (nonatomic,strong)NSString * dataName;
/**
 初始化方法
 @param frame 位置
 @param backColor 进度条背景色,默认白色
 @param color 进度条颜色
 */
-(instancetype)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor color:(UIColor *)color proportion:(CGFloat)proportion;

/**
 展示进度条
 */
-(void)showProgress;

/**
 展示数据内容
 */
-(void)showContentData;

- (instancetype)initWithFrame:(CGRect)frame andWithBusinessGrade:(NSString*)busnessGrade andWithProportion:(CGFloat)proportion;

@end
