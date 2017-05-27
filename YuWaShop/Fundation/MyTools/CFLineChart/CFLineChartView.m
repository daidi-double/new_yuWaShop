//
//  CFLineChartView.m
//  CFLineChartDemo
//
//  Created by TheMoon on 16/3/24.
//  Copyright © 2016年 CFJ. All rights reserved.
//

#import "CFLineChartView.h"

static CGRect myFrame;
static int count;
static int yCount;
static CGFloat everyX;
static CGFloat everyY;  
static CGFloat maxY;
static CGFloat allH;
static CGFloat allW;   
#define kMargin 30
@interface CFLineChartView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CFLineChartView

+ (instancetype)lineChartViewWithFrame:(CGRect)frame{
    CFLineChartView *lineChartView = [[NSBundle mainBundle] loadNibNamed:@"CFLineChartView" owner:self options:nil].lastObject;
    lineChartView.frame = frame;
    
    myFrame = frame;
    
    return lineChartView;
}


#pragma mark - Count

- (void)doWithCalculate{
    if (!self.xValues || !self.xValues.count || !self.yValues || !self.yValues.count) {
        return;
    }
    if (self.xValues.count > self.yValues.count) {
        NSMutableArray * xArr = [self.xValues mutableCopy];
        for (int i = 0; i < self.xValues.count - self.yValues.count; i++){
            [xArr removeLastObject];
        }
        self.xValues = [xArr mutableCopy];
    }else if (self.xValues.count < self.yValues.count){
        NSMutableArray * yArr = [self.yValues mutableCopy];
        for (int i = 0; i < self.yValues.count - self.xValues.count; i++){
            [yArr removeLastObject];
        }
        self.yValues = [yArr mutableCopy];
    }
    
    count = (int)self.xValues.count;
    
    everyX = (CGFloat)(CGRectGetWidth(myFrame) - kMargin * 2) / count;
    yCount = count <= 5 ? count : 5;
    
    everyY =  (CGRectGetHeight(myFrame) - kMargin * 2) / yCount;
    
    maxY = CGFLOAT_MIN;
    for (int i = 0; i < count; i ++) {
        if ([self.yValues[i] floatValue] > maxY) {
            maxY = [self.yValues[i] floatValue];
        }
    }
    
    allH = CGRectGetHeight(myFrame) - kMargin * 2;
    allW = CGRectGetWidth(myFrame) - kMargin * 2;
}

#pragma mark - Draw XY
- (void)drawXYLine{
    
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:CGPointMake(kMargin, kMargin / 2.0 - 5)];
    
    [path addLineToPoint:CGPointMake(kMargin, CGRectGetHeight(myFrame) - kMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 + 5, CGRectGetHeight(myFrame) - kMargin)];
    
    [path moveToPoint:CGPointMake(kMargin - 5, kMargin/ 2.0 + 4)];
    [path addLineToPoint:CGPointMake(kMargin, kMargin / 2.0 - 4)];
    [path addLineToPoint:CGPointMake(kMargin + 5, kMargin/ 2.0 + 4)];
    
    [path moveToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 - 4, CGRectGetHeight(myFrame) - kMargin - 5)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 + 5, CGRectGetHeight(myFrame) - kMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 - 4, CGRectGetHeight(myFrame) - kMargin + 5)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = CNaviColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 2.0;
    [self.bgView.layer addSublayer:layer];
}

#pragma mark - Add label
- (void)drawLabels{
    for(int i = 0; i <= yCount; i ++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kMargin  + everyY * i - everyY / 2, kMargin - 1, everyY)];
        lbl.textColor = [UIColor blackColor];
        lbl.font = [UIFont systemFontOfSize:12];
        //lbl.backgroundColor = [UIColor brownColor];
        lbl.textAlignment = NSTextAlignmentRight;
        lbl.text = [NSString stringWithFormat:@"%d", (int)(maxY / yCount * (yCount - i)) ];
        
        [self.bgView addSubview:lbl];
    }
    
    for(int i = 1; i <= count; i ++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(kMargin + everyX * i - everyX / 1.5f, CGRectGetHeight(myFrame) - kMargin, everyX, kMargin)];
        
        lbl.textColor = [UIColor blackColor];
        lbl.font = [UIFont systemFontOfSize:12];
        //lbl.backgroundColor = [UIColor brownColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.adjustsFontSizeToFitWidth = YES;
        lbl.text = [NSString stringWithFormat:@"%@", self.xValues[i - 1]];
        
        [self.bgView addSubview:lbl];
    }
    
}


#pragma mark - Draw Line
- (void)drawLines{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < yCount; i ++) {
        [path moveToPoint:CGPointMake(kMargin , kMargin + everyY * i)];
        [path addLineToPoint:CGPointMake(kMargin + allW ,  kMargin + everyY * i)];
    }
    for (int i = 1; i <= count; i ++) {
        [path moveToPoint:CGPointMake(kMargin + everyX * i, kMargin)];
        [path addLineToPoint:CGPointMake( kMargin + everyX * i,  kMargin + allH)];
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0.5;
    [self.bgView.layer addSublayer:layer];
    
}


