//
//  XHCenterView.h
//  XHTagView
//
//  Created by Jack_iMac on 16/2/22.
//  Copyright © 2016年 蒋威 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHCenterView : UIView

/**
 *  中心红点的按钮
 */
@property (nonatomic, strong) UIButton *button;

- (void)show;
- (void)dismiss;

- (void)startAnimation;
- (void)stopAnimation;

@end