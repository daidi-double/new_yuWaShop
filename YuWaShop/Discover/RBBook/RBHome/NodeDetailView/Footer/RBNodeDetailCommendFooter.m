//
//  RBNodeDetailCommendFooter.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/13.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeDetailCommendFooter.h"

@implementation RBNodeDetailCommendFooter

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setCommentCount:(NSString *)commentCount{
    if (!commentCount)return;
    _commentCount = commentCount;
    self.countLabel.text = [NSString stringWithFormat:@"查看全部%@条评论",commentCount];
}

- (void)tapAction{
    self.viewAllCommentBlock();
}

@end
