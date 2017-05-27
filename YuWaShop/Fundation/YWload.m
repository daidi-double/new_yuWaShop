//
//  YWload.m
//  YuWa
//
//  Created by L灰灰Y on 2017/5/18.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "YWload.h"

@implementation YWload

-(instancetype)initWithView:(UIView *)view{
    if (self = [super init]) {
        YWload * imageView = [[YWload alloc]initWithFrame:CGRectMake(view.frame.size.width/2-30, view.frame.size.height/2-30, 60, 60)];
        imageView.alpha = 0.5;
        [view addSubview:imageView];
        NSMutableArray * arrimages = [NSMutableArray array];
        for (int i=1; i<40; i++) {
            NSString * path= [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"png"];
            [arrimages addObject:[UIImage imageWithContentsOfFile:path]];
        }
        
        imageView.animationImages = arrimages;
        imageView.animationDuration = 3;
        imageView.animationRepeatCount = 0;
        self = imageView;
    }
    return self;
}
- (void)hide:(BOOL)animated{
    [self stopAnimating];
    self.hidden = YES;
}
- (void)show:(BOOL)animated{
    self.hidden  = NO;
    [self startAnimating];
    
}
+(instancetype )showOnView:(UIView *)view{
 return  [[self alloc]initWithView:view];
}
@end
