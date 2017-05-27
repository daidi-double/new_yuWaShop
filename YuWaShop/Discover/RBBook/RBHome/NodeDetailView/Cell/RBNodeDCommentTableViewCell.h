//
//  RBNodeDCommentTableViewCell.h
//  NewVipxox
//
//  Created by Tian Wei You on 16/9/12.
//  Copyright © 2016年 WeiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBNodeShowCommentModel.h"

@interface RBNodeDCommentTableViewCell : UITableViewCell

@property (nonatomic,strong)RBNodeShowCommentModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *conLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conLabelHeight;


@end
