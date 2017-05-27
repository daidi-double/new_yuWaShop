//
//  RBHomeSearchToolsView.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/18.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBHomeSearchToolsView : UIView
@property (nonatomic,copy)void (^typeChooseBlock)(NSInteger);
@property (nonatomic,assign)NSInteger type;//0笔记1用户

@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic,copy)NSString * searchKey;


@end