#pragma mark - Draw Point
- (void)drawPointsWithPointType:(PointType)pointType{
    switch (pointType) {
        case PointType_Rect:
            
            for (int i = 0; i < count; i ++) {
                CGPoint point = CGPointMake(kMargin + everyX * (i + 1) , kMargin + (1 - [self.yValues[i] floatValue] / maxY ) * allH);
                CAShapeLayer *layer = [[CAShapeLayer alloc] init];
                layer.frame = CGRectMake(point.x - 2.5, point.y - 2.5, 5, 5);
                layer.backgroundColor = [UIColor colorWithHexString:@"#1296f5"].CGColor;
                [self.bgView.layer addSublayer:layer];
            }
            break;
            
        case PointType_Circel:
            for (int i = 0; i < count; i ++) {
                CGPoint point = CGPointMake(kMargin + everyX * (i + 1) , kMargin + (1 - [self.yValues[i] floatValue] / maxY ) * allH);
                
                UIBezierPath *path = [UIBezierPath
                                      
                                      //    方法1                          bezierPathWithArcCenter:point radius:2.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
                                      
                                      //    方法2
                                      bezierPathWithRoundedRect:CGRectMake(point.x - 2.5, point.y - 2.5, 5, 5) cornerRadius:2.5];
                
                
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.path = path.CGPath;
                layer.strokeColor = [UIColor colorWithHexString:@"#1296f5"].CGColor;
                layer.fillColor = [UIColor colorWithHexString:@"#1296f5"].CGColor;
                [self.bgView.layer addSublayer:layer];
            }

            break;
    }
}

#pragma mark - Draw Pillar
- (void)drawPillar{
    for (int i = 0; i < count; i ++) {
        CGPoint point = CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH);
        
//        CGFloat width = everyX <= 20 ? 10: 20;
        CGFloat width = everyX*2/3;
        
        CGRect rect = CGRectMake(point.x - width / 2, point.y, width, (CGRectGetHeight(myFrame) -  kMargin - point.y));
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;
        layer.strokeColor = [UIColor colorWithHexString:@"#1296f5"].CGColor;
        layer.fillColor = [UIColor colorWithHexString:@"#1296f5"].CGColor;
        
        [self.bgView.layer addSublayer:layer];

    }
    
}

#pragma mark - Draw Line
- (void)drawFoldLineWithLineChartType:(LineChartType)type{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // CGFloat allH = CGRectGetHeight(myFrame) - kMargin * 2;
    
    [path moveToPoint:CGPointMake(kMargin + everyX, kMargin + (1 - [self.yValues.firstObject floatValue] / maxY) * allH)];
    switch (type) {
        case LineChartType_Straight:
            for (int i = 1; i < count; i ++) {
                [path addLineToPoint:CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH)];
            }
            break;
        case LineChartType_Curve:
            
            for (int i = 1; i < count; i ++) {
        
                CGPoint prePoint = CGPointMake(kMargin + everyX * i, kMargin + (1 - [self.yValues[i-1] floatValue] / maxY) * allH);
                
                CGPoint nowPoint = CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH);
                
                [path addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            }
            break;
        
    }
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor colorWithHexString:@"#1296f5"].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    
    [self.bgView.layer addSublayer:layer];
    
}


#pragma mark - Draw Data
- (void)drawValues{
    for (int i = 0; i < count; i ++) {
        CGPoint nowPoint = CGPointMake(kMargin + everyX * (i + 1), kMargin + (1 - [self.yValues[i] floatValue] / maxY) * allH);
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(nowPoint.x - everyX/2.0-5, nowPoint.y - 20, everyX+10, 20)];
        lbl.textColor = [UIColor grayColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [NSString stringWithFormat:@"%@",self.yValues[i]];
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.adjustsFontSizeToFitWidth = YES;
        [self.bgView addSubview:lbl];
    }
    
}

#pragma mark - Draw
- (void)drawChartWithLineChartType:(LineChartType)lineType pointType:(PointType) pointType{
    [self doWithCalculate];
    
    NSArray *layers = [self.bgView.layer.sublayers mutableCopy];
    for (CAShapeLayer *layer in layers) {
        [layer removeFromSuperlayer];
    }
    if (self.isShowLine) {
        [self drawLines];
    }
    
    if(self.isShowPillar){
         [self drawPillar];
    }
    
    [self drawXYLine];
    
    [self drawLabels];
    
    if (self.isShowLineChart) {
        [self drawFoldLineWithLineChartType:lineType];
    }

    if (self.isShowPoint) {
        [self drawPointsWithPointType:pointType];
    }
    
    if(self.isShowValue){
        [self drawValues];
    }
    
}


@end
