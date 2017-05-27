//
//  YWMessageSearchFriendAddCell.h
//  YuWa
//
//  Created by Tian Wei You on 16/10/11.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWMessageSearchFriendAddModel.h"

@interface YWMessageSearchFriendAddCell : UITableViewCell

@property (nonatomic,strong)YWMessageSearchFriendAddModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
