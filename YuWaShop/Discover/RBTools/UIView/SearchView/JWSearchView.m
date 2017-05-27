//
//  MDSearchView.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "JWSearchView.h"

@implementation JWSearchView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5.f;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}


- (void)tapAction:(UITapGestureRecognizer *)sender {
//    MyLog(@"Search click");
    [self setUserInteractionEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setUserInteractionEnabled:YES];
    });
    self.searchClik();
}


@end
