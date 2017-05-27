//
//  XHBranchLayer.m
//  XHTagView
//
//  Created by Jack_iMac on 16/2/22.
//  Copyright © 2016年 蒋威 All rights reserved.
//

#import "XHBranchLayer.h"

@interface XHBranchLayer ()<CAAnimationDelegate>

@property (nonatomic, copy) XHBranchLayerAnimationCompletion completion;

@property (nonatomic, strong) CABasicAnimation *animation;

@end

@implementation XHBranchLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
        self.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (void)dealloc {
    self.completion = nil;
    [self cancelPrevious];
}

- (void)setup {
    self.strokeStart = 0;
    self.strokeEnd = 1;
    
    self.lineWidth = 1.0;
    
    self.toValue = 0.57;
    self.animationDuration = 0.55;
    
    self.strokeColor = [UIColor whiteColor].CGColor;//颜色
    self.fillColor = [UIColor clearColor].CGColor;
}

- (void)commitPath {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.path = nil;
    self.fillColor = [UIColor clearColor].CGColor;
    [CATransaction commit];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:self.startPoint];
    [path addLineToPoint:self.midPoint];
    [path addLineToPoint:self.endPoint];
    
    if (self.direction == XHBranchLayerDirectionRight) {
        CGPoint circlePoint = CGPointMake(self.endPoint.x + self.radius, self.endPoint.y);
        [path addArcWithCenter:circlePoint radius:self.radius startAngle:-M_PI endAngle:2 * M_PI / 2 clockwise:YES];
    } else {
        CGPoint circlePoint = CGPointMake(self.endPoint.x - self.radius, self.endPoint.y);
        
        [path addArcWithCenter:circlePoint radius:self.radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    }
    [path addLineToPoint:self.midPoint];
    [path closePath];
    
    self.strokeStart = 0.0;
    self.strokeEnd = 0.0;
    self.path = path.CGPath;
}

- (void)cancelPrevious {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)animationDelay:(NSTimeInterval)delay completion:(XHBranchLayerAnimationCompletion)completion {
    [self removeAllAnimations];
    [self cancelPrevious];
    [self commitPath];
    
    self.completion = completion;
    
    self.animation.beginTime = CACurrentMediaTime() + delay;
    [self addAnimation:self.animation forKey:@"strokeEnd"];
    
    [self performSelector:@selector(setFillColor:) withObject:(id)[UIColor colorWithWhite:1.0 alpha:0.5].CGColor afterDelay:delay + self.animationDuration];
}

- (CABasicAnimation *)animation {
    if (!_animation) {
        
        _animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _animation.delegate = self;
        _animation.fromValue = @(0);
        _animation.toValue = @(self.toValue);
        _animation.duration = self.animationDuration;
        _animation.fillMode = kCAFillModeForwards;
        _animation.removedOnCompletion = NO;
    }
    return _animation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.completion) {
        self.completion(flag, self);
    }
}

@end
