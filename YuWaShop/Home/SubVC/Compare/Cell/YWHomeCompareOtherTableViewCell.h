//
//  YWHomeCompareOtherTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeCompareOtherModel.h"

@interface YWHomeCompareOtherTableViewCell : UITableViewCell

@property (nonatomic,strong)YWHomeCompareOtherModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
