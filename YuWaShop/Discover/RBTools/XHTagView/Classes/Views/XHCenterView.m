//
//  XHCenterView.m
//  XHTagView
//
//  Created by Jack_iMac on 16/2/22.
//  Copyright © 2016年 蒋威 All rights reserved.
//

#import "XHCenterView.h"
#import "XHFocusLayer.h"

@interface XHCenterView ()

@property (nonatomic, strong) XHFocusLayer *focusLayer;

@end

@implementation XHCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    [self.layer addSublayer:self.focusLayer];
    [self addSubview:self.button];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = self.bounds;
}

- (void)show {
    self.alpha = 1.0;
}

- (void)dismiss {
    self.alpha = 0.0;
}

- (void)startAnimation {
    [self.focusLayer startAnimation];
}

- (void)stopAnimation {
    [self.focusLayer stopAnimation];
}

#pragma mark - Propertys

- (XHFocusLayer *)focusLayer {
    if (!_focusLayer) {
        _focusLayer = [XHFocusLayer new];
        _focusLayer.fromValueForRadius = 0.35;
        _focusLayer.position = [self tagCenterPoint];
    }
    return _focusLayer;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:[UIImage imageNamed:@"tag-center"] forState:UIControlStateNormal];
    }
    return _button;
}

- (CGPoint)tagCenterPoint {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return center;
}

@end


/*
 - (CAShapeLayer *)centerLayer {
 if (!_centerLayer) {
 UIBezierPath *path = [UIBezierPath new];
 [path addArcWithCenter:[self tagCenterPoint] radius:self.centerRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
 _centerLayer = [CAShapeLayer new];
 _centerLayer.path = path.CGPath;
 _centerLayer.lineWidth = 2.0;
 _centerLayer.strokeColor = [UIColor whiteColor].CGColor;
 _centerLayer.fillColor = [UIColor redColor].CGColor;
 }
 return _centerLayer;
 }
 */
