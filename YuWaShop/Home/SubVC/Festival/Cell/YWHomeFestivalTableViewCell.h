//
//  YWHomeFestivalTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeFestivalModel.h"

@interface YWHomeFestivalTableViewCell : UITableViewCell

@property (nonatomic,strong)YWHomeFestivalModel * model;
@property (nonatomic,assign)NSInteger status;

@property (weak, nonatomic) IBOutlet UIView *BGView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *boardLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
