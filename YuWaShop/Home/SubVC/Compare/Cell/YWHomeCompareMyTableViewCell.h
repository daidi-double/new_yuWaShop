//
//  YWHomeCompareMyTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeCompareMyModel.h"

@interface YWHomeCompareMyTableViewCell : UITableViewCell

@property (nonatomic,strong)YWHomeCompareMyModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *compareLabel;

@end
