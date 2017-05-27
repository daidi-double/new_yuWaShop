//
//  RBNodeDetailCommentHeader.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBNodeDetailCommentHeader : UIView

@property (nonatomic,copy)void (^commentBlock)();

@property (nonatomic,copy)NSString * iconURL;
@property (nonatomic,assign)NSInteger commentCount;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;




@end
