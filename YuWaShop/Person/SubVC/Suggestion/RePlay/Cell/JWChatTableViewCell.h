//
//  JWChatTableViewCell.h
//  JWQQChat
//
//  Created by scjy on 16/4/17.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YWPSSellerRePlayModel.h"
#import "UIImage+JWImageReSize.h"

@interface JWChatTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *contentButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImageViewLeftEndge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLeftEndge;


@property (nonatomic,strong)YWPSRePlayModel * model;

@end
