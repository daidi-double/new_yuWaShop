//
//  RBNodeBGView.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/9.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBNodeBGView : UIView

@property (nonatomic,copy)void (^publishBlock)();

@property (weak, nonatomic) IBOutlet UIView *nodeBGView;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;


@property (weak, nonatomic) IBOutlet UIView *aldumBGView;
@property (weak, nonatomic) IBOutlet UILabel *aldumLabel;

@property (nonatomic,assign)BOOL isNode;


@end
