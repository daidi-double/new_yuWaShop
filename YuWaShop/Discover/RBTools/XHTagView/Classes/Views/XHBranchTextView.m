//
//  XHBranchTextView.m
//  XHTagView
//
//  Created by Jack_iMac on 16/2/22.
//  Copyright © 2016年 蒋威 All rights reserved.
//

#import "XHBranchTextView.h"

@interface XHBranchTextView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation XHBranchTextView

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
    [self addSubview:self.textLabel];
    
    [self dismiss];
}

- (void)showInPoint:(CGPoint)point direction:(XHBranchLayerDirection)direction {
    [self.textLabel sizeToFit];
    
    CGFloat width = CGRectGetWidth(self.textLabel.bounds);
    CGFloat height = 21;
    
    CGRect frame = CGRectMake(point.x, point.y - height - 2.f, width, 21);
    
    if (direction == XHBranchLayerDirectionRight) {
        frame = CGRectMake(point.x - width, point.y - height - 2.f, width, 21);
    }
    
    if (!self.textLabel.text.length) {
        frame.size = CGSizeZero;
    }
    
    self.textLabel.center = CGPointMake(CGRectGetWidth(frame) / 2.0, CGRectGetHeight(frame) / 2.0);
    
    self.frame = frame;
//    self.arrowImageView.frame = self.bounds;
    
    
    self.alpha = 0.0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss {
    self.alpha = 0.0;
}

- (void)animation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.35;
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue = @(1.0);
    opacityAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.numberOfLines = 1.0;
        _textLabel.font = [UIFont systemFontOfSize:11];
        _textLabel.textColor = [UIColor whiteColor];
    }
    return _textLabel;
}

- (void)setBranchText:(NSString *)branchText {
    _branchText = branchText;
    self.textLabel.text = branchText;
}

@end
