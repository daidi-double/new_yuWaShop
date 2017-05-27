//
//  RBCommentToolsView.m
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/14.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import "RBCommentToolsView.h"
@implementation RBCommentToolsView

- (IBAction)connectionAction:(id)sender {
    self.connectBlock();
}

- (IBAction)emojisBtnAction:(id)sender {
    self.isShowEmojis = !self.isShowEmojis;
    [self.emojisBtn setImage:[UIImage imageNamed:self.isShowEmojis == YES?@"RBChatBar_keyboard":@"RBChatBar_face"] forState:UIControlStateNormal];
    self.showEmojisBlock(self.isShowEmojis);
}

@end
