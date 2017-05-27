//
//  CFLineChartView.h
//  CFLineChartDemo
//
//  Created by TheMoon on 16/3/24.
//  Copyright © 2016年 CFJ. All rights reserved.
//
//  本linechartview支持给出x、y值对
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LineChartType) {
    LineChartType_Straight,
    LineChartType_Curve
};
typedef NS_ENUM(NSInteger, PointType) {
    PointType_Rect,
    PointType_Circel
};

@interface CFLineChartView : UIView
@property (nonatomic, copy) NSArray *xValues;

@property (nonatomic, copy) NSArray *yValues;

@property (nonatomic, assign) bool isShowLine;
@property (nonatomic, assign) bool isShowPoint;
@property (nonatomic, assign) bool isShowPillar;
@property (nonatomic, assign) bool isShowValue;
@property (nonatomic, assign) bool isShowLineChart;
+ (instancetype)lineChartViewWithFrame:(CGRect)frame;

- (void)drawChartWithLineChartType:(LineChartType)lineType pointType:(PointType)pointType;

@end
