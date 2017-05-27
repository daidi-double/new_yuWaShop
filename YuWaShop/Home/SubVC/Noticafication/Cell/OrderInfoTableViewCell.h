//
//  OrderInfoTableViewCell.h
//  YuWaShop
//
//  Created by double on 17/4/8.
//  Copyright © 2017年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOrderModel.h"
@interface OrderInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) AllOrderModel * model;
@property (weak, nonatomic) IBOutlet UILabel *customer_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *create_timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *total_moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@end
