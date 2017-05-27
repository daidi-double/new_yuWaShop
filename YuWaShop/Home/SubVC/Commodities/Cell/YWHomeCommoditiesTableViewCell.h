//
//  YWHomeCommoditiesTableViewCell.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/11/29.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeCommoditiesModel.h"

@interface YWHomeCommoditiesTableViewCell : UITableViewCell

@property (nonatomic,strong)YWHomeCommoditiesModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *conLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
