//
//  RBNodeDetailHeader.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBNodeUserModel.h"

@interface RBNodeDetailHeader : UIView

@property (nonatomic,copy)void (^otherBlock)();
@property (nonatomic,copy)void (^careBlock)();

@property (nonatomic,copy)void (^backToLoginBlock)();
@property (nonatomic,copy)void (^popBlock)();
@property (nonatomic,strong)NSString * node_id;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic,assign)BOOL isUser;//是否是自己
@property (nonatomic,copy)NSString * infavs;//是否收藏
@property (nonatomic,copy)NSString * is_fans;//是否关注
@property (nonatomic,strong)RBNodeUserModel * model;


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentiionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidth;


@end
