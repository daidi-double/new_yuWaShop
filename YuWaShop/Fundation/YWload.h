//
//  YWload.h
//  YuWa
//
//  Created by L灰灰Y on 2017/5/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWload : UIImageView
+(instancetype)showOnView:(UIView*)view;
- (void)hide:(BOOL)animated;
- (void)show:(BOOL)animated;
@end
