//
//  RBCommentToolsView.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/14.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBConnectionViewController.h"

@interface RBCommentToolsView : UIView

@property (nonatomic,copy)void (^connectBlock)();//@关注的用户
@property (nonatomic,copy)void (^showEmojisBlock)(BOOL);//显示表情

@property (nonatomic,assign)BOOL isShowEmojis;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITextField *sendTextField;
@property (weak, nonatomic) IBOutlet UIButton *emojisBtn;

@end
