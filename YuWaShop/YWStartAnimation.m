//
//  YWStartAnimation.m
//  YuWa
//
//  Created by L灰灰Y on 2017/5/23.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWStartAnimation.h"

@interface YWStartAnimation ()
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation YWStartAnimation

-(instancetype)initWithView:(UIView* )view{
    if (self = [super init]) {
        YWStartAnimation *imageVIew   =[[YWStartAnimation alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        [imageVIew setImage:[UIImage imageNamed:@"beijingBG"]];
        [view addSubview:imageVIew];
        [view bringSubviewToFront:imageVIew];
        self = imageVIew;
    }
    return self;
}
+(void)startAnimationWithView:(UIView *)view{
    YWStartAnimation * imageView = [[YWStartAnimation alloc]initWithView:view];
    [imageView performSelector:@selector(scale_1) withObject:nil afterDelay:0.0f];
}

-(void)scale_1
{
    UIImageView *round_1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Height * 0.5f - 50, kScreen_Width*0.7, 172, 299)];
    round_1.centerX = kScreen_Width/2;
    round_1.image = [UIImage imageNamed:@"yuwashop"];
    round_1.alpha = 0.0;
    [self addSubview:round_1];
    [self setAnimation:round_1];
}


-(void)setAnimation:(UIImageView *)nowView
{
    
    [UIView animateWithDuration:1.f delay:0.0f options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         // 执行的动画code
         nowView.alpha = 1.0f;
         [nowView setFrame:CGRectMake(kScreen_Height * 0.5f - 50, kScreen_Width*0.45, 95, 164)];
         nowView.centerX = kScreen_Width/2;
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             
             UIImageView *word_ = [[UIImageView alloc]initWithFrame:CGRectMake(kScreen_Height/2, kScreen_Width +30, 170, 59)]; //423 148
             word_.centerX = kScreen_Width/2;
             word_.image = [UIImage imageNamed:@"toyou"];
             [self addSubview:word_];
             
             word_.alpha = 0.0;
             [UIView animateWithDuration:0.8f delay:0.0f options:UIViewAnimationOptionCurveLinear
                              animations:^
              {
                  word_.alpha = 1.0;
              }
                              completion:^(BOOL finished)
              {
                  [NSThread sleepForTimeInterval:1.0f];
                  [self removeFromSuperview];
              }];
         });
         
     }
     
     
                     completion:^(BOOL finished)
     {
         // 完成后执行code
         //         [nowView removeFromSuperview];
         // 完成后执行code
     }
     ];
}


@end
