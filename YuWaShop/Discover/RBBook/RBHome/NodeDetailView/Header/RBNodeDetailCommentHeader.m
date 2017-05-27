//
//  RBNodeDetailCommentHeader.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBNodeDetailCommentHeader.h"

@implementation RBNodeDetailCommentHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius = 16.f;
    self.iconImageView.layer.masksToBounds = YES;
    self.nameLabel.layer.cornerRadius = 5.f;
    self.nameLabel.layer.masksToBounds = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)setIconURL:(NSString *)iconURL{
    if (!iconURL)return;
    _iconURL = iconURL;
    self.nameLabel.text = self.commentCount == 0?@"    勾搭评论别害羞,聊骚要做第一人":self.commentCount < 5?@"    矜持点赞也可以,知音难觅聊一句":self.commentCount < 10?@"    据说评论才是聊笔记的最大动力哟": self.commentCount < 100?@"    想勾搭,先评论":@"    点赞都是套路,评论才是真诚";
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconURL] placeholderImage:[UIImage imageNamed:@"Head-portrait"] completed:nil];
}


- (void)tapAction{
    self.commentBlock();
}

@end
