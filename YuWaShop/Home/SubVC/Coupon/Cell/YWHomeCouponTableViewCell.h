//
//  YWHomeCouponTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/30.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeCouponModel.h"

@interface YWHomeCouponTableViewCell : UITableViewCell

@property (nonatomic,strong)YWHomeCouponModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *youhuiquanImageView;
@property (weak, nonatomic) IBOutlet UILabel *youhuiquanStrLabel;

@property (weak, nonatomic) IBOutlet UILabel *cutNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
